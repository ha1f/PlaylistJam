//
//  BlurModalViewController.swift
//  TachDesiginKyotoInaka
//
//  Created by 山口 智生 on 2015/09/16.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import UIKit

/** 
* ブラーの掛かったモーダル
* 背景は透明にしておく
*/
class BlurModalViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        // blur effect view作る styleはdark
        let blurEffect = UIBlurEffect(style:.Dark)
        let visualEffectView = UIVisualEffectView(effect:blurEffect)
        visualEffectView.frame = self.view.frame
        
        // blur効果をかけたいviewを作成
        let view = UIView(frame:self.view.frame)
        
        // blur効果viewのcontentViewにblur効果かけたいviewを追加
        visualEffectView.contentView.addSubview(view)
        
        self.view.addSubview(visualEffectView)
        
        self.view.sendSubviewToBack(visualEffectView)
    }
}
