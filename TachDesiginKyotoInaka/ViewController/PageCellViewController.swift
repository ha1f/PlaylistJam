//
//  PageCellViewController.swift
//  PictEdit
//
//  Created by 山口 智生 on 2015/07/02.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import Foundation
import UIKit


class PageCellViewController: UIViewController {
    private var index: Int?//pageControllerの識別のため
    
    //必ずオーバーライドする
    func setDataObject(dataObject: AnyObject?){
    }
    
    final func getIndex()->Int?{
        return self.index
    }
    final func setIndex(index: Int?){
        self.index = index
    }
}