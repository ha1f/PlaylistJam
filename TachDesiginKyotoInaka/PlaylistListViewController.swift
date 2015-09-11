//
//  PlaylistListViewController.swift
//  TachDesiginKyotoInaka
//
//  Created by 山口 智生 on 2015/09/11.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import UIKit

class PlaylistListViewController: PageCellViewController{
    var playlistList: [Playlist] = []
    
    @IBOutlet var playlistTableView: UITableView!
    
    
    //dataobjectのセット、要override
    override func setDataObject(dataObject: AnyObject?){
        if let tmpDataObject: AnyObject = dataObject {
            self.playlistList = dataObject as! [Playlist]
        }else{
            println("DataObject is nil")
            //デフォルトの処理
            //self.playlistList
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        
        //tableViewの作成、delegate,dataSourceを設定
        self.playlistTableView.delegate = self
        self.playlistTableView.dataSource = self
        
        self.playlistTableView.backgroundColor = UIColor.blackColor()
        self.playlistTableView.separatorColor = UIColor.blackColor()
        
        self.playlistTableView.tableFooterView = UIView()
        
        self.view.addSubview(self.playlistTableView)
    }
    
    //画面の回転を検知
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
    }
    
    //Viewが表示される直前
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

//tableViewに対するdelegate
extension PlaylistListViewController: UITableViewDataSource, UITableViewDelegate{
    //選択された時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("selected: \(indexPath.row)")
        //self.performSegueWithIdentifier("tosend",sender: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playlistList.count
    }
    
    //セルを作成
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaylistCell") as! PlaylistCell
        
        //TODO ここのplaylistからがんばってcellをつくる
        let playlist = self.playlistList[indexPath.row]
        
        cell.titleLabel.text = playlist.getTitle()
        cell.backgroundColor = UIColor.darkGrayColor()
        cell.titleLabel.textColor = UIColor.whiteColor()
        
        println("create:\(indexPath.row)")
        
        return cell
    }
    
    //高さを計算したいけどとりあえず放置
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //let song = self.playlistList[indexPath.row]
        
        let height :CGFloat! = 120.0
        
        if height != nil{
            return height
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
}
