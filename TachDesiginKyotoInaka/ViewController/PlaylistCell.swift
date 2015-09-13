import UIKit
import SDWebImage

class PlaylistCell:UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var samllArtwork1: UIImageView!
    @IBOutlet weak var samllArtwork2: UIImageView!

    func setup(playlist: Playlist) {
        self.backgroundColor = UIColor.blackColor()
        setPlaylist(playlist)
    }

    private func setPlaylist(playlist: Playlist) {
    let largeSong = playlist.songs.first!
    let song1 = playlist.songs[1]
    let song2 = playlist.songs[2]

    self.artwork.sd_setImageWithURL(NSURL(string: largeSong.artworkUrl)!)
    self.samllArtwork1.sd_setImageWithURL(NSURL(string: song1.artworkUrl)!)
    self.samllArtwork2.sd_setImageWithURL(NSURL(string: song2.artworkUrl)!)

    self.titleLabel.text = playlist.title
    }
}
