//
//  PlaylistCell.swift
//  TachDesiginKyotoInaka
//
//  Created by 山口 智生 on 2015/09/11.
//  Copyright (c) 2015年 NextVanguard. All rights reserved.
//

import UIKit

class PlaylistCell:UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    var jacekt: UIImageView!
    
    func setPlaylist(playlist: Playlist) {
        self.titleLabel.text = playlist.title
    }
}
