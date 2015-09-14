class SelectedSongsManager {
    static let manager = SelectedSongsManager()   // for Singleton
    var selectedSongInfos: [SelectedSong] = []
    var selectedIds: [Int] = []

    private init() {}

    func appendPlaylists(playlists: [Playlist]) {
        for p in playlists {
            for song in p.songs {
                self.selectedSongInfos.append(SelectedSong(song: song, playlistName: p.title, playlistId: p.id))
            }
        }
    }
    
    func moveSelectedSongInfo(from: Int, to: Int) {
        let tmp = selectedIds.removeAtIndex(from)
        selectedIds.insert(tmp, atIndex: to)
    }

    func appendSongs(songs: [Song]) {
        for song in songs {
            let selected = SelectedSong(song: song, playlistName: nil, playlistId: nil)

            if isExistSongs(selected) {
                self.selectedSongInfos.append(selected)
            }
        }
    }

    func selectedSongs() -> [Song] {
        return map(selectedSongInfos) { return $0.song }
    }

    func selectedSongInfo() -> [SelectedSong] {
        return map(selectedIds) { return self.selectedSongInfos[$0] }
    }

    func reset() {
        selectedSongInfos = []
        selectedIds = [] // TODO remove this line to perpetuate selected item
    }

    private func isExistSongs(song: SelectedSong) -> Bool {
        if song.song.id != 0 {
            let ids = map(selectedSongInfos) { return $0.song.id }
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

struct SelectedSong {
    var song: Song
    var playlistName: String?
    var playlistId: Int?
}
