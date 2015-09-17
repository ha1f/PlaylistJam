import UIKit

class PlaylistDetailViewController: BlurModalViewController {
    @IBOutlet var songTableView: UITableView!
    @IBOutlet weak var mainArtwork: UIImageView!
    @IBOutlet weak var subArtwork1: UIImageView!
    @IBOutlet weak var subArtwork2: UIImageView!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playlistName: UILabel!

    var songList: [Song] = []
    var playlist: Playlist?
    let player: PlayerManager = PlayerManager.instance
    var lastPlayedId = -1

    let pauseButtonImage = UIImage(named: "PauseButton")
    let playButtonImage = UIImage(named: "playlistPLayButton")
    let defaultArtwork = UIImage(named: "defaultArtwork")


    override func viewDidLoad() {
        super.viewDidLoad()

        songList = playlist!.songsArray()

        //tableViewの作成、delegate,dataSourceを設定
        self.songTableView.delegate = self
        self.songTableView.dataSource = self

        self.songTableView.backgroundColor = UIColor.clearColor()
        self.songTableView.separatorColor = UIColor.darkGrayColor()

        self.view.backgroundColor = UIColor.clearColor()

        self.songTableView.tableFooterView = UIView()
        setupArtwork()
        self.playlistName.text = playlist?.title ?? ""
        self.player.setupSongs(playlist!.songsArray())
        self.playerImage.image = playButtonImage
    }

    func setupArtwork() {
        let songs = playlist!.songs

        if songs.count > 0 {
            if let url = NSURL(string: songs[0].artworkUrl) {
                self.mainArtwork.sd_setImageWithURL(url)
            }  else {
                self.mainArtwork.image = defaultArtwork
            }
        } else {
                self.mainArtwork.image = defaultArtwork
        }

        if songs.count > 1 {
            if let url = NSURL(string: songs[1].artworkUrl) {
                self.subArtwork1.sd_setImageWithURL(url)
            }  else {
                self.subArtwork1.image = defaultArtwork
            }
        } else {
                self.subArtwork1.image = defaultArtwork
        }

        if songs.count > 2 {
            if let url = NSURL(string: songs[2].artworkUrl) {
                self.subArtwork2.sd_setImageWithURL(url)
            }  else {
                self.subArtwork2.image = defaultArtwork
            }
        } else {
                self.subArtwork2.image = defaultArtwork
        }
    }

    override func viewDidAppear(animated: Bool) {
        if player.isPausing() {
            self.playerImage.image = playButtonImage
        } else {
            self.playerImage.image = pauseButtonImage
        }
    }

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

//    }

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if player.isPausing() {
            return true
        } else {
            return false
        }
    }

    @IBAction func close(sender: AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        player.pause()
    }

    @IBAction func playOrPauseButton(sender: AnyObject) {
        if player.isPausing() {
            play()
        } else {
            pause()
        }
    }
}

extension PlaylistDetailViewController: UITableViewDataSource, UITableViewDelegate{
    //選択された時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        playerImage.image = pauseButtonImage

        if player.isPausing() {
            player.playById(indexPath.row)
        } else {
            if lastPlayedId == indexPath.row {
                self.performSegueWithIdentifier("playerViewPage", sender: nil)
            } else {
                player.playById(indexPath.row)
            }
        }
        lastPlayedId = indexPath.row
        println("selected: \(indexPath.row)")
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
        let height :CGFloat! = ConstantShare.songCellHeight

        if let h = height{
            return h
        } else {
            return tableView.estimatedRowHeight
        }
    }
}

// for play Playlist
extension PlaylistDetailViewController {
    func play() {
        player.play()
        playerImage.image = pauseButtonImage
    }

    func pause() {
        player.pause()
        self.playerImage.image = playButtonImage
    }
}