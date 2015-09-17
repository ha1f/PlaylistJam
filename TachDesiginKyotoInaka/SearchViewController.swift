//
//  SearchViewController.swift
//  TachDesiginKyotoInaka
//
//  Created by 山口 智生 on 2015/09/15.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import UIKit

class SearchViewController: PageCellViewController, UISearchBarDelegate {
    var data: String? = nil
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func setDataObject(dataObject: AnyObject?){
        if let tmpDataObject: AnyObject = dataObject {
            self.data = tmpDataObject as? String
        }else{
            println("DataObject is nil")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapped:")
        self.view.addGestureRecognizer(tapGesture)
        
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.clearColor()
        searchBar.barStyle = UIBarStyle.Black
        
    }
    
    func tapped(sender: AnyObject?) {
        resignFirstResponderIfNeeded()
    }
    
    func resignFirstResponderIfNeeded() {
        if searchBar.isFirstResponder() {
            searchBar.resignFirstResponder()
        }
    }
    
    /*
    テキストが変更される毎に呼ばれる
    */
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    /*
    Cancelボタンが押された時に呼ばれる
    */
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        resignFirstResponderIfNeeded()
    }
    
    /*
    Searchボタンが押された時に呼ばれる
    */
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        resignFirstResponderIfNeeded()
    }
    
}
