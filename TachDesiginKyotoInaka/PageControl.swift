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
    private var bar: UIImageView = UIImageView()
    
    private var currentPage: Int = 0 //現在のページ
    private var identity = 0 //タグ的な、複数設置した時のため
    
    var delegate: PageControlDelegate!
    
    var selectedViewType = PageControl.SelectedViewType.bar
    
    //設定
    private var barHeight: CGFloat = 3
    private var bottomOffset: CGFloat = 0
    private var fontsize: CGFloat = 12
    
    //選択されたセルの表示
    enum SelectedViewType {
        case triangle
        case bar
        case none
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, mode: PageControl.SelectedViewType) {
        super.init(frame: frame)
        self.selectedViewType = mode
        self.currentPage = 0
        self.addSubview(self.bar)
    }
    
    func setCellBold(cell: PageControlCell, isBold: Bool) {
        var color: UIColor!
        var font: UIFont!
        if self.selectedViewType == PageControl.SelectedViewType.bar {
            if isBold {
                color = UIColor.blackColor()
                font = UIFont(name: "MyriadPro-Semibold", size: self.fontsize)
            } else {
                color = UIColor.colorFromRGB(ConstantShare.unActiveTextColorString, alpha: 1)
                font = UIFont(name: "MyriadPro-Regular", size: self.fontsize)
            }
        }else if self.selectedViewType == PageControl.SelectedViewType.triangle {
            if isBold {
                color = UIColor.blackColor()
                font = UIFont(name: "mplus-1m-bold", size: self.fontsize)
            } else {
                color = UIColor.colorFromRGB(ConstantShare.unActiveTextColorString, alpha: 1)
                font = UIFont(name: "mplus-1c-light", size: self.fontsize)
            }
        }
        
        cell.setFont(font, color: color)
        
    }

    func setFontSize(size: CGFloat) {
        self.fontsize = size
        for pageCell in self.pageCells {
            setCellBold(pageCell, isBold: false)
        }
    }
    
    //indexから場所を生成
    func pointIndex(index: Int) -> CGPoint {
        let width = self.frame.width / CGFloat(self.pageCells.count)
        let height = self.frame.height - self.bottomOffset
        
        let pointX: CGFloat = CGFloat(index) * width
        return CGPoint(x: pointX + width/2, y: (height - barHeight/2))
    }
    
    func setPages(data: [String]) {
        var tmpCells: [PageControlCell] = []
        let width = self.frame.width / CGFloat(data.count)
        let height = self.frame.height
        
        //一旦消す
        for view in self.pageCells {
            view.removeFromSuperview()
        }
 
        var index = 0 //何番目か
        for datum in data {
            let pageCell = PageControlCell(frame: CGRectMake(width * CGFloat(index), 0, width, height))
            pageCell.setTitle(datum, forState: UIControlState.Normal)
            pageCell.backgroundColor = UIColor.clearColor()
            pageCell.addTarget(self, action: "pageSelected:", forControlEvents: UIControlEvents.TouchUpInside)
            pageCell.tag = index
            setCellBold(pageCell, isBold: false)
            self.addSubview(pageCell)
            tmpCells.append(pageCell)
            index++
        }
        self.pageCells = tmpCells
        
        self.initBar()
        
        //初期ページ
        setCurrentPage(self.currentPage)
    }
    
    func initBar() {
        if self.pageCells.count == 0 {
            println("must be initialized")
            return
        }
        let width = self.frame.width / CGFloat(self.pageCells.count)
        if self.selectedViewType == SelectedViewType.bar {
            self.barHeight = 3
            self.bottomOffset = 0
            self.bar.resize(width, height: self.barHeight)
            self.bar.image = nil
            self.bar.backgroundColor = UIColor.colorFromRGB(ConstantShare.featureColorString, alpha: 1.0)
        } else if self.selectedViewType == SelectedViewType.triangle {
            self.bottomOffset = 8
            self.barHeight = 6
            self.bar.resize(width, height: self.barHeight)
            self.bar.backgroundColor = UIColor.clearColor()
            self.bar.image = UIImage(named: "TabArrow")
            self.bar.contentMode = UIViewContentMode.ScaleAspectFit
        }
    }
    
    func setIdentity(identity: Int) {
        self.identity = identity
    }
    
    func getIdentity() -> Int {
        return self.identity
    }
    
    func pageSelected(sender: PageControlCell!) {
        setCurrentPage(sender.tag)
        self.delegate.pageSelected(self.identity, page: sender.tag)
    }
    
    private func isValidPage(page: Int) -> Bool {
        if (page < self.pageCells.count) && (page >= 0) {
            return true
        }
        return false
    }
    
    //currentPageをセット＆表示を変化させる
    func setCurrentPage(page: Int) {
        if !isValidPage(page) {
            println("InValid page")
            return
        }
        
        moveEmphasis(self.currentPage, newPage: page)
            
        self.currentPage = page
    }
    
    //強調のスタイルを適用
    private func moveEmphasis(oldPage: Int, newPage: Int) {
        if isValidPage(oldPage) {
            setCellBold(self.pageCells[oldPage], isBold: false)
        }
        if isValidPage(newPage) {
            setCellBold(self.pageCells[newPage], isBold: true)
        }
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bar.layer.position = self.pointIndex(newPage)
        })
    }
    
    func getCurrentPage() -> Int {
        return self.currentPage
    }
}