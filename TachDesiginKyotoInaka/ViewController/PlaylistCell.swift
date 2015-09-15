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
    
    func setup(playlist: Playlist, index:Int, topProtocol: TopProtocol) {
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
        
    }
    
    func selectPlaylist(){
        if(isSelect){
            self.topProtocol!.onTapForDel(self.index!)
            self.addButton.setTitle("＋", forState: nil)
            isSelect = false
        }else{
            self.topProtocol!.onTapForAdd(self.index!)
            self.addButton.setTitle("V", forState: nil)
            isSelect = true
        }
    }
    
    func goDetailPage(){
        println("adddddddddd")
        self.topProtocol!.onTapDetail(self.index!,playlist: playlist!)
    }

    private func setPlaylist(playlist: Playlist) {
        self.playlist = playlist
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
    func onTapForAdd(index: Int)
    func onTapForDel(index: Int)
    func onTapDetail(index: Int, playlist :Playlist)
}