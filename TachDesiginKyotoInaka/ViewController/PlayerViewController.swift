import AVFoundation
import UIKit
import SDWebImage

class PlayerViewController: UIViewController, AVAudioPlayerDelegate {
    var button: UIButton!
    let player: PlayerManager = PlayerManager.instance
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var playingTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!

    @IBOutlet weak var playingTimeSlider: UISlider!

    var playingTime : NSTimer?
    let pauseImage = UIImage(named: "stopButton")
    let playImage = UIImage(named: "playButton")


    override func viewDidLoad() {
        super.viewDidLoad()

        self.playingTimeSlider.value = 0.0
        self.playingTimeSlider.setThumbImage(UIImage(named: "sliderThum"),forState: .Normal)

        setupPlayer {
            self.player.listen(self)
            self.setupViewObject()
            self.play()
        }
    }

    @IBAction func changePlayingTime(sender: AnyObject) {
        player.seekTo(self.playingTimeSlider.value)
    }

    @IBAction func touchUpPlayBotton(sender: AnyObject) {
        if player.isPausing() {
            pause()
        } else {
            play()
        }
    }

    @IBAction func touchUpNextButton(sender: AnyObject) {
        player.playNextSong()
        setSongInfo()
    }

    @IBAction func touchUpPrevButton(sender: AnyObject) {
        player.playPrevSong()
        setSongInfo()
    }

    private func setPlayingTimeListener() {
        self.playingTime = NSTimer.scheduledTimerWithTimeInterval(
            0.1,
            target: self,
            selector: "updatePlayingState",
            userInfo: nil,
            repeats: true
        )
    }

    // for Notification
    func finishedPlaying(notification: NSNotification?) {
        player.playNextSong()
        setSongInfo()
    }

    func updatePlayingState() {
        if self.player.isPausing() {
            playingTimeLabel.text = player.playingTime()
            self.playingTimeSlider.value = self.player.progress()
        }
    }

    private func setupPlayer(completion: (Void -> Void)) {
        ItunesApi.api.fetchSongs { (songs) in
            self.player.setupSongs(songs)
            completion()
        }
    }

    private func play() {
        player.play()
        playButton.setImage(pauseImage, forState: .Normal)
    }

    private func pause() {
        player.pause()
        playButton.setImage(playImage, forState: .Normal)
    }

    private func setSongInfo() {
        self.artwork.sd_setImageWithURL(self.player.artworkUrl())
        self.titleLabel.text = self.player.title()
        self.artistLabel.text = self.player.artist()
        playButton.setImage(pauseImage, forState: .Normal)
    }

    private func setupViewObject() {
        self.playTimeLabel.text = self.player.playTime()
        self.setPlayingTimeListener()
        self.setSongInfo()
    }
}
