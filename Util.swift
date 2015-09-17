//
//  Util.swift
//  TachDesiginKyotoInaka
//
//  Created by 山口 智生 on 2015/09/17.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import UIKit


extension UIView {
    func resize(width: CGFloat, height: CGFloat) {
        self.frame = CGRectMake(self.frame.minX, self.frame.minY, width, height)
    }
}