import UIKit

class EditOrderSongTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    let defaultArtwork = UIImage(named: "defaultArtwork")

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setSong(song: Song){
        titleLabel.text = song.title
        artistLabel.text = song.artist
        if let url = NSURL(string: song.artworkUrl) {
            artworkImageView.sd_setImageWithURL(url)
        } else {
            artworkImageView.image = defaultArtwork
        }
        self.backgroundColor = UIColor.colorFromRGB(ConstantShare.tableCelBackColorString, alpha: 1)
    }
}