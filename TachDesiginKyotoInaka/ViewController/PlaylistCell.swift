import UIKit
import SDWebImage

class PlaylistCell:UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var samllArtwork1: UIImageView!
    @IBOutlet weak var samllArtwork2: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    
    var topProtocol: TopProtocol?
    var playlist: Playlist?

    func setup(playlist: Playlist) {
        self.backgroundColor = UIColor.blackColor()
        setPlaylist(playlist)
        
    }
    
    func setup(playlist: Playlist, topProtocol: TopProtocol) {
        self.backgroundColor = UIColor.blackColor()
        setPlaylist(playlist)
        
        //コールバック登録
        self.topProtocol = topProtocol
        //各種イベント登録
        let gesture = UITapGestureRecognizer(target:self, action: "addPlaylist:")
        self.addGestureRecognizer(gesture);
        detailButton.addTarget(self, action: "goDetailPage:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func addPlaylist(){
        self.topProtocol!.onTapAddArea(playlist!)
    }
    
    private func goDetailPage(){
        self.topProtocol!.onTapDetail(playlist!)
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

protocol TopProtocol{
    func onTapAddArea(playlist :Playlist)
    func onTapDetail(playlist :Playlist)
}