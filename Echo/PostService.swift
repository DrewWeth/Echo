//
//  PostService.swift
//  Echo
//
//  Created by AGW on 12/21/14.
//  Copyright (c) 2014 Andrew Wetherington. All rights reserved.
//

import Foundation

class PostService {
    var settings:Settings!
    
    init(){
        self.settings = Settings()
    }
    
    func getPosts (callback:(AnyObject) -> (), latitude:String, longitude:String, last:String = "") {
        var url_string = settings.PostsURL + "&latitude=" + latitude + "&longitude=" + longitude
        if (last != ""){
            url_string += "&last=" + last
        }
        request(url_string, method: settings.PostsMethod, callback: callback)
    }
    
    func submitPost(callback:(AnyObject) -> (), content:String, latitude:String, longitude:String) {
        var new_url = settings.submitURL + "&content=" + content.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! + "&latitude=" + latitude + "&longitude=" + longitude
        println(new_url)
        request(new_url, method: settings.submitMethod, callback: callback)
    }
    
    
    
    func request(url:String, method:String, callback:(AnyObject) -> ()){
        println(url)
        var nsURL = NSURL(string:url)!
        var request = NSMutableURLRequest(URL: nsURL)
        request.HTTPMethod = method
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            // more closure shit that i dont understand
            (data, response, error) in
            var error:NSError?
            var response = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)!
            callback(response)
        }
        task.resume()
    }
}