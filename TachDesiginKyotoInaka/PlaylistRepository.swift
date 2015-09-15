//
//  MyPlaylistRepository.swift
//  TachDesiginKyotoInaka
//
//  Created by 山口 智生 on 2015/09/16.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//


class PlaylistRepository {
    private var playlists: [Playlist] = []
    let maxPlaylistSongs: Int = 8
    
    func fetchSongs(completion: (playlists: [Playlist], songs: [Song]?) -> Void) {
        fetchSongsWithTerm("sekai", completion: completion)
    }
    
    //Realmから
    func loadPlaylists(completion: (playlists: [Playlist]) -> Void){
        let playlists = Playlist.all()
        self.playlists.extend(playlists)
        completion(playlists: playlists)
    }
    
    func loadSongs(completion: (playlists: [Song]) -> Void){
        let songLists = Song.all()
        //self.playlists.extend(playlists)
        completion(playlists: songLists)
    }
    
    func fetchSongsWithTerm(term: String, completion: (playlists: [Playlist], songs: [Song]?) -> Void) {
        var playlists: [Playlist] = []
        var i = 0
        
        ItunesApi.api.fetchSongsWithTerm(term, completion: { (songs) in
            self.playlists.extend(self.splitToPlaylist(songs))
            completion(playlists: playlists, songs: songs)
        })
    }
    
    private func splitToPlaylist(songs: [Song]) -> [Playlist] {
        var playlists: [Playlist] = []
        var i = 0
        var id = 0
        var _songs: [Song] = []
        for s in songs {
            if i < self.maxPlaylistSongs {
                _songs.append(s)
                i++
            } else {
                Playlist.createWithSong(["title": "samplePlaylist:\(id)"],
                    songs: _songs
                )
                playlists.append(Playlist.createWithSongs(s.title, songs: _songs))
                id++
                _songs = [s]
                i = 1
            }
        }
        return playlists
    }
    
    func getPlaylists() -> [Playlist] {
        return self.playlists
    }
    
    //中身の曲全て
    func getSongs() -> [Song] {
        return self.playlists.flatMap{ $0.songsArray() }
    }
}
