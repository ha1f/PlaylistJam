//
//  SongCell.swift
//  TachDesiginKyotoInaka
//
//  Created by 山口 智生 on 2015/09/11.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import UIKit

class SongCell:UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    var jacekt: UIImageView!
    
    func setSong(song: Song) {
        self.titleLabel.text = song.title
        self.backgroundColor = UIColor.darkGrayColor()
        self.titleLabel.textColor = UIColor.whiteColor()
    }
}
