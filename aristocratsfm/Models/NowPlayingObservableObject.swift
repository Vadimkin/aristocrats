//
//  NowPlayingObservableObject.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 03.10.2020.
//

import Foundation
import Combine
import Alamofire
import SwiftyXMLParser

class NowPlayingObservableObject: ObservableObject {
    @Published var nowPlaying: [String: AristocratsTrack] = [
        Streams.Main.Name: AristocratsTrack(),
        Streams.Music.Name: AristocratsTrack(),
        Streams.Jazz.Name: AristocratsTrack()
    ]

    static let shared = NowPlayingObservableObject()

    let updatePublisher = PassthroughSubject<Void, Never>()
    var publisher: AnyPublisher<Void, Never>! = nil

    init() {
        let timerInterval = 5.0;

        // TODO Is it correct [?]
        publisher = Timer.publish(every: timerInterval, on: RunLoop.main, in: .common).autoconnect().map{_ in}.eraseToAnyPublisher()
        Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(timerDidFire), userInfo: nil, repeats: true)
    }
    
    @objc func timerDidFire() {
        updatePublisher.send()
        
        self.updateStreams()
    }

    func updateStreams() {
        for stream in SupportedStreams {
            AF.request(stream.NowPlayingTrackURI).responseData { response  in
                if let data = response.data {
                    let xml = XML.parse(data)
                    
                    // TODO Find a way to optimize [?]
                    // FIXME For live stream mode artist and title may be empty
                    if let artist = xml.Playlist.artist.attributes["title"] {
                        self.nowPlaying[stream.Name]?.artist = artist
                    }
                    
                    if let title = xml.Playlist.song.attributes["title"] {
                        self.nowPlaying[stream.Name]?.title = title
                    }
                    
                    self.updateArtwork(streamName: stream.Name)
                }
            }
        }
    }
    
    func updateArtwork(streamName: String) {
        // TODO Refactor this
        // Fetch Release UUID → Fetch cover art of release
        let artist = self.nowPlaying[streamName]?.artist
        let recording = self.nowPlaying[streamName]?.title
        if (artist == "Аристократи" || recording == "") {
            return
        }
//        let artist = "James Morrison" // artistocratsTrack.artist
//        let recording = "Lithium" // artistocratsTrack.title
        let searchQuery = "artistname:\"\(artist!)\" AND recording:\"\(recording!)\""
        let musicbrainzQuery = ["query": searchQuery, "inc": "releases", "fmt": "json"]
        let musicbrainzRecordingURI = "\(MusicbrainzAPIHost)ws/2/recording/"
 
        AF.request(musicbrainzRecordingURI, parameters: musicbrainzQuery).responseString { response in
            let apiResponse = MusicBrainzArtworkAPIResponse(JSONString: response.value!)
            print("Count is ", apiResponse!.recordings.count)
            if apiResponse!.recordings.count > 0 {
                let artworkUUID: String? = apiResponse!.recordings[0].releases[0].id
                
                if (artworkUUID != nil) {
                    let coverArtURI = "\(CoverArtAPIHost)/release/\(artworkUUID ?? "")"
                    AF.request(coverArtURI).responseString { response in
                        let coverArtResponse = CoverArtReleaseAPIResponse(JSONString: response.value!)
                        if (coverArtResponse?.images[0].image != nil) {
                            self.nowPlaying[streamName]?.coverArtURI = coverArtResponse?.images[0].image
                        }
                    }
                }
            }
        }
    }
}
