//
//  SelectSongViewController.swift
//  TachDesiginKyotoInaka
//
//  Created by 坂本時緒 on 9/13/15.
//  Copyright (c) 2015 NextVanguard. All rights reserved.
//

import UIKit

class SelectSongViewController: UIViewController {
    
    var songList:[Song] = []

    @IBOutlet weak var selectSongTableView: UITableView!
    @IBOutlet weak var selectedCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectSongTableView.delegate = self
        self.selectSongTableView.dataSource = self
        
        songList = genTestData( 15 )
        
        selectSongTableView.reloadData()
    }
    
    override func loadView() {
        super.loadView()
        // カスタムセルを登録
        self.selectSongTableView.registerNib(UINib(nibName:"SelectSongTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectSongTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SelectSongViewController: UITableViewDataSource, UITableViewDelegate{
    //セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songList.count
    }
    
    //セルを作成
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //カスタムセルで生成
        let cell = selectSongTableView.dequeueReusableCellWithIdentifier("SelectSongTableViewCell", forIndexPath: indexPath) as! SelectSongTableViewCell
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
            return 60//tableView.estimatedRowHeight
        }
    }
}
