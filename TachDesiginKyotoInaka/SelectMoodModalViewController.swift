//
//  SelectMoodModalViewController.swift
//  TachDesiginKyotoInaka
//
//  Created by 坂本時緒 on 9/13/15.
//  Copyright (c) 2015 NextVanguard. All rights reserved.

import UIKit

class SelectMoodModalViewController: UIViewController{
    
    var delegate: SelectMoodModalViewControllerDelegate! = nil
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var moodTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moodTableView.delegate = self
        self.moodTableView.dataSource = self
        
        //キャンセルボタンの見た目変更
        cancelBtn.layer.backgroundColor = UIColor.colorFromRGB("303030", alpha: 1).CGColor
        //キャンセルボタンのイベント登録
        cancelBtn.addTarget(self, action: "cancel:", forControlEvents: .TouchUpInside)
        //テーブルビューの背景透明に
        moodTableView.backgroundColor = UIColor.clearColor()
        moodTableView.separatorColor = UIColor.colorFromRGB("555555", alpha: 1)
        
        
        moodTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //ムードを選択せずにモーダル閉じる関数
    func cancel(sender: AnyObject) {
        delegate.modalDidFinished(nil)
    }
    
    //ムードを選択して詳細設定画面にインデックスを渡す & モーダルを閉じる関数
    func selectMood(moodIndex: Int){
        delegate.modalDidFinished(moodIndex)
    }
}

extension SelectMoodModalViewController: UITableViewDataSource, UITableViewDelegate{
    
    //選択された時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectMood(indexPath.row)
    }
    
    // セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConstantShare.moodList.count
    }
    
    //セルの内容を変更
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.text = ConstantShare.moodList[indexPath.row]
        cell.textLabel?.textColor = UIColor.lightGrayColor()
        println("celltext=> \(cell.textLabel?.text)")
        return cell
    }
    
    //セルの高さ
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let height :CGFloat! = nil
        
        if height != nil{
            return height
        } else {
            return 50//tableView.estimatedRowHeight
        }
    }
}

//詳細設定画面への通知のためのプロトコル
protocol SelectMoodModalViewControllerDelegate{
    func modalDidFinished(mood: Int?)
}
