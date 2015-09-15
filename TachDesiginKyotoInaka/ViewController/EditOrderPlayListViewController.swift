import UIKit

class EditOrderSongViewController: UIViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var songListTableView: UITableView!
    @IBOutlet weak var moodBtn: UIButton!
    @IBOutlet weak var finishBarButton: UIBarButtonItem!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var descField: UITextView!
    
/*<<<<<<< HEAD
    let manager = SelectedSongsManager.manager
    var songList: [Song] = []
=======*/

    let manager = SongsManager.manager
    var selectedSongCount = 0
//>>>>>>> origin/master
    var selectMoodModalViewController: SelectMoodModalViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.songListTableView.delegate = self
        self.descField.delegate = self
        self.songListTableView.dataSource = self
        self.songListTableView.editing = true

        moodBtn.addTarget(self, action: "showModal:", forControlEvents:.TouchUpInside)
        initViewProp()

        selectedSongCount = manager.selectedSongCount()
        songListTableView.reloadData()
        
        self.finishBarButton.target = self
        self.finishBarButton.action = "finishEditting:"
    }
    
    //完了ボタン
    func finishEditting(sender: UIBarButtonItem!) {
        println("finsh")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView() {
        super.loadView()
        self.songListTableView.registerNib(
            UINib(nibName:"EditOrderSongTableViewCell", bundle: nil),
            forCellReuseIdentifier: "EditOrderSongTableViewCell"
        )
    }

    func initViewProp(){
        moodBtn.layer.borderWidth = 1
        moodBtn.layer.cornerRadius = 3
        moodBtn.layer.borderColor = UIColor.colorFromRGB("333333", alpha: 1).CGColor
        moodBtn.backgroundColor = UIColor.whiteColor()
        descField.layer.cornerRadius = 3
        
        placeholderLabel.hidden = false
    }
    
    }

//tableViewに対するdelegate
extension EditOrderSongViewController: UITableViewDataSource, UITableViewDelegate{
    //選択された時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    //セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedSongCount
    }
    
    //セルを作成
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = songListTableView.dequeueReusableCellWithIdentifier("EditOrderSongTableViewCell", forIndexPath: indexPath) as! EditOrderSongTableViewCell
        let song = manager.findFormSelectedSongInfo(indexPath.row).song
        cell.setSong(song)
        
        return cell
    }
    
    //高さを計算したいけどとりあえず放置
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height :CGFloat! = nil
        // heightがnilの場合、とりあえず高さ40で設定 TODO
        if height != nil{
            return height
        } else {
            return 70//tableView.estimatedRowHeight
        }
    }
    
    //順番変更を有効にする
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        manager.moveSelectedSongInfo(fromIndexPath.row, to: toIndexPath.row)
    }
    
    //削除ボタンを非表示にする
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
        
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
}

extension EditOrderSongViewController: SelectMoodModalViewControllerDelegate {
    
    //ムードのindexを受け取ってセット & モーダルを消す関数  
    //* キャンセルが選択された場合、引数はnil
    func modalDidFinished(mood: Int?){
        self.selectMoodModalViewController.dismissViewControllerAnimated(true, completion: nil)
        if mood != nil{
            var moodText: String? = ConstantShare.moodList[mood!]
            self.moodBtn.setTitle(moodText!, forState: UIControlState.Normal)
        }
    }
    
    //ムードの選択モーダル表示
    func showModal(sender: AnyObject){
        self.selectMoodModalViewController = self.storyboard!.instantiateViewControllerWithIdentifier("selectMoodModal") as! SelectMoodModalViewController
        //デリゲート設定 (ここでいいのかな?)
        self.selectMoodModalViewController.delegate = self
        self.presentViewController(self.selectMoodModalViewController, animated: true, completion: nil);
    }
}

extension EditOrderSongViewController: UITextViewDelegate{
    
    //textviewがフォーカスされたら、Labelを非表示
    func textViewShouldBeginEditing(textView: UITextView) -> Bool
    {
        self.placeholderLabel.hidden = true
        return true
    }
    
    //textviewからフォーカスが外れて、TextViewが空だったらLabelを再び表示
    func textViewDidEndEditing(textView: UITextView) {
        
        println("finifh")
        if(textView.text.isEmpty){
            self.placeholderLabel.hidden = false
        }
    }

    
}

//RGB文字列からUIColorを生成する関数
extension UIColor {
    class func colorFromRGB(rgb: String, alpha: CGFloat) -> UIColor {
        let scanner = NSScanner(string: rgb)
        var rgbInt: UInt32 = 0
        scanner.scanHexInt(&rgbInt)
        
        let r = CGFloat(((rgbInt & 0xFF0000) >> 16)) / 255.0
        let g = CGFloat(((rgbInt & 0x00FF00) >> 8)) / 255.0
        let b = CGFloat(rgbInt & 0x0000FF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}