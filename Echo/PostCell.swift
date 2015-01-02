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

    

    required init(coder aDecoder: NSCoder) {
        super.init()
        self.profile = UIImageView()
        self.profile.layer.cornerRadius = self.profile.frame.size.width / 2
        self.profile.clipsToBounds = true
        self.profile.layer.borderWidth = 1.0
        self.profile.layer.borderColor = UIColor.whiteColor().CGColor
        self.profile.contentMode = .ScaleAspectFill

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(content:String, ups:Int, downs:Int, rating:Int, image:UIImage){
        
        self.content.text = content
        self.upvote.setTitle(String(ups), forState: UIControlState.Normal)
        self.downvote.setTitle(String(downs), forState: UIControlState.Normal)
        self.rating.text = String(rating)
        self.profile.image = image
        
        
    }
    
}
