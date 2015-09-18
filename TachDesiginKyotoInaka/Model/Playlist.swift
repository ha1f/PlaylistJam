import Foundation
import RealmSwift

class Playlist: Object {
    static let realm = try! Realm()

    dynamic var id = 1
    dynamic var title = ""
    dynamic var desc = ""
    var songs =  List<Song>()

    override static func primaryKey() -> String? {
        return "id"
    }

    static func createWithSongs(title: String, desc: String, songs: [Song]) -> Playlist {
        let playlist = Playlist()
        playlist.title = title
        playlist.desc = desc
        for s in songs {
            playlist.songs.append(s)
        }

        return playlist
    }

    static func createWithSongAndInit(config: [String:String], songs: [Song]) -> Playlist {
        let playlist = Playlist()
        playlist.title = config["title"] ?? ""
        playlist.desc = config["desc"]  ?? ""
        playlist.id = lastId()

        var i = Song.lastId()
        for s in songs {
            let ss = Song()
            ss.title = s.title
            ss.artist = s.artist
            ss.artworkUrl = s.artworkUrl
            ss.previewUrl = s.previewUrl
            ss.id = i
            i++
            playlist.songs.append(ss)
        }

        try! realm.write {
            self.realm.add(playlist)
        }
        return playlist
    }

    static func createWithSong(config: [String: String], songs: [Song]) -> Playlist {
        let playlist = Playlist()
        playlist.title = config["title"] ?? ""
        playlist.desc = config["desc"]  ?? ""
        playlist.id = lastId()

        var i = Song.lastId()
        for s in songs {
            s.id = i
            i++
            playlist.songs.append(s)
        }

        try! realm.write {
            self.realm.add(playlist)
        }
        return playlist
    }

    static func createWithSongWithoutSave(config: [String: String], songs: [Song]) -> Playlist {
        let playlist = Playlist()
        playlist.title = config["title"] ?? ""
        playlist.desc = config["desc"]  ?? ""
        playlist.id = lastId()
        return playlist
    }

    static func all() -> [Playlist] {
        let playlists = realm.objects(Playlist).sorted("id", ascending: false)
        var ret: [Playlist] = []

        for playlist in playlists {
            ret.append(playlist)
        }

        return ret
    }

    static func lastId() -> Int {
        if let playlist = realm.objects(Playlist).last {
            return playlist.id + 1
        } else {
            return 1
        }
    }

    func songsArray() -> [Song] {
        var songs: [Song] = []
        for song in self.songs {
            songs.append(song)
        }

        return songs
    }
}

extension Playlist: Selectable {
    func selected() -> [Song] {
        return songsArray()
    }
}
