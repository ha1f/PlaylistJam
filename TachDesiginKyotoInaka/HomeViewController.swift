import UIKit

class HomeViewController: UIViewController, ModalViewControllerDelegate {

    var pageData: NSArray = []
    var myPlaylistRepository: PlaylistRepository = PlaylistRepository()
    var controller: PreSelectDataController?
    var playingList = -1 {
        didSet {
            if oldValue != -1 {
                playlistCollectionView.reloadItemsAtIndexPaths([NSIndexPath(forRow: oldValue + 1, inSection: 0)])
            }
        }
    }
    @IBOutlet weak var blurNavbar: UIVisualEffectView!
    @IBOutlet weak var createButtonImage: UIImageView!

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var playlistCollectionView: UICollectionView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundBlur: UIVisualEffectView!
    
    var modalView: CreatePlaylistViewController! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playlistCollectionView.dataSource = self
        self.playlistCollectionView.delegate = self
        let backgroundImage: UIImage = UIImage(named: "backgroundImage2")!
        let ui = UIImageView()
        ui.image = backgroundImage
        ui.frame = self.view.frame
        self.view.addSubview(ui)

        initViewProp()
        createButton.addTarget(self, action: "createPlaylist", forControlEvents: UIControlEvents.TouchUpInside)
        
    }

    func createPlaylist() {
        self.performSegueWithIdentifier("createPlaylist", sender: nil)
    }

    override func viewWillAppear(animated: Bool) {
        if sharedFlag.isPlaylistCreated {
            performSegueWithIdentifier("Complete", sender: nil)
        }
        sharedFlag.isPlaylistCreated = false
        myPlaylistRepository.loadPlaylistsFormCache { playlists in
            self.playlistCollectionView.reloadData()
            //scrollToTop
            self.playlistCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Top, animated: true)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //公開/非公開選択画面
        if segue.identifier == "createPlaylist" {
            self.modalView = segue.destinationViewController as! CreatePlaylistViewController
            self.modalView.delegate = self
        //音楽再生画面
        } else if segue.identifier == "showMyplaylistDetail" {
            let detailViewController = segue.destinationViewController as! PlaylistDetailViewController
            detailViewController.playlist = myPlaylistRepository.getPlaylists()[(sender as! Int)]
        }
    }

    func modalDidFinished(nextSegue: String) {
        self.modalView.dismissViewControllerAnimated(false, completion: nil)
        self.performSegueWithIdentifier(nextSegue, sender: nil)
    }

    func initViewProp(){
        createButton.backgroundColor = UIColor.colorFromRGB(ConstantShare.featureColorString, alpha: 1.0)
        var colorList: [CGColor] = [
            UIColor.colorFromRGB("333333", alpha: 1).CGColor,
            UIColor.colorFromRGB("303030", alpha: 1).CGColor
        ]
        var locations: [CGFloat] = [0.0, 1.0]
    }

    func setGradient(view: UIView, colorList: [CGColor]?, locations: [CGFloat]){
        let gradientColors: [CGColor]? = colorList
        let gradientLayer: CAGradientLayer = CAGradientLayer()

        gradientLayer.colors = gradientColors
        gradientLayer.frame = view.bounds
        gradientLayer.locations = locations

        view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    func setNavOpacity(opacity: CGFloat) {
        blurNavbar.alpha = opacity
        backgroundBlur.alpha = opacity
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cellID: String
        var playlist: Playlist?

        if indexPath.row == 0 {
            cellID = "MyPlaylistCollectionHeaderCell"
            playlist = nil
        } else {
            cellID = "MyPlaylistCollectionViewCell"
            playlist = myPlaylistRepository.getPlaylists()[indexPath.row - 1]
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! UICollectionViewCell

        if let list = playlist {
            (cell as! MyPlaylistCollectionViewCell).parent = self
            (cell as! MyPlaylistCollectionViewCell).index = indexPath.row - 1
            (cell as! MyPlaylistCollectionViewCell).setup(playlist!)
        }

        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        var size: CGSize = CGSize.zeroSize
        if(indexPath.row == 0){
            size = CGSize(width: 360, height: 80)
        }else{
            size = CGSize(width: 360, height: 237)
        }
        return size
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("select: \(indexPath.row)")
        if indexPath.row > 0 {
            self.performSegueWithIdentifier("showMyplaylistDetail", sender: (indexPath.row-1))
        }
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        println("deselect: \(indexPath.row)")
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPlaylistRepository.getPlaylists().count + 1;
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        /*var opacity: CGFloat
        var scrollValue = scrollView.contentOffset.y
        opacity = (scrollValue - 60)/200
        if(opacity > 1){
            opacity = 1.0
        }else if(opacity < 0){
            opacity = 0
        }
        self.setNavOpacity(opacity)*/
        var scrollValue = scrollView.contentOffset.y
        var opacity: CGFloat
        opacity = (scrollValue - 60)/200
        self.setNavOpacity(opacity)
        
    }
    
}
