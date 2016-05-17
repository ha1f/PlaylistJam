class PlaylistRepository {
    private var playlists: [Playlist] = []
    let maxPlaylistSongs: Int = 8
    let minPlaylist: Int = 5

    func fetchSongs(completion: (playlists: [Playlist], songs: [Song]?) -> Void) {
        fetchSongsWithTerm("sekai", completion: completion)
    }

    func loadPlaylistsFormCache(completion: (playlists: [Playlist]) -> Void){
        if Playlist.lastId() < minPlaylist {
            fetchSongsWithTermWith("perfume", completion: { (playlists, _) in
                self.playlists = Playlist.all()
                completion(playlists: playlists)
            })
        } else {
            let playlists = Playlist.all()
            self.playlists = playlists
            completion(playlists: playlists)
        }
    }

    // 保存する
    func fetchSongsWithTermWith(term: String, completion: (playlists: [Playlist], songs: [Song]?) -> Void) {
        let playlists: [Playlist] = []
        _ = 0

        if self.playlists.count < 1 {
            ItunesApi.api.fetchSongsWithTerm(term, completion: { (songs) in
                self.playlists.appendContentsOf(self.splitToPlaylist(songs))
                completion(playlists: playlists, songs: songs)
            })
        }
    }

    func loadSongs(completion: (playlists: [Song]) -> Void){
        let songLists = Song.all()
        completion(playlists: songLists)
    }

    //しない
    func fetchSongsWithTerm(term: String, completion: (playlists: [Playlist], songs: [Song]?) -> Void) {
        let playlists: [Playlist] = []
        _ = 0

        if self.playlists.count < 1 {
            ItunesApi.api.fetchSongsWithTerm(term, completion: { (songs) in
                self.playlists.appendContentsOf(self.splitToPlaylistWithout(songs))
                completion(playlists: playlists, songs: songs)
            })
        }
    }

   // 保存しない
    private func splitToPlaylistWithout(songs: [Song]) -> [Playlist] {
        var playlists: [Playlist] = []
        var i = 0
        var _songs: [Song] = []
        for s in songs {
            if i < self.maxPlaylistSongs {
                _songs.append(s)
                i += 1
            } else {
                playlists.append(Playlist.createWithSongs(_songs.last!.title, desc: createdesc(_songs), songs: _songs))
                _songs = [s]
                i = 1
            }
        }
        return playlists
    }

    private func splitToPlaylist(songs: [Song]) -> [Playlist] {
        var playlists: [Playlist] = []
        var i = 0
        var _songs: [Song] = []
        for s in songs {
            if i < self.maxPlaylistSongs {
                _songs.append(s)
                i += 1
            } else {
                let a = Playlist.createWithSong(
                    [
                        "title": _songs.last!.title,
                        "desc": createdesc(_songs)
                    ],
                    songs: _songs
                )
                playlists.append(a)
                _songs = [s]
                i = 1
            }
        }
        return playlists
    }

    private func createdesc(songs: [Song]) -> String {
        return songs.map{ return $0.title }.joinWithSeparator("/")
    }

    func getPlaylists() -> [Playlist] {
        return self.playlists
    }

    func getSongs() -> [Song] {
        return self.playlists.flatMap{ $0.songsArray() }
    }
}
