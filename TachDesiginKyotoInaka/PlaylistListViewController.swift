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
        self.playlistCollectionView.delegate = self
        self.playlistCollectionView.dataSource = self
        
        self.playlistCollectionView.backgroundColor = UIColor.blackColor()
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
    // MARK: - UICollectionViewDelegate Protocol
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PlaylistCell", forIndexPath: indexPath) as! PlaylistCell
        
        let song = self.playlistList[indexPath.row]
        
        cell.titleLabel.text = song.title
        
        cell.backgroundColor = UIColor.darkGrayColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        println("select: \(indexPath.row)")
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath)
    {
        println("deselect: \(indexPath.row)")
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlistList.count;
    }

    
}
