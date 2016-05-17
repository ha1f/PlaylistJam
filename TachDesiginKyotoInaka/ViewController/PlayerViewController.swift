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
    @IBOutlet weak var close: UIImageView!

    var playingTime : NSTimer?
    let pauseImage = UIImage(named: "PauseButton")
    let playImage = UIImage(named: "playButton")
    let closeButton = UIImage(named: "allowUnder")
    var playlist: Playlist?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.playingTimeSlider.value = 0.0
        self.playingTimeSlider.setThumbImage(UIImage(named: "sliderThum"),forState: .Normal)
//        self.view.backgroundColor = UIColor.colorFromRGB("000000", alpha: 1.0)
        self.view.backgroundColor = UIColor.blackColor()

        self.player.listen(self)
        self.setupViewObject()
    }

    @IBAction func changePlayingTime(sender: AnyObject) {
        playingTimeLabel.text = player.playingTime()
        player.seekTo(self.playingTimeSlider.value)
    }

    @IBAction func touchUpPlayBotton(sender: AnyObject) {
        if player.isPausing() {
            play()
        } else {
            pause()
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

    @IBAction func closeModal(sender: AnyObject) {
        self.player.stopListen()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    private func setPlayingTimeListener() {
        self.playingTime = NSTimer.scheduledTimerWithTimeInterval(
            0.1,
            target: self,
            selector: #selector(PlayerViewController.updatePlayingState),
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
        if !self.player.isPausing() {
            playingTimeLabel.text = player.playingTime()
            self.playingTimeSlider.value = self.player.progress()
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
        self.artwork.backgroundColor = UIColor.whiteColor()
        self.titleLabel.text = self.player.title()
        self.artistLabel.text = self.player.artist()

        if player.isPausing() {
            playButton.setImage(playImage, forState: .Normal)
        } else {
            playButton.setImage(pauseImage, forState: .Normal)
        }
    }

    private func setupViewObject() {
        close.image = closeButton
        self.playTimeLabel.text = self.player.playTime()
        self.setPlayingTimeListener()
        self.artwork.sd_setImageWithURL(self.player.artworkUrl())
        self.titleLabel.text = self.player.title()
        self.artistLabel.text = self.player.artist()
        playButton.setImage(pauseImage, forState: .Normal)
    }
}
