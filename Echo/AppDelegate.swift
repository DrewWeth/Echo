//
//  AppDelegate.swift
//  Echo
//
//  Created by AGW on 12/21/14.
//  Copyright (c) 2014 Andrew Wetherington. All rights reserved.
//

import UIKit
import Parse



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var coreLocationController:CoreLocationController?
    var service:PostService!
    var device:Device!
    var masterController:MasterViewController!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.coreLocationController = CoreLocationController()
        self.service = PostService()
        
        
        // Register parse
        Parse.setApplicationId("Q5N1wgUAJKrEbspM7Q2PBv32JbTPt5TQpmstic8D", clientKey: "rUpIZ6rJl3FMe69GqIxNnTK6mMSUlx0AA2OPAej8")
        var types: UIUserNotificationType = UIUserNotificationType.Badge & UIUserNotificationType.Alert & UIUserNotificationType.Sound
        var settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        
//        self.device = Device()
        self.device = Device(device_token_from_parse: PFInstallation.currentInstallation().objectId)
        println("device count \(self.device.data.count)")

        
        
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as UINavigationController
        navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
        
        
        let credProvider = AWSStaticCredentialsProvider(accessKey: "AKIAITTQESDYY4J5QC5A", secretKey:"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")
        let defaultServiceConfig = AWSServiceConfiguration(region: AWSRegionType.USWest2, credentialsProvider: credProvider)
        AWSServiceManager.defaultServiceManager().setDefaultServiceConfiguration(defaultServiceConfig)
        
//        let dDB = AWSDynamoDB.defaultDynamoDB()
//        let list = AWSDynamoDBListTablesInput()
//        dDB.listTables(list).continueWithBlock({
//            (task: BFTask!) -> AnyObject! in
//            let listOutput = task.result as AWSDynamoDBListTablesOutput
//            println("printing table names")
//            for tableName : AnyObject in listOutput.tableNames{
//                println("\(tableName)")
//            }
//            return nil
//            
//        })
        
        return true
    }

    func application(application:UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken:NSData) {
    
        // Store the deviceToken in the current installation and save it to Parse.
        var currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        println("Device token for parse: \(currentInstallation.deviceToken)")
        currentInstallation.saveInBackgroundWithBlock{
        (succ, error) in
            if (!succ){
                println("Got currentInstallation error bro")
                println(error)
            }
            
        }
    }
    
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    func application(application:UIApplication, didReceiveRemoteNotification userInfo:NSDictionary){
            PFPush.handlePush(userInfo)
    }
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("DELEGATE: failed to register for remote notifications:  (error)")
        println(error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println("didReceiveRemoteNotification")
        PFPush.handlePush(userInfo)
    }
    
    func application(application: UIApplication!, didReceiveRemoteNotification userInfo: NSDictionary!){
        PFPush.handlePush(userInfo)
    }
    
    
    func getLocationController() -> CoreLocationController{
        return self.coreLocationController!
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
            if let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController {
                if topAsDetailController.detailItem == nil {
                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
                    return true
                }
            }
        }
        return false
    }

}

