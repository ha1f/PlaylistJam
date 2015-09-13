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

    func title() -> String {
        return player().title()
    }

    func artist() -> String {
        return player().artist()
    }

    func isPlaying() -> Bool {
        return player().isPlaying!
    }

    func artworkUrl() -> NSURL {
        return player().artworkUrl()
    }

    func playTime() -> String {
        return player().playTime()
    }

    func playingTime() -> String {
        return player().playingTime()
    }

    func progress() -> Float {
        return player().progress()
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
    let zeroSec: CMTime = CMTimeMake(0, 1)
    var playerItem: AVPlayerItem?
    var asset: AVURLAsset?
    var isPlaying: Bool?

    init(song: Song) {
        self.song = song
        createAVPlayer()
    }

    func play() {
        player.play()
        isPlaying = true
    }

    func pause() {
        player.pause()
        isPlaying = false
    }

    func reset() {
        player.seekToTime(zeroSec)
    }

    func artworkUrl() -> NSURL {
        return NSURL(string: song.artworkUrl)!
    }

    func title() -> String {
        return song.title
    }

    func artist() -> String {
        return song.artist
    }

    func playTime() -> String {
        let durationTime = CMTimeGetSeconds(self.asset!.duration)
        return self.formatTime(durationTime)
    }

    func playingTime() -> String {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        return self.formatTime(currentTime)
    }

    func progress() -> Float {
        let durationTime: Float = Float(CMTimeGetSeconds(self.asset!.duration))
        var currentTime: Float = Float(CMTimeGetSeconds(player.currentTime()))

        if currentTime == 0.0 {
            currentTime = 0.000001  // avoid infinite
        }

        return (currentTime / durationTime)
    }

    private func formatTime(mSecTime: Double) -> String {
        let h = Int(mSecTime / 3600)
        let m = Int(mSecTime - Double(h) * 3600) / 60
        let s = Int(mSecTime - 3600 * Double(h)) - m * 60

        return String(format: "%02d:%02d", m, s)
    }

    private func createAVPlayer() {
        let url = NSURL(string: song.previewUrl)!
        self.asset = AVURLAsset(URL: url, options: [:])
        self.playerItem = AVPlayerItem(asset: self.asset)

        if let p = AVPlayer(playerItem: playerItem) {
            println(url)
            self.player = p
            self.isPlaying = false
        } else {
            println("failed generating player")
        }
    }
}

