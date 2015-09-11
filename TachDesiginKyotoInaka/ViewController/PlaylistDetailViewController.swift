//
//  PlaylistDetailViewController.swift
//  TachDesiginKyotoInaka
//
//  Created by 山口 智生 on 2015/09/11.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import UIKit

/** 
* playlistListから呼び出し
* モーダル的な表示
*/
class PlaylistDetailViewController: UIViewController {
    
    @IBOutlet var songTableView: UITableView!
    
    var songList: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blueColor()
        
        var song = Song()
        song.title = "たいとー"
        
        var song2 = Song()
        song2.title = "たいとる"
        
        songList = [song, song2]
        
        //tableViewの作成、delegate,dataSourceを設定
        self.songTableView.delegate = self
        self.songTableView.dataSource = self
        
        self.songTableView.backgroundColor = UIColor.blackColor()
        self.songTableView.separatorColor = UIColor.blackColor()
        
        self.songTableView.tableFooterView = UIView()
    }
}

extension PlaylistDetailViewController: UITableViewDataSource, UITableViewDelegate{
    //選択された時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("selected: \(indexPath.row)")
        //self.performSegueWithIdentifier("tosend",sender: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songList.count
    }
    
    //セルを作成
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaylistDetailSongCell") as! PlaylistDetailSongCell
        
        //TODO ここのsongからがんばってcellをつくる
        let song = self.songList[indexPath.row]
        
        cell.titleLabel.text = song.title
        cell.backgroundColor = UIColor.darkGrayColor()
        cell.titleLabel.textColor = UIColor.whiteColor()
        
        println("create:\(indexPath.row)")
        
        return cell
    }
    
    //高さを計算したいけどとりあえず放置
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //let song = self.songList[indexPath.row]
        
        let height :CGFloat! = 80.0
        
        if let h = height{
            return h
        } else {
            return tableView.estimatedRowHeight
        }
    }
}