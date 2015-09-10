//
//  MyPlaylistList.swift
//  CaIntern
//
//  Created by 山口 智生 on 2015/09/10.
//  Copyright © 2015年 NextVanguard. All rights reserved.
//

import Foundation

class MyPlaylistList: NSObject {
    private var list: Array<Playlist>!
    
    func getList() -> Array<Playlist>! {
        return self.list
    }
}