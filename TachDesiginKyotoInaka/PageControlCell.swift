//
//  PageControlCell.swift
//  TachDesiginKyotoInaka
//
//  Created by 山口 智生 on 2015/09/15.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import UIKit

class PageControlCell: UIButton {
    func setFontSize(size: CGFloat, isBold: Bool) {
        if isBold {
            self.titleLabel?.font = UIFont.boldSystemFontOfSize(size)
        } else {
            self.titleLabel?.font = UIFont.systemFontOfSize(size)
        }
    }
}
