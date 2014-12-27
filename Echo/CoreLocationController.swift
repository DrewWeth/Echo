//
//  CoreLocationController.swift
//  Echo
//
//  Created by AGW on 12/23/14.
//  Copyright (c) 2014 Andrew Wetherington. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


class CoreLocationController : NSObject, CLLocationManagerDelegate{
    var locationManager:CLLocationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D!
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var initLocation:Bool!
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.distanceFilter  = 1000 // Must move at least 3km
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation() // why wont this work
        self.initLocation = true
//        self.getInitPosts()
    }
    
    func getInitPosts(){
        println("Getting posts")
        self.appDelegate.service.getPosts ({
            (response) in
            self.appDelegate.masterController.loadPosts(response as NSArray)
            }, latitude: self.getCurrentLatitude(), longitude: self.getCurrentLongitude(), last:"")

    }
    
    func getCurrentLatitude() -> String{
        
        return String(format:"%f", self.currentLocation.latitude)
    }
    func getCurrentLongitude() -> String{
        return String(format:"%f", self.currentLocation.longitude)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.currentLocation = manager.location.coordinate
        println("locations = \(self.currentLocation.latitude) \(self.currentLocation.longitude)")
        if (self.initLocation == true ){
            println("Initial location given, asking for posts.")
            getInitPosts()
            self.initLocation = false
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("didChangeAuthorizationStatus")
        
        switch status {
        case .NotDetermined:
            println(".NotDetermined")
            break
            
        case .Authorized:
            println(".Authorized")
            break
            
        case .Denied:
            println(".Denied")
            break
            
        default:
            println("Unhandled authorization status")
            break
            
        }
    }
    
    
    
}