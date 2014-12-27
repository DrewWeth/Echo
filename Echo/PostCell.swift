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
    @IBOutlet weak var profile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(content:String, ups:Int, downs:Int, rating:Int, profile_url:String?){
        self.content.text = content
        self.upvote.setTitle(String(ups), forState: UIControlState.Normal)
        self.downvote.setTitle(String(downs), forState: UIControlState.Normal)
        self.rating.text = String(rating)
        
        if (profile_url != "empty"){
            var url = NSURL(string: profile_url!)
            var data = NSData(contentsOfURL: url!)
            self.profile.image = UIImage(data: data!)

        }
        else{
            self.profile.image = UIImage(named: "background.jpg")
        }
        
        
        // Nasty image stuff
        self.profile.layer.cornerRadius = self.profile.frame.size.width / 2
        self.profile.clipsToBounds = true
        self.profile.layer.borderWidth = 0.5
        self.profile.layer.borderColor = UIColor.whiteColor().CGColor
        self.profile.contentMode = .ScaleAspectFill
        
        
        
    }
    
    
}
