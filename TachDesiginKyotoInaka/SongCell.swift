
import UIKit

class SongCell:UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var checkButton: UIImageView!

    let checkedButtonImage = UIImage(named: "songPlusButton")
    let unCheckedButtonImage = UIImage(named: "checkedSongButton")

    func setup(song: Song) {
        self.backgroundColor = UIColor.blackColor()
        setupSong(song)
    }

    private func setupSong(song: Song) {
        self.artistLabel.text = song.artist
        self.titleLabel.text = song.title
        self.checkButton.image = checkedButtonImage
        
        if let url = NSURL(string: song.artworkUrl) {
            self.artwork.sd_setImageWithURL(url)
        }
    }

    func check() {
        self.titleLabel.textColor = UIColor.lightGrayColor()
        self.artistLabel.textColor = UIColor.darkGrayColor()
        self.checkButton.image = unCheckedButtonImage
    }

    func unCheck() {
        self.titleLabel.textColor = UIColor.whiteColor()
        self.artistLabel.textColor = UIColor.lightGrayColor()
        self.checkButton.image = checkedButtonImage
    }
}
