//
//  CreatePlaylistNavigationController.swift
//  TachDesiginKyotoInaka
//
//  Created by 山口 智生 on 2015/09/14.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import UIKit

class CreatePlaylistNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        self.navigationBar.barTintColor = UIColor.colorFromRGB(ConstantShare.navbarColorString, alpha: 1)
        self.navigationBar.tintColor = UIColor.whiteColor()
    }
}
