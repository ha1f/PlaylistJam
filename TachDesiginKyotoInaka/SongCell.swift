
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
        self.artistLabel.text = song.artist
        self.titleLabel.text = song.title
        //self.titleLabel.textColor = UIColor.whiteColor()
        
        self.titleLabel.backgroundColor = UIColor.colorFromRGB(ConstantShare.tableCelBackColorString, alpha: 1.0)

        if let url = NSURL(string: song.artworkUrl) {
            self.artwork.sd_setImageWithURL(url)
        }
    }
}
