import AVFoundation
import UIKit
import SDWebImage

class PlayerViewController: UIViewController, AVAudioPlayerDelegate {
    var button: UIButton!
    var player: PlayerManager!
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var playingTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!

    var playingTime : NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerAnd {
            self.play()
            self.setupViewObject()
        }
    }

    @IBAction func touchUpPlayBotton(sender: AnyObject) {
        play()
    }

    @IBAction func touchUpPauseButton(sender: AnyObject) {
        player.pause()
    }

    @IBAction func touchUpNextButton(sender: AnyObject) {
        player.playNextSong()
        setArtwork()
    }

    @IBAction func touchUpPrevButton(sender: AnyObject) {
        player.playPrevSong()
        self.artwork.sd_setImageWithURL(self.player.artworkUrl())
    }

    private func setupViewObject() {
        self.playTimeLabel.text = self.player.playTime()
        self.playingTimeLabel.text = "00:00"
        self.setPlayingTimeListener()
        self.titleLabel.text = self.player.title()
        self.artistLabel.text = self.player.artist()
        self.progressView.setProgress(0.0, animated: true)
    }

    private func setPlayingTimeListener() {
        self.playingTime = NSTimer.scheduledTimerWithTimeInterval(
            0.1,
            target: self,
            selector: "updatePlayingTime",
            userInfo: nil,
            repeats: true
        )
    }

    func updatePlayingTime() {
        if self.player.isPlaying() {
            playingTimeLabel.text = player.playingTime()
            self.progressView.progress = self.player.progress()
        }
    }

    private func setupPlayerAnd(completion: (Void -> Void)) {
        ItunesApi.api.fetchSongs { (songs) in
            self.player = PlayerManager(songs: songs)
            completion()
        }
    }

    private func play() {
        player.play()
        setArtwork()
    }

    private func setArtwork() {
        self.artwork.sd_setImageWithURL(self.player.artworkUrl())
    }
}
