//
//  SelectSongTableViewCell.swift
//  TachDesiginKyotoInaka
//
//  Created by 坂本時緒 on 9/13/15.
//  Copyright (c) 2015 NextVanguard. All rights reserved.
//

import UIKit

class SelectSongTableViewCell: UITableViewCell {

    @IBOutlet weak var artWorkImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSong(song: Song){
        songNameLabel.text = song.title
        artistNameLabel.text = song.artist
        artWorkImage.sd_setImageWithURL(NSURL(string: song.artworkUrl)!)
        
    }
}
