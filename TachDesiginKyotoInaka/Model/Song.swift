import Foundation
import RealmSwift
import ObjectMapper

class Song: Object {
    static let realm = Realm()

    dynamic var id = 1
    dynamic var title = ""
    dynamic var artist = ""
    dynamic var artworkUrl = ""
    dynamic var itunesTrackId = ""       // trackID in iTunes API JSON
    dynamic var previewUrl = ""

    override static func primaryKey() -> String? {
        return "id"
    }

    static func lastId() -> Int {
        if let song = realm.objects(Song).last {
            return song.id + 1
        } else {
            return 1
        }
    }

    static func all() -> [Song] {
        let songs = realm.objects(Song)
        var ret: [Song] = []

        for song in songs {
            ret.append(song)
        }
        return ret
    }
}

extension Song: Selectable {
   func selected() -> [Song] {
        return [self]
    }
}

extension Song: Mappable {
    static func newInstance(map: Map) -> Mappable? {
        return Song()
    }

    func mapping(map: Map) {
        title <- map["trackName"]
        artist <- map["artistName"]
        previewUrl <- map["previewUrl"]
        artworkUrl <- map["artworkUrl100"]
        itunesTrackId <- map["trackId"]
    }
}
