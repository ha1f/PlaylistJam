import AVFoundation

class PlayerManager: NSObject {
    var players: [Player?] = []
    var songs: [Song] = []
    private var i = 0;
    private var playlistId: Int = -1
    var playlistTitle: String = ""
    var songCount: Int = 0
    var playingTimes : NSTimer?
    var listener: AnyObject?
    static let instance = PlayerManager()

    private override init() {
      // super.init()
    }

    func setupSongs(songs: [Song]) {
        self.songs = songs
        self.songCount = songs.count
        self.players = [Player?](count: songCount, repeatedValue: nil)
        self.i = 0
        reset()
    }

    func setupPlaylist(playlist: Playlist) {
        self.playlistId = playlist.id
        self.playlistTitle = playlist.title
        setupSongs(playlist.songsArray())
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

    func playById(i: Int) {
        pause()
        self.i = i
        reset()
        play()
    }

    func title() -> String {
        return player().title()
    }

    func artist() -> String {
        return player().artist()
    }

    func isFinish() -> Bool {
        return progress() >= 1.0
    }

    func isPausing() -> Bool {
        return player().isPausing
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

    func seekTo(d: Float) {
        player().seekTo(d)
    }

    func listen(li: AnyObject) {
        self.listener = li
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

    func playerDidFinishPlaying(note: NSNotification) {
        playNextSong()
    }

    private func player() -> Player {
        if let player = self.players[i] {
            return player
        } else {
            let song = songs[i]
            self.players[i] = Player(song: song)
            println(listener)

            NSNotificationCenter.defaultCenter().addObserver(
                (listener ?? self),
                selector: "finishedPlaying:",
                name: AVPlayerItemDidPlayToEndTimeNotification,
                object: self.players[i]?.playerItem
            )
            return players[i]!
        }
    }

    func finishedPlaying(notification: NSNotification?) {
        self.playNextSong()
    }
}

class Player{
    var player: AVPlayer!
    var song: Song
    let zeroSec: CMTime = CMTimeMake(0, 1)
    var playerItem: AVPlayerItem?
    var asset: AVURLAsset?
    var isPausing: Bool = true

    init(song: Song) {
        self.song = song
        createAVPlayer()
    }

    func play() {
        player.play()
        isPausing = false
    }

    func pause() {
        player.pause()
        isPausing = true
    }

    func reset() {
        isPausing = true
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

    func seekTo(d: Float) {
        let time = Float(CMTimeGetSeconds(self.asset!.duration)) * d
        player.seekToTime(CMTimeMakeWithSeconds(Float64(time), 1))
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
            self.isPausing = false
        } else {
            println("failed generating player")
        }
    }
}

