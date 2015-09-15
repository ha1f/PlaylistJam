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

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.currentPage = 0
        self.backgroundColor = UIColor.redColor()
    }
    
    func setActive(cell: PageControlCell) {
        cell.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
    }
    func setInActive(cell: PageControlCell) {
        cell.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    func setPages(data: [String]) {
        self.pageCells = []
        let width = self.frame.width / CGFloat(data.count)
        let height = self.frame.height
        var offsetX: CGFloat = 0
        //何番目か
        var index = 0
        for datum in data {
            let pageCell = PageControlCell(frame: CGRectMake(offsetX, 0, width, height))
            pageCell.setTitle(datum, forState: UIControlState.Normal)
            setInActive(pageCell)
            pageCell.backgroundColor = UIColor.blueColor()
            pageCell.addTarget(self, action: "pageSelected:", forControlEvents: UIControlEvents.TouchUpInside)
            pageCell.tag = index
            self.pageCells.append(pageCell)
            offsetX += width
            index++
        }
        
        for page in pageCells {
            self.addSubview(page)
        }
        
        //初期ページ
        setCurrentPage(0)
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
        if let oldPage = self.currentPage {
            //oldのビューを更新
            self.setInActive(pageCells[oldPage])
        }
        self.currentPage = page
        self.setActive(pageCells[self.currentPage!])
    }
    
    func getCurrentPage() -> Int {
        return self.currentPage!
    }
}