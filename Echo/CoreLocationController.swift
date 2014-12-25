//
//  CoreLocationController.swift
//  Echo
//
//  Created by AGW on 12/23/14.
//  Copyright (c) 2014 Andrew Wetherington. All rights reserved.
//

import Foundation
import CoreLocation

class CoreLocationController : NSObject, CLLocationManagerDelegate{
    var locationManager:CLLocationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D!
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.distanceFilter  = 1000 // Must move at least 3km
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation() // why wont this work
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