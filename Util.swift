//
//  Util.swift
//  TachDesiginKyotoInaka
//
//  Created by 山口 智生 on 2015/09/17.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import UIKit


extension UIView {
    //左上座標を維持してリサイズ
    func resize(width: CGFloat, height: CGFloat) {
        self.frame = CGRectMake(self.frame.minX, self.frame.minY, width, height)
    }
}


extension UIColor {
    //RGB文字列からUIColorを生成する関数
    class func colorFromRGB(rgb: String, alpha: CGFloat) -> UIColor {
        var rgbString = rgb
        if rgb[rgbString.startIndex] == "#" {
            rgbString = rgb.substringFromIndex(rgb.startIndex.advancedBy(1))
        }
        
        let scanner = NSScanner(string: rgbString)
        var rgbInt: UInt32 = 0
        if scanner.scanHexInt(&rgbInt) {
            return UIColor(
                red: CGFloat(((rgbInt & 0xFF0000) >> 16)) / 255.0,
                green: CGFloat(((rgbInt & 0x00FF00) >> 8)) / 255.0,
                blue: CGFloat(rgbInt & 0x0000FF) / 255.0, alpha: alpha
            )
        }
        //Illegal format
        return UIColor.blackColor()
    }
}