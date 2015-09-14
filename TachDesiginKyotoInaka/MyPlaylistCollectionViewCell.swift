//
//  MyPlaylistCollectionViewCell.swift
//  TachDesiginKyotoInaka
//
//  Created by 坂本時緒 on 9/14/15.
//  Copyright (c) 2015 NextVanguard. All rights reserved.
//

import UIKit

class MyPlaylistCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var mainArtworkImageView: UIImageView!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var sub1ArtworkImageView: UIImageView!
    @IBOutlet weak var sub2ArtworkImageView: UIImageView!

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playlistTitleLabel: UILabel!
    @IBOutlet weak var playlistCommentLabel: UILabel!

    func setup(playlist: Playlist) {
        initViewProp()
        
        var mainArtwork: NSData = getImageByURL(playlist.songs[0].artworkUrl)
        self.mainArtworkImageView.image = UIImage(data: mainArtwork)
        var sub1Artwork: NSData = getImageByURL(playlist.songs[1].artworkUrl)
        self.sub1ArtworkImageView.image = UIImage(data: sub1Artwork)
        var sub2Artwork: NSData = getImageByURL(playlist.songs[2].artworkUrl)
        self.sub2ArtworkImageView.image = UIImage(data: sub2Artwork)
        self.playlistTitleLabel.text = playlist.title
        self.playlistCommentLabel.text = playlist.desc
    }
    
    func getImageByURL(url: String) -> NSData{
        // URLを指定したUIImageの生成例
        let url = NSURL(string: url)
        var err: NSError?;
        var imageData :NSData = NSData(contentsOfURL: url!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!;
        return imageData
        //var img = UIImage(data:imageData);
 
    }
    
    func initViewProp(){
        var colorList: [CGColor] = []
        colorList.append(UIColor.colorFromRGB("000000", alpha: 0).CGColor)
        var locations: [CGFloat] = []
        locations.append(0.0)
        locations.append(0.8)
        colorList.append(UIColor.blackColor().CGColor)
        setGradient(self.infoView, colorList: colorList, locations: locations)
        
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
