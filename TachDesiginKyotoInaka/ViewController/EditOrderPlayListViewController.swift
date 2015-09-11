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
    var songList: [Song] = []
    var tableData = ["one", "two", "three", "four", "five"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableViewの作成、delegate,dataSourceを設定
        self.songListTableView.delegate = self
        self.songListTableView.dataSource = self
        self.songListTableView.editing = true
        
        //Viewのプロパティ初期化
        initViewProp()
        
        //テストデータの挿入
        songList = genTestData(20)
        songListTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //テストデータ生成関数
    func genTestData(dataLen: Int) -> [Song]{
        var testList: [Song] = []
        for(var i=0;i<dataLen;i++){
            var song = Song()
            song.id = i
            song.artworkUrl = "sample"
            song.artist = "artist"+String(i)
            song.title = "song"+String(i)
            song.itunesTrackId = ""
            testList.append(song)
        }
        return testList
    }
    
}

//tableViewに対するdelegate
extension EditOrderSongViewController: UITableViewDataSource, UITableViewDelegate{
    //選択された時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Num: \(indexPath.row)")
        //self.performSegueWithIdentifier("tosend",sender: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("%d",self.songList.count)
        return self.songList.count
    }
    
    
    
    //セルを作成
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = songListTableView.dequeueReusableCellWithIdentifier("EditOrderSongTableViewCell", forIndexPath: indexPath) as! EditOrderSongTableViewCell
        
        var songLen = self.songList.count
        let song = self.songList[indexPath.row]
        NSLog("%s",song.title)
        cell.setSong(song)
        
        return cell
    }
    
    //高さを計算したいけどとりあえず放置
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let height :CGFloat! = nil
        
        NSLog("height => %d",tableView.estimatedRowHeight)
        
        if height != nil{
            return height
        } else {
            return 40//tableView.estimatedRowHeight
        }
    }
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        var itemToMove = songList[fromIndexPath.row]
        songList.removeAtIndex(fromIndexPath.row)
        songList.insert(itemToMove, atIndex: toIndexPath.row)
        
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
        
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
}

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