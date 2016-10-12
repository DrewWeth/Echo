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
    
    func getPosts (callback:(AnyObject) -> (), latitude:String, longitude:String, device_id:String, last:String = "", since:String = "") {
        var url_string = settings.baseUrl + settings.PostsURL + "&latitude=" + latitude + "&longitude=" + longitude + "&device_id=" + device_id

        if (last != ""){
            url_string += "&before=" + last
        }
        else if (since != ""){
            url_string += "&since=" + since
        }
        
        
        request(url_string, method: settings.PostsMethod, callback: callback)
    }
    
    
    
    func submitPost(callback:(AnyObject) -> (), content:String, latitude:String, longitude:String, device_id:String, auth_key:String, postUrl:String = "") {
        var new_url = settings.baseUrl + settings.submitURL + "&content=" + content.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! + "&latitude=" + latitude + "&longitude=" + longitude + "&device_id=" + device_id + "&auth_key=" + auth_key + "&post_url=" + postUrl
        println(new_url)
        request(new_url, method: settings.submitMethod, callback: callback)
    }
    
    func submitVote(callback:(AnyObject)->(), voteType:Int, postID:Int, deviceId:String, authKey:String){
        var new_url = settings.baseUrl
        if (voteType == 1) {
            new_url += settings.upVoteURL
        }
        else if (voteType == 2){
            new_url += settings.downVoteURL
        }
        new_url += "post_id=" + String(postID) + "&device_id=" + deviceId + "&auth_key=" + authKey
        
        request(new_url, method: settings.voteMethod, callback: callback)
    }
    
    func submitRegistration(callback:(AnyObject)->(), parse_token:String) {
        request(settings.baseUrl + settings.registerURL + "parse_token=" + parse_token, method: settings.registerMethod, callback:callback)
    }
    
    func postProfileUrl(callback:(AnyObject)->(), device_id:String, auth_key:String, profile_url:String) {
        var new_url = settings.baseUrl + settings.updateProfileUrl + "device_id=" + device_id + "&auth_key=" + auth_key + "&profile_url=" + profile_url
        request( new_url, method: "post", callback:callback)
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













