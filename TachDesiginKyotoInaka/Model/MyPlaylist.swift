import Foundation
import RealmSwift

class MyPlaylist: Object {
    private var playlists: Array<Playlist>!

    func getPlayLists() -> Array<Playlist>! {
        return self.playlists
    }
}