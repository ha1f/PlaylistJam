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

    func playNextSong() {
        pause()
        selectNextSong()
        reset()
        play()
    }

    func playPrevSong() {
        pause()
        selectPrevSong()
        reset()
        play()
    }

    func reset() {
        player().reset()
    }

    func pause() {
        player().pause()
    }

    func play() {
        player().play()
    }

    func artworkUrl() -> NSURL {
        return player().artworkUrl()
    }

    private func selectNextSong() {
        if(i < (songCount - 1)) {
            i += 1
        } else {
            i = 0
        }
    }

    private func selectPrevSong()  {
        if (i > 0) {
            i -= 1
        } else {
            i = songCount - 1
        }
    }

    private func player() -> Player {
        println(i)
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
    let zeroSec : CMTime = CMTimeMake(0, 1)

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

    func reset() {
        player.seekToTime(zeroSec)
    }

    func artworkUrl() -> NSURL {
        return NSURL(string: song.artworkUrl)!
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

