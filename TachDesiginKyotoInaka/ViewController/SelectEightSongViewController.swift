import UIKit
import DraggableCollectionView

class SelectEightSongViewController: UIViewController {
    let manager = SongsManager.manager
    var appendedSongCount: Int = 0
    var selectedSongCount: Int = 0 {
        didSet {
            self.selectedCount.text = "\(selectedSongCount)/8 曲"
        }
    }
    var preSelectedCount = 0

    var checkFlags: [Bool] = []

    @IBOutlet weak var selectSongTableView: UITableView!
    @IBOutlet weak var selectedCount: UILabel!
    @IBOutlet weak var selectedCollection: UICollectionView!
    @IBOutlet weak var selectedSongsView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        selectSongTableView.separatorColor = UIColor.colorFromRGB(ConstantShare.tableSeparaterColorString, alpha: 1)
        //謎のずれる現象の対策
        self.automaticallyAdjustsScrollViewInsets = false;
        selectedSongsView.backgroundColor = UIColor.colorFromRGB(ConstantShare.selectedSongAreaColorString, alpha: 1)
        
        appendedSongCount = manager.appendedSongCount()
        self.selectSongTableView.delegate = self
        self.selectSongTableView.dataSource = self
        self.selectedCount.text = "\(selectedSongCount)/8 曲"
        selectSongTableView.backgroundColor = UIColor.clearColor()

        //同じ回数分
        for i in 0..<appendedSongCount {
            self.checkFlags.append(false)
        }

        selectedCollection.delegate = self
        selectedCollection.dataSource = self
        selectedCollection.draggable = true

        selectSongTableView.reloadData()
        
        
    }

    override func loadView() {
        super.loadView()

        self.selectSongTableView.registerNib(
            UINib(nibName:"SelectSongTableViewCell", bundle: nil),
            forCellReuseIdentifier: "SelectSongTableViewCell"
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func clickedCheckButton(sender: CheckBox!) {

        println("select!!!!!")
        if self.selectedSongCount < 8 {
            sender.isChecked = !sender.isChecked
            checkFlags[sender.tag] = sender.isChecked
            if sender.isChecked {
                self.manager.selectSongInfo(sender.tag)
                //選択曲が増えていたら選択曲画面スクロール(ごめんなさい!)
                if(self.selectedSongCount > 2){
                    self.scrollToNewer()
                }
            }else{
                self.manager.removeSongInfo(sender.tag)
            }
        } else {
            if sender.isChecked {
                sender.isChecked = false
                self.manager.removeSongInfo(sender.tag)
            }
        }
        self.selectedSongCount = manager.selectedSongCount()
        self.selectedCollection.reloadData()
        
    }
    
    func scrollToNewer(){
        var areaSize: CGSize = selectedCollection.frame.size
        
        var point = CGPointMake( selectedCollection.contentSize.width - selectedCollection.frame.size.width+90,0)
        
        selectedCollection.setContentOffset(point, animated: true)
        
    }
}

extension SelectEightSongViewController: UITableViewDataSource, UITableViewDelegate{
    //セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appendedSongCount
    }

    //セルを作成
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //カスタムセルで生成
        let cell = selectSongTableView.dequeueReusableCellWithIdentifier("SelectSongTableViewCell", forIndexPath: indexPath) as! SelectSongTableViewCell
        cell.checkBox.tag = indexPath.row
        cell.checkBox.addTarget(self, action: "clickedCheckButton:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.checkBox.isChecked = checkFlags[indexPath.row]

        let song = manager.findFromAppendedSongInfo(indexPath.row).song
        cell.setSong(song)
        //セルの背景変更
        cell.backgroundColor = UIColor.colorFromRGB(ConstantShare.tableCelBackColorString, alpha: 1)
        //セル選択中のハイライト解除
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.colorFromRGB(ConstantShare.tableCelBackColorString, alpha: 1)
    }

    //高さを計算したいけどとりあえず放置
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height :CGFloat! = nil

        if let h = height {
            return h
        } else {
            return 60//tableView.estimatedRowHeight
        }
    }
    
    //セルが選択された時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("didselect!!!!!!")
        self.clickedCheckButton((tableView.cellForRowAtIndexPath(indexPath) as! SelectSongTableViewCell).checkBox)
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
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        println("\(indexPath.row)")
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("selectedSongCell", forIndexPath: indexPath) as! SelectedSongCell
        cell.setSong(manager.findFormSelectedSongInfo(indexPath.row).song)
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
        return self.selectedSongCount;
    }
}
