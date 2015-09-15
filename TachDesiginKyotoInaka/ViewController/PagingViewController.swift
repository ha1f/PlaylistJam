//
//  PagingViewController.swift
//  PictEdit
//
//  Created by 山口 智生 on 2015/07/02.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import Foundation
import UIKit

class PagingViewController: UIViewController, UIPageViewControllerDelegate{
    var pageViewController: UIPageViewController?
    
    var pageData = NSArray()
    
    var trasitionStyle = UIPageViewControllerTransitionStyle.Scroll
    var navigationOrientation = UIPageViewControllerNavigationOrientation.Horizontal
    
    var dataController: PagingDataController {
        if self._dataController == nil {
            self._dataController = createDataController()
        }
        return self._dataController!
    }
    
    var _dataController: PagingDataController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //オーバーライドさせる
    func createDataController() -> PagingDataController{
        return PagingDataController(pageIdentities: self.pageData)
    }
    
    func createView(){
        self.pageViewController = UIPageViewController(transitionStyle: self.trasitionStyle, navigationOrientation: self.navigationOrientation, options: nil)
        self.pageViewController!.delegate = self
        
        let startingViewController = self.dataController.viewControllerAtIndex(0)!
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })
        
        self.pageViewController!.dataSource = self.dataController
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        
        //viewを作成
        var pageViewRect = self.view.bounds
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {//iPadのときは縁をつくる
            pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0)
        }
        self.pageViewController!.view.frame = pageViewRect
        
        self.pageViewController!.didMoveToParentViewController(self)
        
        
        self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
    }
    
    // MARK: - UIPageViewController delegate methods
    //画面の回転を検知
    func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        if (orientation == .Portrait) || (orientation == .PortraitUpsideDown) || (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
            let currentViewController = self.pageViewController!.viewControllers[0] as! UIViewController
            //let currentViewController = self.PagingDataController.viewControllerAtIndex(0)!
            let viewControllers = [currentViewController]
            self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })
            self.pageViewController!.doubleSided = false//trueなら表裏表示される
            return UIPageViewControllerSpineLocation.Min
        }
        
        // 見開きモード(viewControllersには2つ入る)
        let currentViewController = self.pageViewController!.viewControllers[0] as! PageCellViewController
        var viewControllers: [AnyObject]
        
        let indexOfCurrentViewController = self.dataController.indexOfViewController(currentViewController)
        if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
            let nextViewController = self.dataController.pageViewController(self.pageViewController!, viewControllerAfterViewController: currentViewController)
            viewControllers = [currentViewController, nextViewController!]
        } else {
            let previousViewController = self.dataController.pageViewController(self.pageViewController!, viewControllerBeforeViewController: currentViewController)
            viewControllers = [previousViewController!, currentViewController]
        }
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })
        
        return .Mid
    }
    
    //ページ遷移前に呼ばれる
    /*func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
    self.pendingPage = self.PagingDataController.indexOfViewController(pendingViewControllers[0] as! ImagePageCellViewController)
    }*/
    
    //ページ遷移アニメーション完了後
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        //println(self.PagingDataController.indexOfViewController(previousViewControllers[0] as! ImagePageCellViewController))
        //その時のページをPageControlにセット
    }
}