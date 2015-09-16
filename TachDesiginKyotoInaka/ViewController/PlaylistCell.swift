import UIKit
import SDWebImage

class PlaylistCell:UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var samllArtwork1: UIImageView!
    @IBOutlet weak var samllArtwork2: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!

    var topProtocol: TopProtocol?
    var playlist: Playlist?
    var isSelect: Bool = false
    var index: Int?

    let checkedButtonImage = UIImage(named: "songPlusButton")
    let unCheckedButtonImage = UIImage(named: "checkedSongButton")
    let defaultArtwork = UIImage(named: "defaultArtwork")

    func setup(playlist: Playlist) {
        self.backgroundColor = UIColor.colorFromRGB(ConstantShare.tableCelBackColorString, alpha: 1.0)
        setPlaylist(playlist)
    }

    func setup(playlist: Playlist, index:Int, isSelect: Bool, topProtocol: TopProtocol) {
        self.backgroundColor = UIColor.colorFromRGB(ConstantShare.tableCelBackColorString, alpha: 1.0)
        setPlaylist(playlist)

        //コールバック登録
        self.topProtocol = topProtocol
        //各種イベント登録
        let gesture = UITapGestureRecognizer(target:self, action: "goDetailPage")
        self.addGestureRecognizer(gesture);
        addButton.addTarget(self, action: "selectPlaylist", forControlEvents: UIControlEvents.TouchUpInside)
//        detailButton.addTarget(self, action: "goDetailPage", forControlEvents: UIControlEvents.TouchUpInside)
        self.index = index

        if(isSelect){
            select()
        }else{
            deSelect()
        }
    }

    func select(){
        self.topProtocol!.onTapForAdd(self.index!)
        self.addButton.setBackgroundImage(self.unCheckedButtonImage, forState: .Normal)
        self.titleLabel.textColor = UIColor.lightGrayColor()
        self.descLabel.textColor = UIColor.lightGrayColor()
        isSelect = true
    }

    func deSelect(){
        self.topProtocol!.onTapForDel(self.index!)
        self.addButton.setBackgroundImage(self.checkedButtonImage, forState: .Normal)
        self.titleLabel.textColor = UIColor.whiteColor()
        self.descLabel.textColor = UIColor.whiteColor()
        isSelect = false
    }

    func selectPlaylist(){
        if(isSelect){
            deSelect()
        }else{
            select()
        }
    }

    func goDetailPage(){
        self.topProtocol!.onTapDetail(self.index!,playlist: playlist!)
    }

    private func setPlaylist(playlist: Playlist) {
        self.playlist = playlist
        let songs = playlist.songs
        self.descLabel.text = playlist.desc

        if songs.count > 0 {
            if let url = NSURL(string: songs[0].artworkUrl) {
                self.artwork.sd_setImageWithURL(url)
            }
        }

        if songs.count > 1 {
            if let url = NSURL(string: songs[1].artworkUrl) {
                self.samllArtwork1.sd_setImageWithURL(url)
            } else {
                self.samllArtwork1.image = defaultArtwork
            }
        } else {
                self.samllArtwork1.image = defaultArtwork
        }

        if songs.count > 2 {
            if let url = NSURL(string: songs[2].artworkUrl) {
                self.samllArtwork2.sd_setImageWithURL(url)
            } else {
                self.samllArtwork2.image = defaultArtwork
            }
        } else {
                self.samllArtwork2.image = defaultArtwork
        }

        self.titleLabel.text = playlist.title
    }
}

protocol TopProtocol{
    func onTapForAdd(index: Int)
    func onTapForDel(index: Int)
    func onTapDetail(index: Int, playlist :Playlist)
}