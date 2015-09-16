import UIKit

class PlaylistDetailSongCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var artwork: UIImageView!

    func setSong(song: Song) {
        self.titleLabel.text = song.title
        self.artistLabel.text = song.artist
        
        self.backgroundColor = UIColor.clearColor()

        if let url = NSURL(string: song.artworkUrl) {
            self.artwork.sd_setImageWithURL(url)
        }
    }
}
