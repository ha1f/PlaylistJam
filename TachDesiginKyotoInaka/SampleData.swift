class SampleData {
    let maxPlaylistSongs: Int = 8

    func fetchDataAnd(completion: (([Playlist], [Song]) -> Void)) {
        var playlists: [Playlist] = []
        var i = 0

        if Playlist.lastId() > 8 {
            let songs = Song.all()
            playlists = Playlist.all()
            completion(playlists, songs)
        } else {
            ItunesApi.api.fetchSongs { (songs) in
                var _songs: [Song] = []

                for s in songs {
                    if i < self.maxPlaylistSongs {
                        _songs.append(s)
                        i++
                    } else {
                        Playlist.createWithSong(["title": "saikou\(i)"],
                            songs: _songs
                            )
                        playlists.append(Playlist.createWithSongs(s.title, songs: _songs))
                        _songs = [s]
                        i = 1
                    }
                }
                completion(playlists, songs)
            }
        }
    }
}