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
    
    @IBOutlet var playlistCollectionView: UICollectionView!
    
    //dataobjectのセット、要override
    override func setDataObject(dataObject: AnyObject?){
        if let tmpDataObject: [Playlist] = dataObject as? [Playlist] {
            self.playlistList = tmpDataObject
        } else {
            println("DataObject is nil")
            //デフォルトの処理
            //self.playlistList
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.9)
        
        //tableViewの作成、delegate,dataSourceを設定
        self.playlistCollectionView.delegate = self
        self.playlistCollectionView.dataSource = self
        
        self.playlistCollectionView.backgroundColor = UIColor.clearColor()
        self.playlistCollectionView.allowsMultipleSelection = true
        
        self.view.addSubview(self.playlistCollectionView)
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
extension PlaylistListViewController: UICollectionViewDataSource,UICollectionViewDelegate {

    //選択された時
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PlaylistCell", forIndexPath: indexPath) as! PlaylistCell

        cell.setup(self.playlistList[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        self.performSegueWithIdentifier("showDetail", sender: nil)
        println("select: \(indexPath.row)")
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        println("deselect: \(indexPath.row)")
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlistList.count;
    }
}
