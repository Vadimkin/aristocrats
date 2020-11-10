//
//  PlayerObservableObject.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 30.09.2020.
//

import Foundation
import AVFoundation
import MediaPlayer
import Combine
import CoreData

class PlayerObservableObject: AVPlayer, ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    
    private let dataController: DataController = DataController.shared
    private var moc = DataController.shared.container.viewContext

    static let shared = PlayerObservableObject()
    var cancellable: AnyCancellable?
    
    private var playerContext = 0
    
    var player: AVPlayer? = nil
    var playerItem: AVPlayerItem? = nil
    
    func playItem(at itemURL: String) {
        guard let url = URL(string: itemURL) else { return }
        
        self.isLoading = true
        
        // cleanup for previous player
        self.player?.removeObserver(self, forKeyPath: "timeControlStatus")
        self.playerItem?.removeObserver(self, forKeyPath: "status")
        
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        try? AVAudioSession.sharedInstance().setActive(true)
        
        // setup new player
        let playerItem = AVPlayerItem(url: url)
        playerItem.addObserver(self, forKeyPath: "status", options: [.old, .new], context: &playerContext)

        let newPlayer = AVPlayer(playerItem: playerItem)
        newPlayer.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: &playerContext)
 
        self.playerItem = playerItem
        self.player = newPlayer
        
        setupRemoteTransportControls()
        setupNowPlayingInfoCenter()
    }
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Disable all next/previous buttons
        commandCenter.nextTrackCommand.isEnabled = false
        commandCenter.skipForwardCommand.isEnabled = false
        commandCenter.skipBackwardCommand.isEnabled = false
        
        commandCenter.bookmarkCommand.isEnabled = true
        commandCenter.bookmarkCommand.addTarget { [unowned self] commandEvent in
            let nowPlayingObservableObject = NowPlayingObservableObject.shared

            if case let .playing(track, _) = nowPlayingObservableObject.playback {
                if (!track.isLive) {
                    let isSuccess = self.addToFavorites(track: track)
                    if (isSuccess) {
                        return .success
                    }
                }
            }
            return .commandFailed
        }
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            // Looks like we need to reinitialize playItem and player both
            playItem(at: Streams.Main.URI)
            self.player?.play()
            return .success
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            self.player?.pause()
            return .success
        }
    }
    
    func setupNowPlayingInfoCenter() {
        let nowPlayingObservableObject = NowPlayingObservableObject.shared
        
        let subscriber = Subscribers.Sink<Playback, Never>(
            receiveCompletion: {
               completion in
          }) { value in
            if case let .playing(track, _) = value {
                self.setNowPlayingTrack(currentTrack: track)
            }
         }
        
        nowPlayingObservableObject.$playback.subscribe(subscriber)
    }
    
    func setNowPlayingTrack(currentTrack: AristocratsTrack) {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentTrack.song
        nowPlayingInfo[MPMediaItemPropertyArtist] = currentTrack.artist
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = true

        let albumArtwork = getNowPlayingArtwork()
        nowPlayingInfo[MPMediaItemPropertyArtwork] = albumArtwork
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func addToFavorites(track: AristocratsTrack) -> Bool {
        // TODO Move to DataController
        let fetchRequest = NSFetchRequest<Favorite>(entityName: "Favorite")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "artist = %@ ", track.artist),
            NSPredicate(format: "song = %@ ", track.song)
        ])
        
        let favoritesObjects = try? moc.count(for: fetchRequest)
        if let favoritesObjectsUnwrapped = favoritesObjects {
            if favoritesObjectsUnwrapped > 0 {
                return false;
            }
        }
        
        try? self.dataController.insertFavoriteTrack(track: track)
        return true
    }
    
    func getNowPlayingArtwork() -> MPMediaItemArtwork {
        // TODO Fetch from resource
        let canvasSize = CGSize(width: 512, height: 512)

        let albumArtwork = MPMediaItemArtwork.init(boundsSize: canvasSize, requestHandler: { (size) -> UIImage in
            return UIImage(named: "AristocratsCat")!
        })
        
        return albumArtwork
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        guard context == &playerContext else { // give super to handle own cases
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        if (keyPath == "timeControlStatus") {
            if self.player?.timeControlStatus == .playing {
                self.isPlaying = true
                self.isLoading = false
                self.isError = false
            }
            if self.player?.timeControlStatus == .paused {
                self.isPlaying = false
                self.isLoading = false
                self.isError = false
            }
            if self.player?.timeControlStatus == .waitingToPlayAtSpecifiedRate {
                self.isPlaying = false
                self.isLoading = true
                self.isError = false
            }
        }
        
        if (keyPath == "status") {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            if case .failed = status {
                self.isPlaying = false
                self.isLoading = false
                self.isError = true
            }
        }
    }
}
