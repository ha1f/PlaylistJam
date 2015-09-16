class SongsManager {
    static let manager = SongsManager()   // for Singleton
    var appendedSongInfos: [AppendedSongInfo] = []
    var selectedIds: [Int] = []

    private init() {}

    func appendPlaylists(playlists: [Playlist]) {
        for playlist in playlists {
            self.appendedSongInfos += map(playlist.songs) {
                AppendedSongInfo(song: $0, playlistName: playlist.title, playlistId: playlist.id)
            }
        }
    }

    func appendSongs(songs: [Song]) {
        for song in songs {
            let selected = AppendedSongInfo(song: song, playlistName: nil, playlistId: nil)

            self.appendedSongInfos.append(selected)
        }
    }

    func appendedSongs() -> [Song] {
        return map(appendedSongInfos) { return $0.song }
    }

    func appendedSongCount() -> Int {
        return appendedSongInfos.count
    }

    func findFromAppendedSongInfo(i: Int) -> AppendedSongInfo {
        return appendedSongInfos[i]
    }

    func moveSelectedSongInfo(from: Int, to: Int) {
        let tmp = selectedIds.removeAtIndex(from)
        selectedIds.insert(tmp, atIndex: to)
    }

    func selectedSongInfo() -> [AppendedSongInfo] {
        return map(selectedIds) { return self.appendedSongInfos[$0] }
    }

    func selectedSongs() -> [Song] {
        return map(selectedSongInfo()) { return $0.song }
    }

    func selectedSongCount() -> Int {
        return selectedIds.count
    }
    func findFormSelectedSongInfo(i: Int) -> AppendedSongInfo {
        let idx = selectedIds[i]
        return appendedSongInfos[idx]
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

    func removeSongInfo(selectedId: Int) {
        if let idx = find(selectedIds, selectedId) {
            self.selectedIds.removeAtIndex(idx)
        }
    }

    func selectSongInfo(selectedId: Int) {
        selectedIds.append(selectedId)
    }
}

struct AppendedSongInfo {
    var song: Song
    var playlistName: String?
    var playlistId: Int?
}
