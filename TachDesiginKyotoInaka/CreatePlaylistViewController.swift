//
//  CreatePlaylistViewController.swift
//  StoryBoardPractice
//
//  Created by 坂本時緒 on 9/13/15.
//  Copyright (c) 2015 坂本時緒. All rights reserved.
//

import UIKit

protocol ModalViewControllerDelegate{
    func modalDidFinished(nextSegue: String)
}

class CreatePlaylistViewController: BlurModalViewController {
    
    @IBOutlet weak var publicButton: UIButton!
    @IBOutlet weak var privateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var isCreated: Bool = false
    
    //rootに値を渡す
    var delegate: ModalViewControllerDelegate! = nil
    
    override func viewWillAppear(animated: Bool) {
        if self.isCreated {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.isCreated = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewProp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initViewProp(){
        
        self.view.backgroundColor = UIColor.clearColor()
        
        publicButton.layer.borderWidth = 1
        publicButton.layer.borderColor = colorFromRGB("FFFFFF", alpha: 1).CGColor
        publicButton.layer.cornerRadius = 3
        privateButton.layer.borderWidth = 1
        privateButton.layer.borderColor = colorFromRGB("FFFFFF", alpha: 1).CGColor
        privateButton.layer.cornerRadius = 3
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 3
        cancelButton.layer.borderColor = colorFromRGB("aaaaaa", alpha: 0.3).CGColor
        
        var back: UIImageView = UIImageView()
        var image: UIImage = UIImage(named: "art.jpg")!
        back.image = image
        
        //self.view.addSubview(back)
        
        //self.view.sendSubviewToBack(back)
        
        publicButton.addTarget(self, action: "createPublic:", forControlEvents: UIControlEvents.TouchUpInside)
        cancelButton.addTarget(self, action: "cancel:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func createPublic(sender: UIButton!) {
        self.isCreated = true
        self.delegate.modalDidFinished("createPublic")
    }
    
    func cancel(sender: UIButton!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //self.dismissViewControllerAnimated(true, completion: nil)
    }

    func colorFromRGB(rgb: String, alpha: CGFloat) -> UIColor {
        let scanner = NSScanner(string: rgb)
        var rgbInt: UInt32 = 0
        scanner.scanHexInt(&rgbInt)
        
        let r = CGFloat(((rgbInt & 0xFF0000) >> 16)) / 255.0
        let g = CGFloat(((rgbInt & 0x00FF00) >> 8)) / 255.0
        let b = CGFloat(rgbInt & 0x0000FF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}
