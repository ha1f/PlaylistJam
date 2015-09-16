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
                completion(playlists: playlists)
            })
        }
        let playlists = Playlist.all()
        self.playlists = playlists
    }

    // 保存する
    func fetchSongsWithTermWith(term: String, completion: (playlists: [Playlist], songs: [Song]?) -> Void) {
        var playlists: [Playlist] = []
        var i = 0

        if self.playlists.count < 1 {
            ItunesApi.api.fetchSongsWithTerm(term, completion: { (songs) in
                self.playlists.extend(self.splitToPlaylist(songs))
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
        var playlists: [Playlist] = []
        var i = 0

        if self.playlists.count < 1 {
            ItunesApi.api.fetchSongsWithTerm(term, completion: { (songs) in
                self.playlists.extend(self.splitToPlaylistWithout(songs))
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
                i++
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
                i++
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
        return join("/", songs.map{ return $0.title })
    }

    func getPlaylists() -> [Playlist] {
        return self.playlists
    }

    func getSongs() -> [Song] {
        return self.playlists.flatMap{ $0.songsArray() }
    }
}
