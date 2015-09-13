class SampleData {
    let maxPlaylistSongs: Int = 8

    func fetchDataAnd(completion: (([Playlist], [Song]) -> Void)) {
        var playlists: [Playlist] = []
        var i = 0

        ItunesApi.api.fetchSongs { (songs) in
            var _songs: [Song] = []

            for s in songs {
                if i < self.maxPlaylistSongs {
                    _songs.append(s)
                    i++
                } else {
                    playlists.append(Playlist.createWithSongs(s.title, songs: _songs))
                    _songs = [s]
                    i = 1
                }
            }

            completion(playlists, songs)
        }
    }
}