//
//  FirebaseAnalytics.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 20.11.2020.
//

import Foundation
import FirebaseAnalytics

enum FirebaseAnalyticsTrackSource: String {
    case nowPlayingInfoCenter = "now_playing_info_center"
    case playlist = "playlist"
    case mainScreen = "main_screen"
}

struct FirebaseAnalytics {
    enum AnalyticsEvents {
        static let TrackLike = "track_like"
        static let TrackShare = "track_share"
        static let TelegramChatOpen = "telegram_chat_open"
    }

    static func logTrackLike(track: AristocratsTrack, source: FirebaseAnalyticsTrackSource) {
        Analytics.logEvent(AnalyticsEvents.TrackLike, parameters: [
            "artist": track.artist as NSObject,
            "song": track.song as NSObject,
            "source": source.rawValue as NSObject
        ])
    }

    static func logTrackLike(track: AristocratsPlaylistTrack, source: FirebaseAnalyticsTrackSource) {
        Analytics.logEvent(AnalyticsEvents.TrackLike, parameters: [
            "artist": track.artist as NSObject,
            "song": track.song as NSObject,
            "source": source.rawValue as NSObject
        ])
    }

    static func logTrackShare(track: AristocratsTrack) {
        Analytics.logEvent(AnalyticsEvents.TrackShare, parameters: [
            "artist": track.artist as NSObject,
            "song": track.song as NSObject
        ])
    }

    static func logTelegramChatOpen() {
        Analytics.logEvent(AnalyticsEvents.TelegramChatOpen, parameters: [
            "from": "main_screen" as NSObject
        ])
    }
}
