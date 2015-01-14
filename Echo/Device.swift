//
//  Device.swift
//  Echo
//
//  Created by AGW on 12/24/14.
//  Copyright (c) 2014 Andrew Wetherington. All rights reserved.
//

import Foundation
import UIKit


class Device : NSObject {
    var data:NSMutableArray!
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var profilePic:UIImage
    var profilePicDownloaded:Bool
    
    init(device_token_from_parse:String){
        self.profilePic = UIImage(named:"")!
        self.data = NSMutableArray()
        self.profilePicDownloaded = false
        // DEVELOPMENT: Reset Mylist.plist
//        self.data = []
//        self.saveData()
//        println(self.data)
        super.init()
        self.loadData()
        if (self.data.count == 0){
            println("Device not registered. Now registering")
            registerDevice(device_token_from_parse)
        }
        else
        {
            println("Device is registered.")
            println(self.data)
        }
    }
    
    
    // Load data
    func loadData(){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0)as NSString
        let path = documentsDirectory.stringByAppendingPathComponent("MyFile.plist")
        
        let fileManager = NSFileManager.defaultManager()
        
        // Check if file exists
        if(!fileManager.fileExistsAtPath(path))
        {
            // If it doesn't, copy it from the default file in the Resources folder
            self.saveData()
        }
        
        self.data = NSMutableArray(contentsOfFile: path)
        
        
    }
    
    // Load data
    func loadData(something:AnyObject, position:Int?){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0)as NSString
        let path = documentsDirectory.stringByAppendingPathComponent("MyFile.plist")
        
        let fileManager = NSFileManager.defaultManager()
        
        // Check if file exists
        if(!fileManager.fileExistsAtPath(path))
        {
            // If it doesn't, copy it from the default file in the Resources folder
            println("We've got problems. Check your overloaded loadData function in Device class")
            self.saveData()
        }
        else
        {
            if (position != nil){
                self.data[position!] = something
            }
            else{
                self.data.addObject(something)
            }
            
            self.saveData()
        }
        
        self.data = NSMutableArray(contentsOfFile: path)
        
//         DEVELOPMENT: Reset Mylist.plist
//        self.data = []
//        self.saveData()
//        println("Resetting device complete")

    }
    
    
    func transferData(response:NSDictionary){
        println(response)
        var data = response["data"] as NSDictionary
        var id = String((data["id"] as Int))
        var auth_key = String(data["auth_key"] as String)
        self.data.addObject(id)
        self.data.addObject(auth_key)
        println("printing response: \(data)")
        self.saveData()
    }
    
    func registerDevice(parse_token:String){
        appDelegate.service.submitRegistration({
            (response) in
            self.transferData(response as NSDictionary)
        }, parse_token:parse_token)
    }

    
    func saveData(){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as NSString
        let path = documentsDirectory.stringByAppendingPathComponent("MyFile.plist")
        println("saving")
        self.data.writeToFile(path, atomically: true)
    }
    
    
}