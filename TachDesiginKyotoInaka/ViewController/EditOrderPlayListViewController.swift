import UIKit



/** 最後の詳細設定画面 */
class EditOrderSongViewController: UIViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var songListTableView: UITableView!
    @IBOutlet weak var moodBtn: UIButton!
    @IBOutlet weak var finishBarButton: UIBarButtonItem!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var descField: UITextView!
    
    let manager = SongsManager.manager
    var selectedSongCount = 0
    var selectMoodModalViewController: SelectMoodModalViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //謎のずれる現象を治す(自動調整機能をOFF)
        self.automaticallyAdjustsScrollViewInsets = false;

        self.songListTableView.delegate = self
        self.songListTableView.dataSource = self
        self.songListTableView.editing = true

        moodBtn.addTarget(self, action: "showModal:", forControlEvents:.TouchUpInside)
        initViewProp()

        selectedSongCount = manager.selectedSongCount()
        songListTableView.reloadData()
        
        self.finishBarButton.target = self
        self.finishBarButton.action = "finishEditting:"
        
        self.titleField.tag = 1
        self.titleField.delegate = self
        self.titleField.returnKeyType = .Done
        
        self.descField.tag = 2
        self.descField.delegate = self
        
        updateButtonEnable()
    }
    
    //完了ボタン
    func finishEditting(sender: UIBarButtonItem!) {
        if updateButtonEnable() {
            Playlist.createWithSongAndInit([
                "title": titleField.text,
                "desc": descField.text
            ], songs: manager.selectedSongs())
        
            println("finsh")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
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
        //各枠線
        moodBtn.layer.borderWidth = 1
        moodBtn.layer.cornerRadius = 3
        titleField.layer.borderWidth = 1
        titleField.layer.cornerRadius = 3
        descField.layer.borderWidth = 1
        descField.layer.cornerRadius = 3
        
        moodBtn.layer.borderColor = UIColor.colorFromRGB("dcdcdc", alpha: 1).CGColor
        titleField.layer.borderColor = UIColor.colorFromRGB("dcdcdc", alpha: 1).CGColor
        descField.layer.borderColor = UIColor.colorFromRGB("dcdcdc", alpha: 1).CGColor
        
        setColorToPlaceHolder(UIColor.colorFromRGB("bcbcbc", alpha: 1), field: titleField)
        
        
        placeholderLabel.hidden = false
    }
   
    //任意のUITextFieldのプレイスホルダーの色を指定する関数
    func setColorToPlaceHolder(color: UIColor, field: UITextField){
        field.attributedPlaceholder = NSAttributedString(string:field.placeholder!,
            attributes:[NSForegroundColorAttributeName: color])
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
        println("IIIII   \(indexPath.row)")
        return cell
    }
    
    //高さを計算したいけどとりあえず放置
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height :CGFloat! = nil
        println("height => \(height)");
        // heightがnilの場合、とりあえず高さ40で設定 TODO
        if let h = height{
            return h
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

extension EditOrderSongViewController: UITextViewDelegate, UITextFieldDelegate {
    //textviewがフォーカスされたら、Labelを非表示
    func textViewShouldBeginEditing(textView: UITextView) -> Bool
    {
        self.placeholderLabel.hidden = true
        return true
    }
    
    //textviewからフォーカスが外れて、TextViewが空だったらLabelを再び表示
    func textViewDidEndEditing(textView: UITextView) {
        if(textView.text.isEmpty){
            self.placeholderLabel.hidden = false
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        println("change:\(textView.tag)")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        updateButtonEnable()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        updateButtonEnable()
        //変更は常に許可
        return true
    }
    
    //完了ボタンが押せるかどうか更新
    func updateButtonEnable() -> Bool{
        var isNotEmpty: Bool = false
        isNotEmpty = (count(self.titleField.text) > 0)
        self.finishBarButton.enabled = isNotEmpty
        return isNotEmpty
    }

    
}

//RGB文字列からUIColorを生成する関数
extension UIColor {
    static func colorFromRGB(rgb: String, alpha: CGFloat) -> UIColor {
        let scanner = NSScanner(string: rgb)
        var rgbInt: UInt32 = 0
        scanner.scanHexInt(&rgbInt)
        
        let r = CGFloat(((rgbInt & 0xFF0000) >> 16)) / 255.0
        let g = CGFloat(((rgbInt & 0x00FF00) >> 8)) / 255.0
        let b = CGFloat(rgbInt & 0x0000FF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}