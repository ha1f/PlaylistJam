//
//  SearchViewController.swift
//  TachDesiginKyotoInaka
//
//  Created by 山口 智生 on 2015/09/15.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import UIKit

class SearchViewController: PageCellViewController {
    var data: String? = nil
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func setDataObject(dataObject: AnyObject?){
        if let tmpDataObject: AnyObject = dataObject {
            self.data = tmpDataObject as? String
        }else{
            println("DataObject is nil")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barHeight: CGFloat = searchBar.frame.height
        //searchBar.layer.position = CGPointMake(64 + PreSelectViewController.tabHeight + barHeight/2, self.view.frame.width/2)
        println("barHeight:\(barHeight)")
    }
}
