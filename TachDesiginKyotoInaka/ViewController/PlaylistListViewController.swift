import UIKit

class PlaylistListViewController: PageCellViewController {
    var playlistList: [Playlist] = []
    var tapProtocol: TopProtocol?
    
    @IBOutlet var playlistCollectionView: UICollectionView!
    
    //dataobjectのセット、要override
    override func setDataObject(dataObject: AnyObject?){
        if let tmpDataObject: [Playlist] = dataObject as? [Playlist] {
            self.playlistList = tmpDataObject
        } else {
            print("DataObject is nil")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()

        self.playlistCollectionView.delegate = self
        self.playlistCollectionView.dataSource = self
        self.playlistCollectionView.backgroundColor = UIColor.clearColor()
        self.playlistCollectionView.allowsMultipleSelection = true
        
        self.view.addSubview(self.playlistCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        if self.title == "MyPlaylist" {
            self.playlistCollectionView.frame = CGRectMake(7, 174 - PreSelectViewController.subTabHeight, (self.view.frame.width-15), (self.view.frame.height - 174 + PreSelectViewController.subTabHeight))
        } else {
            self.playlistCollectionView.frame = CGRectMake(7, 174, (self.view.frame.width-15), (self.view.frame.height - 174))
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
        //現在選択中のものを取得
        let selectedIndexs: [Int] = getSelectedItem()
        cell.setup(self.playlistList[indexPath.row], index: indexPath.row, isSelect: selectedIndexs.contains(indexPath.row),topProtocol: self)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //getSelectedItem()で現在選択されているもの一覧を取得できる[Int]
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        print("deselect: \(indexPath.row)")
        removeSelectedItem(indexPath.row)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlistList.count;
    }
}

extension PlaylistListViewController: TopProtocol{
    func onTapForAdd(index: Int) {
        appendSelectedItem(index)
    }
    
    func onTapForDel(index: Int) {
        removeSelectedItem(index)
    }
    
    func onTapDetail(index: Int, playlist: Playlist) {
        self.performSegueWithIdentifier("showDetail", sender: index)
    }
}
