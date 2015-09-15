class SelectedSongsManager {
    static let manager = SelectedSongsManager()   // for Singleton
    var appendedSongInfos: [AppendedSongInfo] = []
    var selectedIds: [Int] = []

    private init() {}

    func appendPlaylists(playlists: [Playlist]) {
        for p in playlists {
            for song in p.songs {
                self.appendedSongInfos.append(AppendedSongInfo(song: song, playlistName: p.title, playlistId: p.id))
            }
        }
    }
    
    func moveSelectedSongInfo(from: Int, to: Int) {
        let tmp = selectedIds.removeAtIndex(from)
        selectedIds.insert(tmp, atIndex: to)
    }

    func appendSongs(songs: [Song]) {
        for song in songs {
            let selected = AppendedSongInfo(song: song, playlistName: nil, playlistId: nil)

            if isExistSongs(selected) {
                self.appendedSongInfos.append(selected)
            }
        }
    }

    func selectedSongs() -> [Song] {
        return map(appendedSongInfos) { return $0.song }
    }

    func selectedSongInfo() -> [AppendedSongInfo] {
        return map(selectedIds) { return self.appendedSongInfos[$0] }
    }

    func reset() {
        appendedSongInfos = []
        selectedIds = [] // TODO remove this line to perpetuate selected item
    }

    private func isExistSongs(song: AppendedSongInfo) -> Bool {
        if song.song.id != 0 {
            let ids = map(appendedSongInfos) { return $0.song.id }
            return contains(ids, song.song.id)
        }
        return false
    }

    func removeSongInfoById(selectedId: Int) {
        if let idx = find(selectedIds, selectedId) {
            self.selectedIds.removeAtIndex(idx)
        }
    }

    func selectSongInfoById(selectedId: Int) {
        selectedIds.append(selectedId)
    }
}

struct AppendedSongInfo {
    var song: Song
    var playlistName: String?
    var playlistId: Int?
}
