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
    var isSelect: Bool = false
    var index: Int?

    func setup(playlist: Playlist) {
        self.backgroundColor = UIColor.blackColor()
        setPlaylist(playlist)
    }

    func setup(playlist: Playlist, index:Int, isSelect: Bool, topProtocol: TopProtocol) {
        self.backgroundColor = UIColor.blackColor()
        setPlaylist(playlist)

        //コールバック登録
        self.topProtocol = topProtocol
        //各種イベント登録
        let gesture = UITapGestureRecognizer(target:self, action: "selectPlaylist")
        self.addGestureRecognizer(gesture);
        addButton.addTarget(self, action: "selectPlaylist", forControlEvents: UIControlEvents.TouchUpInside)
        detailButton.addTarget(self, action: "goDetailPage", forControlEvents: UIControlEvents.TouchUpInside)
        self.index = index

        if(isSelect){
            select()
        }else{
            deSelect()
        }

    }

    func select(){
            self.topProtocol!.onTapForAdd(self.index!)
            self.addButton.setTitle("V", forState: nil)
            isSelect = true
    }

    func deSelect(){
            self.topProtocol!.onTapForDel(self.index!)
            self.addButton.setTitle("＋", forState: nil)
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
        let largeSong = playlist.songs.first!
        let songs = playlist.songs

        if let url = NSURL(string: largeSong.artworkUrl) {
            self.artwork.sd_setImageWithURL(url)
        }

        if songs.count > 1 {
            if let url = NSURL(string: songs[1].artworkUrl) {
                self.samllArtwork1.sd_setImageWithURL(url)
            }
        }

        if songs.count > 2 {
            if let url = NSURL(string: songs[2].artworkUrl) {
                self.samllArtwork2.sd_setImageWithURL(url)
            }
        }

        self.titleLabel.text = playlist.title
    }
}

protocol TopProtocol{
    func onTapForAdd(index: Int)
    func onTapForDel(index: Int)
    func onTapDetail(index: Int, playlist :Playlist)
}