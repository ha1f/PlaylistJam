//
//  CheckButton.swift
//  TachDesiginKyotoInaka
//
//  Created by 坂本時緒 on 9/13/15.
//  Copyright (c) 2015 NextVanguard. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    
    //images
    let checkedImage = UIImage(named: "checkedButton")
    let unCheckedImage = UIImage(named: "unCheckedButton")
    
    //bool propety
    var isChecked:Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, forState: .Normal)
            }else{
                self.setImage(unCheckedImage, forState: .Normal)
            }
        }
    }
    
    
    override func awakeFromNib() {
        self.isChecked = false
    }
}
