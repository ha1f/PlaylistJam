import AVFoundation

class PlayerManager {
    var players: [Player?]
    let songs: [Song]
    var i = 0;
    let songCount: Int


    init(songs: [Song]) {
        self.songs = songs
        self.songCount = songs.count
        self.players = [Player?](count: songCount, repeatedValue: nil)
    }

    func nextTune() {
        if(i < songCount) {
            i += 1
        } else {
            i = 0
        }
        play()
    }

    func prevTune()  {
        if (i > 0) {
            i -= 1
        } else {
            i = songCount
        }
        play()
    }

    func pause() {
        player().pause()
    }

    func play() {
        player().play()
    }

    private func player() -> Player {
        if let player = self.players[i] {
            return player
        } else {
            let song = songs[i]
            self.players[i] = Player(song: song)
            return players[i]!
        }
    }
}

class Player {
    var player: AVPlayer!
    var song: Song

    init(song: Song) {
        self.song = song
        createAVPlayer()
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    private func createAVPlayer() {
        let url = NSURL(string: song.previewUrl)!
        println(url)

        if let p = AVPlayer(URL: url) {
            self.player = p
        } else {
            println("failed generating player")
        }
    }
}
