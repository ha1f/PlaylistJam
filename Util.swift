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


//RGB文字列からUIColorを生成する関数
extension UIColor {
    static func colorFromRGB(rgbString: String, alpha: CGFloat) -> UIColor {
        var rgb = rgbString
        if rgbString[rgbString.startIndex] == "#" {
            rgb = rgbString.substringFromIndex(advance(rgbString.startIndex, 1))
        }
        
        
        let scanner = NSScanner(string: rgb)
        var rgbInt: UInt32 = 0
        scanner.scanHexInt(&rgbInt)
        
        let r = CGFloat(((rgbInt & 0xFF0000) >> 16)) / 255.0
        let g = CGFloat(((rgbInt & 0x00FF00) >> 8)) / 255.0
        let b = CGFloat(rgbInt & 0x0000FF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}