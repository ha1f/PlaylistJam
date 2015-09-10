//
//  PlayList.swift
//  CaIntern
//
//  Created by 山口 智生 on 2015/09/10.
//  Copyright © 2015年 NextVanguard. All rights reserved.
//

import Foundation

class Playlist: NSObject {
    private var id: Int         //id
    private var title: String!  //タイトル
    private var desc: String!   //説明
    private var author: String! //作成者
    
    init (id: Int){
        self.id = id
    }
    
    private var list: Array<MusicData!>!
    
    func getTitle() -> String! {
        return self.title
    }
    
    func getId() -> Int {
        return self.id
    }
    
    func getDesc() -> String! {
        return self.desc
    }
    
    func getList() -> Array<MusicData!> {
        return self.list
    }
}
