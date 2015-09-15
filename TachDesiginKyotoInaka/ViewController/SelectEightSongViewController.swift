import UIKit
import DraggableCollectionView

class SelectEightSongViewController: UIViewController {
    let manager = SelectedSongsManager.manager
    var songList:[Song] = []
    var selectedSongs: [SelectedSong] = [] {
        didSet{
            self.selectedCount.text = "\(selectedSongs.count)/8 曲"
        }
    }
    var checkFlags: [Bool] = []
    
    @IBOutlet weak var selectSongTableView: UITableView!
    @IBOutlet weak var selectedCount: UILabel!
    @IBOutlet weak var selectedCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.songList = manager.selectedSongs()

        self.selectSongTableView.delegate = self
        self.selectSongTableView.dataSource = self
        self.selectedCount.text = "\(selectedSongs.count)/8 曲"
        
        selectSongTableView.allowsSelection = false
        selectSongTableView.backgroundColor = UIColor.clearColor()
        
        //同じ回数分
        for i in songList {
            self.checkFlags.append(false)
        }
        
        selectedCollection.delegate = self
        selectedCollection.dataSource = self
        selectedCollection.draggable = true
        
        selectSongTableView.reloadData()
    }
    
    override func loadView() {
        super.loadView()
        // カスタムセルを登録
        self.selectSongTableView.registerNib(UINib(nibName:"SelectSongTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectSongTableViewCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkButtonClicked(sender: CheckBox!) {
        sender.isChecked = !sender.isChecked
        checkFlags[sender.tag] = sender.isChecked

        if sender.isChecked {
            if selectedSongs.count < 8 {
                self.manager.selectSongInfoById(sender.tag)
                selectedSongs.append(self.manager.selectedSongInfos[sender.tag])
                //self.selectedCollection.scrollToItemAtIndexPath(NSIndexPath(forRow: selectedSongs.count-1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
            } else {
                sender.isChecked = false
            }
        } else {
            println("delete")
            self.manager.removeSongInfoById(sender.tag)
            selectedSongs = manager.selectedSongInfo()
        }
        self.selectedCollection.reloadData()
        println(self.manager.selectedIds)
    }
}

extension SelectEightSongViewController: UITableViewDataSource, UITableViewDelegate{
    //セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songList.count
    }
    
    //セルを作成
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //カスタムセルで生成
        let cell = selectSongTableView.dequeueReusableCellWithIdentifier("SelectSongTableViewCell", forIndexPath: indexPath) as! SelectSongTableViewCell
        cell.checkBox.tag = indexPath.row
        cell.checkBox.addTarget(self, action: "checkButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.checkBox.isChecked = checkFlags[indexPath.row]

        let song = self.songList[indexPath.row]
        
        cell.setSong(song)
        
        //println("cell count => \(indexPath.row)")
        
        return cell
    }
    
    //高さを計算したいけどとりあえず放置
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height :CGFloat! = nil
        // heightがnilの場合、とりあえず高さ40で設定 TODO
        if let h = height {
            return h
        } else {
            return 60//tableView.estimatedRowHeight
        }
    }
}

extension SelectEightSongViewController: UICollectionViewDataSource_Draggable, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView!, canMoveItemAtIndexPath indexPath: NSIndexPath!, toIndexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    //それを動かしていいか
    func collectionView(collectionView: UICollectionView!, canMoveItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView!, moveItemAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {
        println("drag")
        manager.moveSelectedSongInfo(fromIndexPath.row, to: toIndexPath.row)
        println(self.selectedSongs)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        println("\(indexPath.row)")
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("selectedSongCell", forIndexPath: indexPath) as! SelectedSongCell
        cell.setup(manager.selectedSongInfo()[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("select: \(indexPath.row)")
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        println("deselect: \(indexPath.row)")
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedSongs.count;
    }
}
