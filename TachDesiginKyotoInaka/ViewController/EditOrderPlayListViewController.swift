//
//  ViewController.swift
//  StoryBoardPractice
//
//  Created by 坂本時緒 on 9/11/15.
//  Copyright (c) 2015 坂本時緒. All rights reserved.
//

import UIKit

class EditOrderSongViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var songListTableView: UITableView!
    @IBOutlet weak var moodBtn: UIButton!
    @IBOutlet weak var finishBarButton: UIBarButtonItem!
    

    let manager = SongsManager.manager
    var songList: [Song] = []
    var selectMoodModalViewController: SelectMoodModalViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableViewの作成、delegate,dataSourceを設定
        self.songListTableView.delegate = self
        self.songListTableView.dataSource = self
        self.songListTableView.editing = true
        
        //ムード選択モーダル表示ボタンのイベント登録
        moodBtn.addTarget(self, action: "showModal:", forControlEvents:.TouchUpInside)
        
        //Viewのプロパティ初期化
        initViewProp()

        songList = map(manager.selectedSongInfo()) { return $0.song }
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
        // カスタムセルを登録
        self.songListTableView.registerNib(UINib(nibName:"EditOrderSongTableViewCell", bundle: nil), forCellReuseIdentifier: "EditOrderSongTableViewCell")
    }
    
    //Viewのプロパティ初期化
    func initViewProp(){
        moodBtn.layer.borderWidth = 1
        moodBtn.layer.cornerRadius = 3
    }    
}

//tableViewに対するdelegate
extension EditOrderSongViewController: UITableViewDataSource, UITableViewDelegate{
    //選択された時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    //セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songList.count
    }
    
    //セルを作成
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //カスタムセルで生成
        let cell = songListTableView.dequeueReusableCellWithIdentifier("EditOrderSongTableViewCell", forIndexPath: indexPath) as! EditOrderSongTableViewCell
        var songLen = self.songList.count
        let song = self.songList[indexPath.row]
        
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
            return 40//tableView.estimatedRowHeight
        }
    }
    
    //順番変更を有効にする
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        var itemToMove = songList[fromIndexPath.row]
        songList.removeAtIndex(fromIndexPath.row)
        songList.insert(itemToMove, atIndex: toIndexPath.row)
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
            self.moodBtn.setTitle("＋　"+moodText!, forState: UIControlState.Normal)
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