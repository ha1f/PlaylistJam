import Foundation
import RealmSwift
import ObjectMapper

class Song: Object {
    static let realm = Realm()

    dynamic var id = 0
    dynamic var title = ""
    dynamic var artist = ""
    dynamic var artworkUrl = ""
    dynamic var itunesTrackId = ""       // trackID in iTunes API JSON
    dynamic var previewUrl = ""

    override static func primaryKey() -> String? {
        return "id"
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
        artworkUrl <- map["artworkUrl30"]
        itunesTrackId <- map["trackId"]
    }
}