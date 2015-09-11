//
//  TutorialViewController.swift
//  PictEdit
//
//  Created by 山口 智生 on 2015/07/01.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//



import Foundation
import UIKit

/** 前段階の選択 */
class PreSelectViewController: PagingViewController {
    override func createDataController() -> PagingDataController {
        return SongListViewDataController(pageIdentities: self.pageData)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        var song = Song()
        song.title = "たいとー"
        
        var song2 = Song()
        song2.title = "たいとる"
        //いまはダミーデータだがここにデータをセット
        self.pageData = [[song], [song2, song, song2], [song, song]]
        
        self.trasitionStyle = UIPageViewControllerTransitionStyle.Scroll
        self.navigationOrientation = UIPageViewControllerNavigationOrientation.Horizontal
        self.createView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//PagingDataControllerをオーバーライドしてDataControllerクラスを作成
class SongListViewDataController: PagingDataController{
    //これだけは必ずオーバーライド
    override func viewControllerAtIndex(index: Int) -> PageCellViewController? {
        super.viewControllerAtIndex(index)
        
        //let dataViewController = SongListViewController()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let dataViewController = storyboard.instantiateViewControllerWithIdentifier("SongListViewController") as! SongListViewController
        
        dataViewController.setDataObject(self.pageProperty[index])//dataObjectをセット
        dataViewController.setIndex(index)//indexをセットしておく
        return dataViewController
    }
}