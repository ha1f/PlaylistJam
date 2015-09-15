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
        

        self.playlistCollectionView.delegate = self
        self.playlistCollectionView.dataSource = self
        self.playlistCollectionView.backgroundColor = UIColor.clearColor()
        self.playlistCollectionView.allowsMultipleSelection = true
    }
    
    override func viewDidLayoutSubviews() {
        if self.title == "MyPlaylist" {
            self.playlistCollectionView.frame = CGRectMake(7, 164 - 51, (self.view.frame.width-15), (self.view.frame.height - 164 - 20))
        } else {
            self.playlistCollectionView.frame = CGRectMake(7, 164, (self.view.frame.width-15), (self.view.frame.height - 164 - 20))
        }
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
        //getSelectedItem()で現在選択されているもの一覧を取得できる[Int]
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
