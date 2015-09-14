class SelectedSongsManager {
    static let manager = SelectedSongsManager()   // for Singleton
    var selectedSongsInfo: [SelectedSong] = []

    private init() {}

    func appendPlaylists(playlists: [Playlist]) {
        for p in playlists {
            for song in p.songs {
                self.selectedSongsInfo.append(SelectedSong(song: song, playlistName: p.title, playlistId: p.id))
            }
        }
    }

    func appendSongs(songs: [Song]) {
        for song in songs {
            let selected = SelectedSong(song: song, playlistName: nil, playlistId: nil)

            if isExistSongs(selected) {
                self.selectedSongsInfo.append(selected)
            }
        }
    }

    func selectedSongs() -> [Song] {
        return map(selectedSongsInfo) { return $0.song }
    }

    func reset() {
        selectedSongsInfo = []
    }

    private func isExistSongs(song: SelectedSong) -> Bool {
        if song.song.id != 0 {
            let ids = map(selectedSongsInfo) { return $0.song.id }
            return contains(ids, song.song.id)
        }
        return false
    }

    func selectSongInfoById(selectedId: Int) -> SelectedSong {
        return selectedSongsInfo[selectedId]
    }
}

struct SelectedSong {
    var song: Song
    var playlistName: String?
    var playlistId: Int?
}
