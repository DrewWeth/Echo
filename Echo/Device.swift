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

    
    override init(){
        super.init() // So I can call functions
        self.data = NSMutableArray()
        self.loadData()
        println(self.data)
        if (self.data.count == 0){
            println("Device not registered. Now registering")
            registerDevice()
        }
        else
        {
            println("device_id: \(data[0]) \(data[1])")
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
    
    func transferData(response:NSDictionary){
        var id = String((response["id"] as Int))
        var auth_key = String(response["auth_key"] as String)
        self.data.addObject(id)
        self.data.addObject(auth_key)
        println("printing response: \(response)")
        self.saveData()
    }
    
    func registerDevice(){
        appDelegate.service.submitRegistration {
            (response) in
            self.transferData(response as NSDictionary)
        }
    }

    
    func saveData(){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as NSString
        let path = documentsDirectory.stringByAppendingPathComponent("MyFile.plist")
        println("saving")
        self.data.writeToFile(path, atomically: true)
    }
    
    
}