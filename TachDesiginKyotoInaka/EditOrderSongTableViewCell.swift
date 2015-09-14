//
//  EditOrderSongTableViewCell.swift
//  StoryBoardPractice
//
//  Created by 坂本時緒 on 9/11/15.
//  Copyright (c) 2015 坂本時緒. All rights reserved.
//

import UIKit

class EditOrderSongTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setSong(song: Song){
        titleLabel.text = song.title
        artistLabel.text = song.artist
        artworkImageView.sd_setImageWithURL(NSURL(string: song.artworkUrl)!)
    }
}