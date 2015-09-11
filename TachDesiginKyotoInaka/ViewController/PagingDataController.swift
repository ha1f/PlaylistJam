//
//  PagingDataController.swift
//  PictEdit
//
//  Created by 山口 智生 on 2015/07/02.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import Foundation
import UIKit

class PagingDataController: NSObject, UIPageViewControllerDataSource {
    var pageProperty = NSArray()
    
    init(pageIdentities: NSArray) {
        super.init()
        self.pageProperty = pageIdentities
    }
    
    //必ずオーバーライドさせる
    func viewControllerAtIndex(index: Int) -> PageCellViewController? {
        // Return the data view controller for the given index.
        if (self.pageProperty.count == 0) || (index >= self.pageProperty.count) {
            return nil
        }
        return nil
    }
    
    func indexOfViewController(viewController: PageCellViewController) -> Int {
        if let tmpindex = viewController.getIndex() {
            return tmpindex
        } else {
            return NSNotFound
        }
    }
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! PageCellViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! PageCellViewController)
        if index == NSNotFound {
            return nil
        }
        
        index++
        if index == self.pageProperty.count {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
}