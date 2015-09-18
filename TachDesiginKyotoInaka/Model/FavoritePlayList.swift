import Foundation
import RealmSwift

class FavoritePlayList: Object {
    static let realm = try! Realm()
    dynamic var id = 0

    override static func primaryKey() -> String? {
        return "id"
    }
}