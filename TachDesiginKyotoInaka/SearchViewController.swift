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
    
    override func setDataObject(dataObject: AnyObject?){
        if let tmpDataObject: AnyObject = dataObject {
            self.data = tmpDataObject as? String
        }else{
            println("DataObject is nil")
        }
    }
}
