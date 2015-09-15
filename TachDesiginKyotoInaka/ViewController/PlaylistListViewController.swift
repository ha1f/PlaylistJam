import UIKit

class PlaylistListViewController: PageCellViewController {
    var playlistList: [Playlist] = []
    
    @IBOutlet var playlistCollectionView: UICollectionView!
    
    //dataobjectのセット、要override
    override func setDataObject(dataObject: AnyObject?){
        if let tmpDataObject: [Playlist] = dataObject as? [Playlist] {
            self.playlistList = tmpDataObject
        } else {
            println("DataObject is nil")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        
        //tableViewの作成、delegate,dataSourceを設定
        self.playlistCollectionView.delegate = self
        self.playlistCollectionView.dataSource = self
        self.playlistCollectionView.backgroundColor = UIColor.clearColor()
        self.playlistCollectionView.allowsMultipleSelection = true
        
        self.view.addSubview(self.playlistCollectionView)
    }

    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController: PlaylistDetailViewController = segue.destinationViewController as! PlaylistDetailViewController
        let i: Int = sender as! Int
        viewController.playlist = playlistList[i]
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension PlaylistListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PlaylistCell", forIndexPath: indexPath) as! PlaylistCell
        cell.setup(self.playlistList[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDetail", sender: indexPath.row)
        appendSelectedItem(indexPath.row)
        println("select: \(indexPath.row)")
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        println("deselect: \(indexPath.row)")
        removeSelectedItem(indexPath.row)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlistList.count;
    }
}
