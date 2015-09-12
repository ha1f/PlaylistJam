import AVFoundation
import UIKit
import SDWebImage

class PlayerViewController: UIViewController, AVAudioPlayerDelegate {
    var button: UIButton!
    var player: PlayerManager!
    @IBOutlet weak var artwork: UIImageView!

    @IBAction func touchUpPlayBotton(sender: AnyObject) {
        play()
    }

    @IBAction func touchUpPauseButton(sender: AnyObject) {
        self.player.pause()
    }

    @IBAction func touchUpNextButton(sender: AnyObject) {
        playNextTune()
    }

    @IBAction func touchUpPrevButton(sender: AnyObject) {
        playPrevTune()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayers()
    }

    private func setupPlayers() {
        ItunesApi.api.fetchSongs { (songs) in
            self.player = PlayerManager(songs: songs)
            self.play()
        }
    }

    private func playNextTune() {
        self.player.pause()
        self.player.reset()
        self.player.nextTune()
        self.artwork.sd_setImageWithURL(self.player.artworkUrl())
    }

    private func playPrevTune() {
        self.player.pause()
        self.player.reset()
        self.player.prevTune()
        self.artwork.sd_setImageWithURL(self.player.artworkUrl())
    }

    private func play() {
        self.player.play()
        self.artwork.sd_setImageWithURL(self.player.artworkUrl())
    }
}