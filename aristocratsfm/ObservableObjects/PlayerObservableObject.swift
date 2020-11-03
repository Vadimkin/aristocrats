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

class PlayerObservableObject: AVPlayer, ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false

    static let shared = PlayerObservableObject()
    var cancellable: AnyCancellable?
    
    private var playerContext = 0
    
    var player: AVPlayer? = nil
    var playerItem: AVPlayerItem? = nil

    var stream: String?
    
    func playItem(at itemURL: String, stream: String) {
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
        self.stream = stream
        
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
        commandCenter.likeCommand.isEnabled = false
        
        commandCenter.bookmarkCommand.isEnabled = true
        commandCenter.bookmarkCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in  print("Add to Bookmarks");  return .success }
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player?.rate == 0.0 {
                self.player?.play()
                return .success
            }
            return .commandFailed
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player?.rate == 1.0 {
                self.player?.pause()
                return .success
            }
            return .commandFailed
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
    
    func setNowPlayingTrack(currentTrack: NowPlayingTrack) {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentTrack.song
        nowPlayingInfo[MPMediaItemPropertyArtist] = currentTrack.artist
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = true

        let albumArtwork = getNowPlayingArtwork()
        nowPlayingInfo[MPMediaItemPropertyArtwork] = albumArtwork
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func getNowPlayingArtwork() -> MPMediaItemArtwork {
        // TODO Fetch from resource
        let canvasSize = CGSize(width: 512, height: 512)
        
        let renderer = UIGraphicsImageRenderer(size: canvasSize)
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(Design.Primary.Base.cgColor!)
            ctx.cgContext.addRect(CGRect(x: 0, y: 0, width: canvasSize.width, height: canvasSize.height))
            ctx.cgContext.drawPath(using: .fillStroke)

            var image = UIImage(named: "AristocratsLogoWhite")!
            image = image.resized(to: CGSize(width: image.size.width * 0.6, height: image.size.height * 0.6))

            let imagePaddingX = (canvasSize.width - image.size.width) / 2
            let imagePaddingY = (canvasSize.height - image.size.height) / 2
            
            let imageRect: CGRect = CGRect(x:imagePaddingX, y:imagePaddingY, width:image.size.width, height:image.size.height);

            image.draw(in: imageRect)
        }

        let albumArtwork = MPMediaItemArtwork.init(boundsSize: canvasSize, requestHandler: { (size) -> UIImage in
            return img
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
