import UIKit

class SelectEightSongViewController: UIViewController {
    
    var songList:[Song] = []
    var selectedSongs: [Song] = [] {
        didSet{
            self.selectedCount.text = "\(selectedSongs.count)/8 曲"
        }
    }
    var checkFlags: [Bool] = []
    
    @IBOutlet weak var selectSongTableView: UITableView!
    @IBOutlet weak var selectedCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectSongTableView.delegate = self
        self.selectSongTableView.dataSource = self
        
        self.selectedCount.text = "\(selectedSongs.count)/8 曲"
        
        selectSongTableView.allowsSelection = false
        
        //同じ回数分
        for i in songList {
            self.checkFlags.append(false)
        }
        
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
                selectedSongs.append(songList[sender.tag])
            } else {
                sender.isChecked = false
            }
        } else {
            //削除
        }
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
        
        return cell
    }
    
    //高さを計算したいけどとりあえず放置
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height :CGFloat! = nil
        // heightがnilの場合、とりあえず高さ40で設定 TODO
        if let h = height{
            return h
        } else {
            return 60//tableView.estimatedRowHeight
        }
    }
}
