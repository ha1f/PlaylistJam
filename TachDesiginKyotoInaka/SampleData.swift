class SampleData {
    let maxPlaylistSongs: Int = 8

    func fetchPlaylistsAnd(completion: ([Playlist] -> Void)) {
        var playlists: [Playlist] = []
        var i = 0

        ItunesApi.api.fetchSongs { (songs) in
            var _songs: [Song] = []

            for s in songs {
                if i < self.maxPlaylistSongs {
                    _songs.append(s)
                    i++
                } else {
                    playlists.append(Playlist.createWithSongs("awesome", songs: _songs))
                    _songs = [s]
                    i = 1
                }
            }

            completion(playlists)
        }
    }
}