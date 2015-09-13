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
    var playlists: [Playlist] = []

    override func createDataController() -> PagingDataController {
        return SongListViewDataController(pageIdentities: self.pageData)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        fetchPlaylistsAnd {
            self.pageData = [self.playlists]
            println(self.playlists)

            self.trasitionStyle = UIPageViewControllerTransitionStyle.Scroll
            self.navigationOrientation = UIPageViewControllerNavigationOrientation.Horizontal
            self.createView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func fetchPlaylistsAnd(completion: (Void -> Void))  {
        SampleData().fetchPlaylistsAnd { (playlists) in
            self.playlists = playlists
            completion()
        }
    }
}

//PagingDataControllerをオーバーライドしてDataControllerクラスを作成
class SongListViewDataController: PagingDataController{
    //これだけは必ずオーバーライド
    override func viewControllerAtIndex(index: Int) -> PageCellViewController? {
        super.viewControllerAtIndex(index)
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let dataViewController: PageCellViewController!
        
        let sendData: AnyObject = self.pageProperty[index]
        
        //SongかPlaylistか判定してViewControllerを切り替え
        if let tmp = sendData[0] as? Song {
            dataViewController = storyboard.instantiateViewControllerWithIdentifier("SongListViewController") as! SongListViewController
        } else {
            dataViewController = storyboard.instantiateViewControllerWithIdentifier("PlaylistListViewController") as! PlaylistListViewController
        }
        
        dataViewController.setDataObject(sendData)//dataObjectをセット
        dataViewController.setIndex(index)//indexをセットしておく
        return dataViewController
    }
}