//
//  CompleteViewController.swift
//  TachDesiginKyotoInaka
//
//  Created by 山口 智生 on 2015/09/16.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import UIKit

class CompleteViewController: BlurModalViewController {
    var delegate: ModalViewControllerDelegate!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        
        sharedFlag.isPlaylistCreated = false
        
        let iconSize = self.view.frame.width/2
        let imageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, iconSize, iconSize))
        imageView.image = UIImage(named: "Complete")
        imageView.layer.position = self.view.center
        imageView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(imageView)
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapped:")
        self.view.addGestureRecognizer(tapGesture)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("onUpdate:"), userInfo: nil, repeats: true)
    }
    
    func kill() {
        self.dismissViewControllerAnimated(true, completion: nil)
        //self.delegate.modalDidFinished("")
    }
    
    func onUpdate(sender: AnyObject?) {
        kill()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
    }
    
    func tapped(sender: AnyObject?) {
        kill()
    }

}
