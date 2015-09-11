//
//  SongListViewController.swift
//  PictEdit
//
//  Created by 山口 智生 on 2015/07/02.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import UIKit

class SongListViewController: PageCellViewController{
    var songList: [Song] = []
    
    @IBOutlet var songTableView: UITableView!
    
    
    //dataobjectのセット、要override
    override func setDataObject(dataObject: AnyObject?){
        if let tmpDataObject: AnyObject = dataObject {
            self.songList = dataObject as! [Song]
        }else{
            println("DataObject is nil")
            //デフォルトの処理
            //self.songList
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        
        //tableViewの作成、delegate,dataSourceを設定
        self.songTableView.delegate = self
        self.songTableView.dataSource = self
        
        self.songTableView.backgroundColor = UIColor.blackColor()
        self.songTableView.separatorColor = UIColor.blackColor()
        
        self.songTableView.tableFooterView = UIView()
        
        //songTableView.registerClass(SongCell.self, forCellReuseIdentifier: "SongCell")
        
        self.view.addSubview(self.songTableView)
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
extension SongListViewController: UITableViewDataSource, UITableViewDelegate{
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
        let cell = tableView.dequeueReusableCellWithIdentifier("SongCell") as! SongCell
        
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
        
        if height != nil{
            return height
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
}
