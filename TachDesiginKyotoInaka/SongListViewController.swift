//
//  SongListViewController.swift
//  PictEdit
//
//  Created by 山口 智生 on 2015/07/02.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import Foundation
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
        /*self.songTableView.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height-100)
        self.songTableView.backgroundColor = UIColor.darkGrayColor()
        self.songTableView.allowsSelection = false
        self.songTableView.alwaysBounceVertical = true*/
        self.songTableView.delegate = self
        self.songTableView.dataSource = self
        
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
        println("Num: \(indexPath.row)")
        //self.performSegueWithIdentifier("tosend",sender: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songList.count
    }
    
    //セルを作成
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SongCell") as! SongCell
        
        let song = self.songList[indexPath.row]
        
        cell.titleLabel.text = song.title
        
        println("cell:\(indexPath.row)")
        
        return cell
    }
    
    //高さを計算したいけどとりあえず放置
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //let song = self.songList[indexPath.row]
        
        let height :CGFloat! = nil
        
        if height != nil{
            return height
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
}
