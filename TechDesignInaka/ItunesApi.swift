//
//  ItunesApi.swift
//  CaIntern
//
//  Created by 山口 智生 on 2015/09/10.
//  Copyright © 2015年 NextVanguard. All rights reserved.
//

/**
Parameter
パラメーターについては、Appleのドキュメントに書いてある。

term
検索キーワード。URLエンコード必要。必須キー。

country
iTunes Storeの国を指定する。日本だったら JP 。必須。

entity
iTunesで検索できるもの(曲や映画やアプリ)を絞り込むキー。必須ではない。

callback
JSONP。 javascriptでcallback functionを使う場合指定する。
必須ではない。
*/

import Foundation

class ItunesApi {
    static let base_url = "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch"
    
    
}
