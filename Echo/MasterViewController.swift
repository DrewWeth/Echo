//
//  MasterViewController.swift
//  Echo
//
//  Created by AGW on 12/21/14.
//  Copyright (c) 2014 Andrew Wetherington. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var postsCollection = [Post]()

    var service:PostService!
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var is_loading = false

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var bgView = UIImageView(image: UIImage(named:"background.jpg"))
        bgView.contentMode = .ScaleAspectFill
        
        var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        visualEffectView.frame = bgView.bounds
        
        bgView.addSubview(visualEffectView)
        bgView.sendSubviewToBack(visualEffectView)
        
        tableView.backgroundView = bgView
        tableView.backgroundView?.layer.zPosition = -1
        
        // Do any additional setup after loading the view, typically from a nib.
        // self.navigationItem.leftBarButtonItem = self.editButtonItem()

        
        // For ipad stuff i think when 2 controller are layered
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        
        service = PostService()
        // return of the closure-- idk wtf that means tho
        println("Getting posts")
        service.getPosts ({
            (response) in
            self.loadPosts(response as NSArray)
            }, latitude: "37.5016981", longitude: "-91.3991102", last:"2014-12-23T22:53:20.963Z")
        
        self.refreshControl?.tintColor = UIColor.whiteColor()
        
        var rc = UIRefreshControl()
        refreshControl?.addTarget(self, action: Selector("refreshTable"), forControlEvents: UIControlEvents.ValueChanged)
        var attr = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        rc.attributedTitle = NSAttributedString(string: "Finding nearby Echoes...", attributes:attr)
        
        self.refreshControl = refreshControl
        
//        self.postsCollection = [Post(id:1, content:"Just saw the cutest shoes ever", ups:2, downs:1, views: 10, created:"Dec 22, 2014 at 2:15AM"),Post(id:1, content:"Becky is a bitchhh :S", ups:72, downs:4, views: 126, created:"Dec 22, 2014 at 1:15AM"),Post(id:1, content:"Sports are cool kcjls ns dc  jc sj,hbdjn sbdjhbs", ups:304378, downs:-1, views: 304378, created:"Dec 22, 2014 at 2:15AM"),Post(id:1, content:"Music heals <3", ups:440, downs:46, views: 1046, created:"Dec 22, 2014 at 2:15AM")]
    }
    
    @IBAction func addName(sender: AnyObject) {
        
        var alert = UIAlertController(title: "Echo",
            message: "Post your Echo!",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Publish",
            style: .Default) { (action: UIAlertAction!) -> Void in
                
            let textField = alert.textFields![0] as UITextField
            
            if (textField.text != ""){
                
                
                // makes local copy -- just for nice-ity
                var postObj = Post(id: 0, content: textField.text, ups:0, downs:0, views:0, created:"2014-12-23T22:53:20.963Z")
                
                // Submits post to apii
                
                
                
                if (self.appDelegate.getLocationController().currentLocation != nil)
                {
                
                    self.service.submitPost({
                        (response) in
                        self.addNew(response as NSDictionary)
                        }, content:textField.text, latitude: self.appDelegate.getLocationController().getCurrentLatitude(), longitude: self.appDelegate.getLocationController().getCurrentLongitude())
                    
                    self.postsCollection.insert(postObj, atIndex:0)
                    self.tableView.reloadData()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Back",
            style: .Cancel) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
        
    }
    
    override func scrollViewDidScroll(scroll:UIScrollView){
        
        // UITableView only moves in one direction, y axis
        var currentOffset = scroll.contentOffset.y;
        var maximumOffset = scroll.contentSize.height - scroll.frame.size.height;
        
        //println("\(currentOffset), \(maximumOffset), \(maximumOffset - currentOffset)")
        
        // Change 10.0 to adjust the distance from bottom
        if (maximumOffset > 0 && maximumOffset - currentOffset == 0.0) {
        
            if (appDelegate.getLocationController().currentLocation != nil)
            {
                println("Load more stuff here...")
                
                self.service.getPosts ({
                    (response) in
                    self.loadPosts(response as NSArray)
                    }, latitude: appDelegate.getLocationController().getCurrentLatitude(), longitude: appDelegate.getLocationController().getCurrentLongitude(), last: self.postsCollection.last!.created)
            }
        }
        
    }
    
    func refreshTable(){
        self.postsCollection = [] // Reset table

        if (appDelegate.getLocationController().currentLocation != nil)
        {
            
            //         return of the closure-- idk wtf that means tho
            var last_string = ""
            if (self.postsCollection.last != nil){
                last_string = self.postsCollection.last!.created
            }
            self.service.getPosts ({
                (response) in
                self.loadPosts(response as NSArray)
                }, latitude: appDelegate.getLocationController().getCurrentLatitude(), longitude: appDelegate.getLocationController().getCurrentLongitude(), last:last_string)
        }
        else
        {
            var error = Post(id:0, content:"GPS isn't working :(", ups:0, downs:0, views:0,  created:"2014-12-23T22:53:20.963Z")
            self.postsCollection.append(error)
        }
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func addNew(post:NSDictionary)
    {
        println(post)
        
    }
    
    
    // Takes an array of posts, makes objects of them, and appends them to postsCollections. Then reloads the data table.
    func loadPosts(posts:NSArray){
        println("Number of posts: \(posts.count)")
        if (posts.count > 0){
            
            for post in posts{
                var id = post["id"] as Int
                var content = post["content"] as String
                var ups = post["ups"] as Int
                var downs = post["downs"] as Int
                var views = post["views"] as Int
                var created = post["created_at"] as String
                var postObj = Post(id: id, content: content, ups:ups, downs:downs, views:views, created:created)
                postsCollection.append(postObj)
            }
            
            // we could be inside a closure, possible to not be in main thread.
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
            }
        }
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = postsCollection[indexPath.row]
                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsCollection.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let post = postsCollection[indexPath.row]
        cell.textLabel.text = post.content
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            postsCollection.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

