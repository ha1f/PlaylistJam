import Foundation
import RealmSwift

class Playlist: Object {
    static let realm = Realm()

    dynamic var id = 0
    dynamic var title = ""
    dynamic var desc = ""

    override static func primaryKey() -> String? {
        return "id"
    }

    static func lastId() -> Int {
        return realm.objects(Playlist).last!.id
    }

    static func create() -> Bool {
        return true
    }
}
