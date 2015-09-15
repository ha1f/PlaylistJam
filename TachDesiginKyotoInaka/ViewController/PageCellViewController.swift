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
    private var index: Int? //pageControllerの識別のため
    var parent : PreSelectDataController?
    
    //必ずオーバーライドする
    func setDataObject(dataObject: AnyObject?){
    }
    
    final func getIndex()->Int?{
        return self.index
    }
    final func setIndex(index: Int?){
        self.index = index
    }

    func listen(parent: PreSelectDataController) {
        self.parent = parent
    }

    func appendSelectedItem(i: Int) {
        if !(self.parent?.contain(self.index!, itemIndex: i) ?? false) {
            self.parent?.appendSelectedItem(self.index!, itemIndex: i)
        }
    }

    func removeSelectedItem(i: Int) {
        if self.parent?.contain(self.index!, itemIndex: i) ?? false {
            self.parent?.removeSelectedItem(self.index!, itemIndex: i)
        }
    }
    
    func getSelectedItem() -> [Int] {
        if let h = self.parent?.getSelectedItem(self.index!) {
            return h
        }
        return []
    }
}

