import Foundation
import Combine

// MARK: - URLs -

extension URL {
    enum Music {
        static let nowPlaying = URL(string: "https://aristocrats.fm/service/nowplaying-aristocrats8.xml")!

        static func musicBrainz(artist: String, song: String) -> URL {
            var components = URLComponents(string: "https://musicbrainz.org/ws/2/recording")!
            components.queryItems = [
                .init(name: "query", value: "artistname:\"\(artist)\" AND recording:\"\(song)\""),
                .init(name: "inc", value: "releases"),
                .init(name: "fmt", value: "json"),
                .init(name: "limit", value: "1")
            ]
            return components.url!
        }

        static func coverArt(id: String) -> URL {
            URL(string: "https://coverartarchive.org/release/\(id)")!
        }
    }
}

// MARK: - Models -

struct NowPlaying: Equatable {
    let artist: String
    let song: String
}

struct MusicBrainz: Decodable, Equatable {
    let recordings: [Recordings]
    
    struct Recordings: Decodable, Equatable {
        let id: String
        let releases: [Releases]
        
        struct Releases: Decodable, Equatable {
            let id: String
        }
    }
}

struct CoverArt: Decodable, Equatable {
    let images: [Image]
    
    struct Image: Decodable, Equatable {
        let image: String
    }
}

enum Playback: Equatable {
    case nothing
    case playing(_ playing: NowPlaying, _ coverArt: CoverArt?)
}

// MARK: - Parsing -

final class NowPlayingParserDelegate: NSObject, XMLParserDelegate {
    static let shared = NowPlayingParserDelegate()

    private var artist: String?
    private var song: String?
    private var error: Error?
    
    func build() throws -> NowPlaying? {
        if let artist = artist, let song = song {
            return NowPlaying(artist: artist, song: song)
        } else if let error = error {
            throw error
        }

        return nil
    }
    
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        switch elementName {
        case "artist":
            artist = attributeDict["title"]

        case "song":
            song = attributeDict["title"]

        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        artist = nil
        song = nil
    }
}

extension JSONDecoder {
    static let shared = JSONDecoder()
}

// MARK: - Publishers -

extension Publishers {
    static func nowPlaying() -> AnyPublisher<NowPlaying?, Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL.Music.nowPlaying)
            .tryMap { response -> NowPlaying? in
                let delegate: NowPlayingParserDelegate = .shared

                let parser = XMLParser(data: response.data)
                parser.delegate = delegate
                
                return parser.parse() ? try delegate.build() : nil
            }
            .eraseToAnyPublisher()
    }

    static func musicBrainzPublisher(
        artist: String,
        song: String
    ) -> AnyPublisher<MusicBrainz, Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL.Music.musicBrainz(artist: artist, song: song))
            .map { $0.data }
            .decode(type: MusicBrainz.self, decoder: JSONDecoder.shared)
            .eraseToAnyPublisher()
    }

    static func coverArtArchivePublisher(id: String) -> AnyPublisher<CoverArt, Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL.Music.coverArt(id: id))
            .map { $0.data }
            .decode(type: CoverArt.self, decoder: JSONDecoder.shared)
            .eraseToAnyPublisher()
        
    }
}

// MARK: - Extensions -

extension Publisher {
    func replaceErrorWithNil<ReplaceFilure: Error>(
        _ failureType: ReplaceFilure.Type
    ) -> AnyPublisher<Output?, ReplaceFilure> {
        map { (output: Output) -> Output? in
            output
        }
        .replaceError(with: nil)
        .setFailureType(to: failureType)
        .eraseToAnyPublisher()
    }
    
    func wrapInResult<WrappedOutput>(
        _ replacement: @escaping (Output) -> WrappedOutput
    ) -> AnyPublisher<Result<WrappedOutput, Failure>, Never> {
        map {
            Result<WrappedOutput, Failure>.success(replacement($0))
        }.eraseToAnyPublisher()
        .catch { error -> AnyPublisher<Result<WrappedOutput, Failure>, Never> in
            Just(Result<WrappedOutput, Failure>.failure(error))
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }

    func wrapInResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        wrapInResult { $0 }
    }
}

// MARK: - Main -

let cancellable = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()
    .flatMap { _ in Publishers.nowPlaying() }
    .removeDuplicates()
    .flatMap { nowPlaying -> AnyPublisher<(NowPlaying, MusicBrainz?)?, Error> in
        if let nowPlaying = nowPlaying {
            return Publishers.musicBrainzPublisher(
                artist: nowPlaying.artist,
                song: nowPlaying.song
            )
            .replaceErrorWithNil(Error.self)
            .map {
                (nowPlaying, $0)
            }
            .eraseToAnyPublisher()
        }

        return Just(nil)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    .flatMap { (nowPlayingMusicBrainz) -> AnyPublisher<(NowPlaying, CoverArt?)?, Error> in
        guard let nowPlayingMusicBrainz = nowPlayingMusicBrainz else {
            return Just(nil)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        guard
            let musicBrainz = nowPlayingMusicBrainz.1,
            let releaseId = musicBrainz.recordings.first?.releases.first?.id
        else {
            return Just((nowPlayingMusicBrainz.0, nil))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        return Publishers.coverArtArchivePublisher(id: releaseId)
            .replaceErrorWithNil(Error.self)
            .map {
                (nowPlayingMusicBrainz.0, $0)
            }
            .eraseToAnyPublisher()
    }
    .map { nowPlayingCoverArt in
        nowPlayingCoverArt.map {
            Playback.playing($0.0, $0.1)
        } ?? Playback.nothing
    }
    .wrapInResult()
    .sink { result in
        do {
            switch try result.get() {
            case .nothing:
                print("Nothing playing right now.")
            case let .playing(playing, coverArt):
                print("Now playing: \(playing.song) - \(playing.song) [\(coverArt?.images.first?.image ?? "no cover")]")
            }
        } catch {
            debugPrint(error)
        }
    }
