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
    
    static let shared = PlayerObservableObject()
    var cancellable: AnyCancellable?
    
    private var playerContext = 0
    
    var player: AVPlayer? = nil
    var stream: String?
    
    func playItem(at itemURL: String, stream: String) {
        guard let url = URL(string: itemURL) else { return }
        
        self.isLoading = true
        
        // cleanup for previous player
        self.player?.removeObserver(self, forKeyPath: "timeControlStatus")
        
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        try? AVAudioSession.sharedInstance().setActive(true)
        
        // setup new player
        let newPlayer = AVPlayer(url: url)
        newPlayer.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: &playerContext)
        
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
//        let nowPlayingObservableObject = NowPlayingObservableObject.shared
//        cancellable = nowPlayingObservableObject.publisher.sink{ [weak self] in
//            guard let self = self else {return}
            
//            let currentTrackMetadata = nowPlayingObservableObject.nowPlaying[self.stream!]
//            self.setNowPlayingTrack(currentTrack: currentTrackMetadata!)
//        }
    }
    
    func setNowPlayingTrack(currentTrack: NowPlayingTrack) {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentTrack.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = currentTrack.artist
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = true
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
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
        
        if self.player?.timeControlStatus == .playing {
            self.isPlaying = true
            self.isLoading = false
        }
        if self.player?.timeControlStatus == .paused {
            self.isPlaying = false
            self.isLoading = false
        }
        if self.player?.timeControlStatus == .waitingToPlayAtSpecifiedRate {
            self.isPlaying = false
            self.isLoading = true
        }
    }
}
