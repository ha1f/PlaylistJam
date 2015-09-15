import UIKit

class MyPlaylistCollectionViewCell: UICollectionViewCell {
    var playlist: Playlist!
    let player = PlayerManager.manager
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var mainArtworkImageView: UIImageView!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var sub1ArtworkImageView: UIImageView!
    @IBOutlet weak var sub2ArtworkImageView: UIImageView!

    @IBOutlet weak var playlistTitleLabel: UILabel!
    @IBOutlet weak var playlistCommentLabel: UILabel!

    @IBAction func touchUpPlayButton(sender: AnyObject) {
        player.setupPlaylist(playlist)
        player.play()
    }

    func setup(playlist: Playlist) {
        initViewProp()
        self.playlist = playlist
        
        if let url = NSURL(string: playlist.songs[0].artworkUrl) {
            self.mainArtworkImageView.sd_setImageWithURL(url)
        }
        if let url = NSURL(string: playlist.songs[1].artworkUrl) {
            self.sub1ArtworkImageView.sd_setImageWithURL(url)
        }
        if let url = NSURL(string: playlist.songs[2].artworkUrl) {
            self.sub2ArtworkImageView.sd_setImageWithURL(url)
        }

        let image = UIImage(named: "playlistPlayButton")
        self.playButton.setBackgroundImage(image, forState: .Normal)
        self.playButton.setTitle("", forState: .Normal)

        self.playlistTitleLabel.text = playlist.title
        self.playlistCommentLabel.text = playlist.desc
    }

    func initViewProp(){
        let colorList: [CGColor] = [
            UIColor.colorFromRGB("000000", alpha: 0).CGColor,
            UIColor.blackColor().CGColor
        ]

        let locations: [CGFloat] = [0.0, 0.8]
        setGradient(self.infoView, colorList: colorList, locations: locations)
    }
    
    func setGradient(view: UIView, colorList: [CGColor]?, locations: [CGFloat]){
        let gradientColors: [CGColor]? = colorList
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = view.bounds
        gradientLayer.locations = locations
        view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
}
