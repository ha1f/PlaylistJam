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

class CreatePlaylistViewController: UIViewController {
    
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
        
        self.view.backgroundColor = UIColor.colorFromRGB("000000", alpha: 0)
        
        publicButton.layer.borderWidth = 1
        publicButton.layer.borderColor = colorFromRGB("FFFFFF", alpha: 1).CGColor
        publicButton.layer.cornerRadius = 5
        privateButton.layer.borderWidth = 1
        privateButton.layer.borderColor = colorFromRGB("FFFFFF", alpha: 1).CGColor
        privateButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = colorFromRGB("FFFFFF", alpha: 1).CGColor
        
        
        
        // blur effect view作る styleはdark
        let blurEffect = UIBlurEffect(style:.Dark)
        let visualEffectView = UIVisualEffectView(effect:blurEffect)
        visualEffectView.frame = self.view.frame;
        
        // blur効果をかけたいviewを作成
        let view = UIView(frame:self.view.frame);
        
        // blur効果viewのcontentViewにblur効果かけたいviewを追加
        visualEffectView.contentView.addSubview(view)
        
        // 表示〜
        self.view.addSubview(visualEffectView);
        self.view.bringSubviewToFront(visualEffectView);
        //self.addVirtualEffectView(effect)
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
    
    /*
    エフェクトを適用する.
    */
    func addVirtualEffectView(effect : UIBlurEffect!){
        
        // Blurエフェクトを適用するEffectViewを作成.
        var blurView = UIVisualEffectView(effect: effect)
        blurView.frame = CGRectMake(0, 0, 200, 400)
        blurView.layer.position = CGPointMake(20, 40)
        blurView.layer.masksToBounds = true
        blurView.layer.cornerRadius = 20.0
        self.view.addSubview(blurView)
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
