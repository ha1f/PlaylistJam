//
//  PageControlCell.swift
//  TachDesiginKyotoInaka
//
//  Created by 山口 智生 on 2015/09/15.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import UIKit

class PageControlCell: UIButton {
    func setFontSize(size: CGFloat, isBold: Bool, barMode: PageControl.SelectedViewType) {
        if isBold {
            self.titleLabel?.textColor = UIColor.blackColor()
            if(barMode == PageControl.SelectedViewType.bar){
                self.titleLabel?.font = UIFont(name: "MyriadPro-Semibold", size: size)
            }else if(barMode == PageControl.SelectedViewType.triangle){
                self.titleLabel?.font = UIFont(name: "mplus-1m-bold", size: size)
            }
        } else {
            self.titleLabel?.textColor = UIColor.colorFromRGB(ConstantShare.unActiveTextColorString, alpha: 1)
            if(barMode == PageControl.SelectedViewType.bar){
                self.titleLabel?.font = UIFont(name: "MyriadPro-Regular", size: size)
            }else if(barMode == PageControl.SelectedViewType.triangle){
                self.titleLabel?.font = UIFont(name: "mplus-1c-light", size: size)
            }
        }
    }
}
