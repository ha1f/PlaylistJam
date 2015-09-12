import AVFoundation
import UIKit
import SDWebImage

class PlayerViewController: UIViewController, AVAudioPlayerDelegate {
    var button: UIButton!
    var player: PlayerManager!
    @IBOutlet weak var artwork: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerAnd { self.play() }
    }

    @IBAction func touchUpPlayBotton(sender: AnyObject) {
        play()
    }

    @IBAction func touchUpPauseButton(sender: AnyObject) {
        player.pause()
    }

    @IBAction func touchUpNextButton(sender: AnyObject) {
        player.playNextSong()
        self.artwork.sd_setImageWithURL(self.player.artworkUrl())
    }

    @IBAction func touchUpPrevButton(sender: AnyObject) {
        player.playPrevSong()
        self.artwork.sd_setImageWithURL(self.player.artworkUrl())
    }

    private func setupPlayerAnd(completion: (Void -> Void)) {
        ItunesApi.api.fetchSongs { (songs) in
            self.player = PlayerManager(songs: songs)
            completion()
        }
    }

    private func play() {
        player.play()
        self.artwork.sd_setImageWithURL(self.player.artworkUrl())
    }
}
