//
//  PostCell.swift
//  Echo
//
//  Created by AGW on 12/25/14.
//  Copyright (c) 2014 Andrew Wetherington. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    var post_id:Int!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var upvote: UIButton!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var downvote: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(content:String, ups:Int, downs:Int, rating:Int){
        self.content.text = content
        self.upvote.setTitle(String(ups), forState: UIControlState.Normal)
        self.downvote.setTitle(String(downs), forState: UIControlState.Normal)
        self.rating.text = String(rating)
        
    }
    
    
}
