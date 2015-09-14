import UIKit

class PlaylistDetailViewController: UIViewController {
    
    @IBOutlet var songTableView: UITableView!
    @IBOutlet weak var mainArtwork: UIImageView!
    @IBOutlet weak var subArtwork1: UIImageView!
    @IBOutlet weak var subArtwork2: UIImageView!

    var songList: [Song] = []
    var playlist: Playlist?
    var player: PlayerManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blueColor()

        songList = playlist!.songs
        
        //tableViewの作成、delegate,dataSourceを設定
        self.songTableView.delegate = self
        self.songTableView.dataSource = self
        
        self.songTableView.backgroundColor = UIColor.blackColor()
        self.songTableView.separatorColor = UIColor.blackColor()
        
        self.songTableView.tableFooterView = UIView()
        setupArtwork()
        self.player = PlayerManager(songs: playlist!.songs)
    }

    func setupArtwork() {
        let largeSong = playlist!.songs.first!
        let song1 = playlist!.songs[1]
        let song2 = playlist!.songs[2]

        self.mainArtwork.sd_setImageWithURL(NSURL(string: largeSong.artworkUrl)!)
        self.subArtwork1.sd_setImageWithURL(NSURL(string: song1.artworkUrl)!)
        self.subArtwork2.sd_setImageWithURL(NSURL(string: song2.artworkUrl)!)
    }
    
    @IBAction func close(sender: AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension PlaylistDetailViewController: UITableViewDataSource, UITableViewDelegate{
    //選択された時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        player.playById(indexPath.row)
        println("selected: \(indexPath.row)")
        //self.performSegueWithIdentifier("tosend",sender: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songList.count
    }
    
    //セルを作成
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaylistDetailSongCell") as! PlaylistDetailSongCell
        cell.setSong(self.songList[indexPath.row])
        return cell
    }
    
    //高さを計算したいけどとりあえず放置
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height :CGFloat! = 80.0
        
        if let h = height{
            return h
        } else {
            return tableView.estimatedRowHeight
        }
    }
}