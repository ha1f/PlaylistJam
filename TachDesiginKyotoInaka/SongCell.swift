
import UIKit

class SongCell:UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!

    func setup(song: Song) {
        self.backgroundColor = UIColor.blackColor()
        setupSong(song)
    }

    private func setupSong(song: Song) {
        self.artwork.sd_setImageWithURL(NSURL(string: song.artworkUrl)!)
        self.artistLabel.text = song.artist
        self.artistLabel.textColor = UIColor.whiteColor()
        self.titleLabel.text = song.title
        self.titleLabel.textColor = UIColor.whiteColor()
    }
}
