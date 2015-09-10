//
//  PlayList.swift
//  CaIntern
//
//  Created by 山口 智生 on 2015/09/10.
//  Copyright © 2015年 NextVanguard. All rights reserved.
//

import Foundation

class PlayList: NSObject {
    private var title: String!
    private var desc: String!
    
    private var list: Array<MusicData!>!
    
    func getTitle() -> String! {
        return title
    }
    
    func getDesc() -> String! {
        return desc
    }
    
    func getList() -> Array<MusicData!> {
        return list;
    }
}
