//
//  PageControl.swift
//  TachDesiginKyotoInaka
//
//  Created by 山口 智生 on 2015/09/15.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import UIKit

protocol PageControlDelegate {
    func pageSelected(identity: Int, page: Int)
}

class PageControl: UIView {
    private var pageCells: [PageControlCell] = []
    private var currentPage:Int? = nil
    //タグ的な
    private var identity = 0
    
    var delegate: PageControlDelegate!
    
    var bar: UIImageView! = nil
    let barHeight: CGFloat = 3
    
    var barMode: String = ""

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, mode: String) {
        super.init(frame: frame)
        self.currentPage = 0
        self.barMode = mode
    }
    
    func setFontSize(size: CGFloat) {
        for pageCell in self.pageCells {
            pageCell.titleLabel?.font = UIFont.systemFontOfSize(size)
        }
    }
    
    func pointIndex(index: Int) -> CGPoint {
        let width = self.frame.width / CGFloat(self.pageCells.count)
        let height = self.frame.height
        
        let pointX: CGFloat = CGFloat(Double(index) * Double(width))
        return CGPoint(x: pointX + width/2, y: (height - barHeight/2))
    }
    
    func setPages(data: [String]) {
        var tmpCells: [PageControlCell] = []
        let width = self.frame.width / CGFloat(data.count)
        let height = self.frame.height
        var offsetX: CGFloat = 0
        //何番目か
        var index = 0
        for datum in data {
            let pageCell = PageControlCell(frame: CGRectMake(offsetX, 0, width, height))
            pageCell.setTitle(datum, forState: UIControlState.Normal)
            pageCell.backgroundColor = UIColor.clearColor()
            pageCell.addTarget(self, action: "pageSelected:", forControlEvents: UIControlEvents.TouchUpInside)
            pageCell.tag = index
            tmpCells.append(pageCell)
            offsetX += width
            index++
        }
        
        self.pageCells = tmpCells
        
        //一旦消す
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        //そしてadd
        for page in pageCells {
            self.addSubview(page)
        }
        
        //初期ページ
        setCurrentPage(0)
        
        updateBar()
    }
    
    func updateBar() {
        if self.barMode == "bar" {
            if self.bar == nil {
            let width = self.frame.width / CGFloat(self.pageCells.count)
            self.bar = UIImageView(frame: CGRectMake(0, 0, width, barHeight))
            self.bar.backgroundColor = UIColor.colorFromRGB(ConstantShare.featureColorString, alpha: 1.0)

            if self.bar.superview != self {
                self.addSubview(self.bar)
            }
            self.bar.layer.position = pointIndex(0)
            }
        }
    }
    
    func setIdentity(identity: Int) {
        self.identity = identity
    }
    
    func getIdentity() -> Int {
        return self.identity
    }
    
    func pageSelected(sender: PageControlCell!) {
        self.delegate.pageSelected(self.identity, page: sender.tag)
    }
    
    func setCurrentPage(page: Int) {
        var newPage = page
        if newPage > self.pageCells.count - 1 {
            newPage = self.pageCells.count - 1
        }
        
        if let oldPage = self.currentPage {
            if oldPage < self.pageCells.count {
                moveEmphasis(oldPage, newPage: newPage)
            }
        }
        self.currentPage = newPage
    }
    
    func moveEmphasis(oldPage: Int, newPage: Int) {
        //self.setInActive(pageCells[oldPage])
        //self.setActive(pageCells[newPage])
        if self.barMode == "bar" {
            if self.bar == nil {
                updateBar()
            }
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.bar.layer.position = self.pointIndex(newPage)
            })
        }
    }
    
    func getCurrentPage() -> Int {
        return self.currentPage!
    }
}