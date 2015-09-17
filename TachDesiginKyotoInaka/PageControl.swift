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
    private var barHeight: CGFloat = 3
    private var bottomOffset: CGFloat = 0
    
    var barMode: String = ""
    
    var fontsize: CGFloat! = nil

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, mode: String) {
        super.init(frame: frame)
        self.currentPage = 0
        self.barMode = mode
    }
    
    func setFontSize(size: CGFloat, isBold: Bool) {
        self.fontsize = size
        for pageCell in self.pageCells {
            pageCell.setFontSize(size, isBold: isBold, barMode: self.barMode)
        }
    }
    
    func pointIndex(index: Int) -> CGPoint {
        let width = self.frame.width / CGFloat(self.pageCells.count)
        let height = self.frame.height - self.bottomOffset
        
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
            if let size = self.fontsize {
                pageCell.titleLabel?.font = UIFont.systemFontOfSize(size)
            }
            tmpCells.append(pageCell)
            offsetX += width
            index++
        }
        
        self.pageCells = tmpCells
        
        //一旦消す
        for subview in self.subviews {
            if let subviewAsImageView = (subview as? UIImageView) {
                if subviewAsImageView == self.bar {
                    continue
                }
            }
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
        let width = self.frame.width / CGFloat(self.pageCells.count)
        if self.barMode == "bar" {
            self.barHeight = 3
            self.bottomOffset = 0
            if self.bar == nil {
                self.bar = UIImageView(frame: CGRectMake(0, 0, width, barHeight))
                self.bar.image = nil
                self.bar.backgroundColor = UIColor.colorFromRGB(ConstantShare.featureColorString, alpha: 1.0)

                //if self.bar.superview != self {
                    self.addSubview(self.bar)
                //}
                self.bar.layer.position = pointIndex(0)
            } else {
                self.bar.frame = CGRectMake(0, 0, width, barHeight)
                self.bar.layer.position = pointIndex(0)
            }
        } else if self.barMode == "triangle" {
            self.bottomOffset = 8
            if self.bar == nil {
                self.barHeight = 6
                self.bar = UIImageView(frame: CGRectMake(0, 0, width, barHeight))
                self.bar.backgroundColor = UIColor.clearColor()
                self.bar.image = UIImage(named: "TabArrow")
                self.bar.contentMode = UIViewContentMode.ScaleAspectFit
                //if self.bar.superview != self {
                self.addSubview(self.bar)
                    //}
                self.bar.layer.position = pointIndex(0)
            } else {
                self.bar.frame = CGRectMake(0, 0, width, barHeight)
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
        if self.pageCells.count > 0 {
            if let size = self.fontsize {
                self.pageCells[oldPage].setFontSize(size, isBold: false, barMode: self.barMode)
                self.pageCells[newPage].setFontSize(size, isBold: true, barMode: self.barMode)
            }
        }
        if self.barMode == "bar" {
            if self.bar == nil {
                updateBar()
            }
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.bar.layer.position = self.pointIndex(newPage)
            })
        } else if self.barMode == "triangle" {
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