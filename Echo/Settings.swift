//
//  Settings.swift
//  Echo
//
//  Created by AGW on 12/22/14.
//  Copyright (c) 2014 Andrew Wetherington. All rights reserved.
//

import Foundation

class Settings{
    var PostsURL = "http://apii.herokuapp.com/posts/nearby?latitude=38.5016981&longitude=-90.3991102"
    var PostsMethod = "get"
    
    var submitURL = "http://apii.herokuapp.com/posts/submit?device_id=1&auth_key=wvuR3vuCtr"
    var submitMethod = "post"
}
