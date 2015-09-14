//
//  HomeViewController.swift
//  TachDesiginKyotoInaka
//
//  Created by 山口 智生 on 2015/09/13.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
   
    var pageData: NSArray = []
    var playlists: [Playlist] = []
    var songs: [Song] = []
    var controller: PreSelectDataController?
    
    @IBOutlet weak var playlistCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewProp()
        
        fetchPlaylistsAnd{
            println("list count ==>>>>\(self.playlists.count)")
            self.pageData = [self.playlists, self.songs, self.songs]
            self.playlistCollectionView.dataSource = self
            self.playlistCollectionView.delegate = self
            self.playlistCollectionView.reloadData()
        }
    }
    
    func initViewProp(){
        var colorList: [CGColor] = []
        colorList.append(UIColor.colorFromRGB("333333", alpha: 1).CGColor)
        colorList.append(UIColor.colorFromRGB("303030", alpha: 1).CGColor)
        var locations: [CGFloat] = []
        locations.append(0.0)
        locations.append(1.0)
        setGradient(self.view, colorList: colorList, locations: locations)
    }
    
    private func fetchPlaylistsAnd(completion: (Void -> Void))  {
        SampleData().fetchDataAnd { (playlists, songs) in
            println("QQQQQQQ")
            self.playlists = playlists
            self.songs = songs
            completion()
        }
    }
    
    func setGradient(view: UIView, colorList: [CGColor]?, locations: [CGFloat]){
        //グラデーションの色を配列で管理
        let gradientColors: [CGColor]? = colorList
        
        //グラデーションレイヤーを作成
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        //グラデーションの色をレイヤーに割り当てる
        gradientLayer.colors = gradientColors
        //グラデーションレイヤーをスクリーンサイズにする
        gradientLayer.frame = view.bounds
        
        gradientLayer.locations = locations
        
        //グラデーションレイヤーをビューの一番下に配置
        view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //最初だったらヘッダのセルを表示
        var cellID: String
        var playlist: Playlist?
        if(indexPath.row==0){
            cellID = "MyPlaylistCollectionHeaderCell"
            playlist = nil
        }else{
            cellID = "MyPlaylistCollectionViewCell"
            playlist = playlists[indexPath.row-1]
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! UICollectionViewCell
        if let list = playlist{
            (cell as! MyPlaylistCollectionViewCell).setup(playlist!)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        // 条件に従ってサイズを変更する。
        var size: CGSize = CGSize.zeroSize
        if(indexPath.row == 0){
            size = CGSize(width: 360, height: 80)
        }else{
            size = CGSize(width: 360, height: 237)
        }
        return size
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // self.performSegueWithIdentifier("showDetail", sender: nil)
        //appendSelectedItem(indexPath.row)
        println("select: \(indexPath.row)")
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        println("deselect: \(indexPath.row)")
        //removeSelectedItem(indexPath.row)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count+1;
    }
}