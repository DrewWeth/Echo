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

    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    var is_loading = false
    var endOfFeed = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }


    override func viewDidLoad() {

        super.viewDidLoad()

        appDelegate.masterController = self
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
        
        
        self.refreshControl?.tintColor = UIColor.whiteColor()
        
        var rc = UIRefreshControl()
        refreshControl?.addTarget(self, action: Selector("refreshTable"), forControlEvents: UIControlEvents.ValueChanged)
        var attr = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        rc.attributedTitle = NSAttributedString(string: "Finding nearby Echoes...", attributes:attr)
        
        self.refreshControl = refreshControl
        
    }
    
    func submitTransition(Sender: UIButton!) {
        let submitView:SubmitViewController = SubmitViewController()
        self.presentViewController(submitView, animated: true, completion: nil)
    }
    
    func addPost(post:Post) {
        self.postsCollection.insert(post, atIndex:0)
    }

    
    override func scrollViewDidScroll(scroll:UIScrollView){
        
        // UITableView only moves in one direction, y axis
        var currentOffset = scroll.contentOffset.y;
        var maximumOffset = scroll.contentSize.height - scroll.frame.size.height;
        
        //println("\(currentOffset), \(maximumOffset), \(maximumOffset - currentOffset)")
        
        // Change 10.0 to adjust the distance from bottom
        if (maximumOffset > UIScreen.mainScreen().bounds.height && maximumOffset - currentOffset < 200.0 && !endOfFeed) {
            println("Has scrolled far enough to load more posts")
            
            if (self.is_loading == false)
            {
                self.is_loading = true
                if (appDelegate.getLocationController().currentLocation != nil)
                {
                    self.appDelegate.service.getPosts ({
                        (response) in
                        self.loadPosts(response as NSArray)
                        }, latitude: appDelegate.getLocationController().getCurrentLatitude(), longitude: appDelegate.getLocationController().getCurrentLongitude(), last: self.postsCollection.last!.created)
                }
            }
        }
        
    }
    
    func refreshTable(){

        if (appDelegate.getLocationController().currentLocation != nil)
        {
            
            //         return of the closure-- idk wtf that means tho
            var first_string = ""
            if (self.postsCollection.count > 0){
                first_string = self.postsCollection[0].created
            }
            self.appDelegate.service.getPosts ({
                (response) in
                self.loadPosts(response as NSArray, insertToBeginning: true)
                }, latitude: appDelegate.getLocationController().getCurrentLatitude(), longitude: appDelegate.getLocationController().getCurrentLongitude(), last:first_string)
        }
        else
        {
            var error = Post(id:0, content:"GPS isn't working :(", ups:0, downs:0, views:0,  created:"2014-12-23T22:53:20.963Z", profile_url:"")
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
    func loadPosts(posts:NSArray, insertToBeginning:Bool = false){
        println("Number of returned posts: \(posts.count)")
        if (posts.count == 0){
            endOfFeed = true
        }
        
        if (posts.count > 0){
            for postObj in posts{
                println(postObj)
                var post = postObj["post"] as NSDictionary
                var id = post["id"] as Int
                var content = post["content"] as String
                var ups = post["ups"] as Int
                var downs = post["downs"] as Int
                var views = post["views"] as Int
                var created = post["created_at"] as String
                var profile_url = postObj["profile_picture"] as String
                
                var postObj = Post(id: id, content: content, ups:ups, downs:downs, views:views, created:created, profile_url:profile_url)
                
                if (!insertToBeginning){
                    postsCollection.append(postObj)
                }
                else{
                    postsCollection.insert(postObj, atIndex: 0)
                }
            }
        }
        
        // we could be inside a closure, possible to not be in main thread.
        dispatch_async(dispatch_get_main_queue()){
            self.tableView.reloadData()
            self.is_loading = false
        }
    }
    
    
    
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Cell" {
            
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
        
        let cell:PostCell = tableView.dequeueReusableCellWithIdentifier("Cell") as PostCell
        let post = postsCollection[indexPath.row]
        println("Cell: \(post.content)")
        
        cell.setCell(post.content, ups:post.ups, downs:post.downs, rating:post.views, image:post.image)
        
        // Button tags
        cell.upvote.tag = indexPath.row as Int
        cell.downvote.tag = indexPath.row as Int
        

        

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
    
    
    @IBAction func upvote(sender: AnyObject) {
        
        self.appDelegate.service.submitVote({
            (response) in
            self.addNew(response as NSDictionary)
            }, voteType: 1, postID: self.postsCollection[sender.tag].id)
    
        
        self.postsCollection[sender.tag].ups += 1
        var paths = NSIndexPath(forRow:sender.tag, inSection: 0)
        self.tableView.reloadRowsAtIndexPaths([paths], withRowAnimation: .Fade)
    }
    
    @IBAction func downvote(sender: AnyObject) {
        
        self.appDelegate.service.submitVote({
            (response) in
            self.addNew(response as NSDictionary)
            }, voteType: 2, postID: self.postsCollection[sender.tag].id)
        
        
        self.postsCollection[sender.tag].downs += 1
        var paths = NSIndexPath(forRow:sender.tag, inSection: 0)
        self.tableView.reloadRowsAtIndexPaths([paths], withRowAnimation: .Fade)
    }


}

