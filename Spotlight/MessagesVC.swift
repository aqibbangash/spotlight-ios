//
//  MessagesVC.swift
//  Spotlight
//
//  Created by Aqib on 11/03/2016.
//  Copyright © 2016 Sofit. All rights reserved.
//

import UIKit
import Quickblox
import Alamofire


class MessagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var userId:UInt!
    var dialogs:[QBChatDialog] = []
    var filterDialogs:[QBChatDialog] = []
    var curr :Int!
    var friendsList:[AnyObject] = []
    var friendsString = ""
    var alert:UIAlertView!
    var allUsers:String = ""
    var connectedUserDetails:[AnyObject]?
    var recepts:[String] = []
    @IBOutlet weak var noMessagesFound: UILabel!
    var url = "https://spotlight.azure-mobile.net/api"
    @IBOutlet weak var optionsBtnsView: UIView!
    @IBOutlet weak var const: NSLayoutConstraint!
    var allF:[NSDictionary]!
    
    
    override func viewDidAppear(animated: Bool) {
        
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(false, forKey: "notification")
        userDefaults.synchronize()
        
    }
    
    @IBAction func openMenu(sender: UIButton) {
        
        if (const.constant == -100)
        {
            openMenu()
        }
        else
        {
            closeMenu()
        }
        
    }
    
    @IBAction func openAccount(sender: UIButton) {
        
        self.performSegueWithIdentifier("toAccount", sender: self)
        closeMenu()
    }
    
    @IBAction func openFriends(sender: UIButton) {
        self.performSegueWithIdentifier("toFriends", sender: self)
        closeMenu()
    }
    
    func openMenu()
    {
        self.optionsBtnsView.fadeIn()
        const.constant = 0
    }
    
    func closeMenu()
    {
        self.optionsBtnsView.fadeOut()
        const.constant = -100
    }
    
    func fetchUserInfro(uId:String)
    {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("users")
        
        var query = MSQuery(table: itemTable)
        
        query.fetchLimit = 500;
        
        query.predicate = NSPredicate(format: "id = '\(uId)'")
        
        print ("Predicate: \(query.predicate)")
        
        query.readWithCompletion({ (result, error) -> Void in
            
            if ((error) != nil)
            {
                
                
            }
            else
            {
                
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                
                print ("Matching prefs user count: \(result.items.count)")
                
                if (result.items.count>0)
                {
                    print ("count received: \(result.items.count)")
                    
                    
                    for u in result.items{
                        
                        
                        print ("Attempting save for user")
                        
                        var details = "\(u.valueForKey("id") as! String),\(u.valueForKey("first_name") as! String),\(u.valueForKey("last_name") as! String),\(u.valueForKey("gender") as! String),\(u.valueForKey("country") as! String),\(u.valueForKey("city") as! String),\((u.valueForKey("age") as! String).stringByReplacingOccurrencesOfString(",", withString: "")),\(u.valueForKey("profile_pic") as! String),\(u.valueForKey("email") as! String),\(u.valueForKey("points") as! String),\(u.valueForKey("prefs") as! String)"
                        
                        if (u.valueForKey("vip") as? Bool != nil)
                        {
                            details += ",\(u.valueForKey("vip") as! Bool)"
                        }else
                        {
                            details += ",false"
                        }
                        print ("Saved info for user \(u.valueForKey("id") as! String)")
                        print ("DETAILS : \(details)")
                        print ("user-\(u.valueForKey("id") as! String)")
                        userDefaults.setObject(details, forKey: "user-\(u.valueForKey("id") as! String)")
                        
                    }
                    
                    userDefaults.synchronize()
                    self.getConnectedUserDetails(uId)
                    
                    
                    if (self.filterDialogs.count == 0)
                    {
                        self.noMessagesFound.hidden = false
                    }
                    else
                    {
                        self.noMessagesFound.hidden = true
                    }
                    
                    self.tableView.reloadData()
                    
                }
                else
                {
                    self.noMessagesFound.hidden = false
                }
                
                
            }
            
        });
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("id") {
            userId = user as! UInt
            print ("***\(userId)")
        }
        
        getAllFriendsAzure()
        
        
        
        
    }
    
    func filteFriendsrDialogs()
    {
        
        recepts = []
        for x in dialogs{
            
            
            var allOccupents = ""
            for xa in x.occupantIDs!
            {
                allOccupents += "\(xa)"
            }
            
            allOccupents = allOccupents.stringByReplacingOccurrencesOfString("\(self.userId)", withString: "")
            
            recepts.append(allOccupents)
            
            print ("selfID:  \(self.userId)")
            print ("final occupent:  \(allOccupents)")
            
            
            if (self.friendsString.containsString("\(allOccupents)"))
            {
                self.filterDialogs.append(x)
                print ("fr String: \(self.friendsString) CONTAINS \(x.recipientID)")
            }
            else{
                print ("fr String: \(self.friendsString) NOTCONTAINS \(x.recipientID)")
            }
            
        }
        
        
        self.tableView.reloadData()
        //getAllFriends()
    }
    
    
    func getAllFriendsAzure()
    {
        
        var params  = ["user_id": "\(self.userId)"]
        var apiCall = "\(self.url)/getFriends.php"
        
        
        print ("ApiCall: \(apiCall)")
        print ("Params: \(params)")
        
        
        Alamofire.request(.POST, apiCall, parameters: params).responseJSON { (response) in
            
            
            
            if (response.result.error == nil)
            {
                //print (response.result.value)
                var json  = response.result.value as? [NSDictionary]
                
                
                if (json != nil)
                {
                    print ("json: \(json!)")
                    self.allF = json!
                    
                    self.tableView.reloadData()
                    
                    for c in json!{
                        
                        self.friendsString += "\(c.valueForKey("id") as! String),"
                    }
                    
                    self.getAllDialog()
                    
                }
                
                
                
                
                //let status =  json?.valueForKey("status") as! Int
                
                
            }
            
        }
    }
    
    func getAllFriends()
    {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("Friends")
        
        var query = MSQuery(table: itemTable)
        
        query.fetchLimit = 500;
        
        query.predicate = NSPredicate(format: "friend contains[c] '\(self.userId)'")
        
        print ("Predicate: \(query.predicate)")
        
        query.readWithCompletion({ (result, error) -> Void in
            
            if ((error) != nil)
            {
                print (error.localizedDescription)
            }
            else
            {
                print (result.items.count)
                self.friendsList = result.items
                
                for x in result.items{
                    
                    print ("Adding this: \((x.valueForKey("friend") as! String).stringByReplacingOccurrencesOfString("\(self.userId)", withString: ""))")
                    
                    self.friendsString += (x.valueForKey("friend") as! String).stringByReplacingOccurrencesOfString("\(self.userId)", withString: "")
                }
                
                print ("All Friends: \(self.friendsString)")
                
                self.getAllDialog()
            }
            
        })
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "details")
        {
            
            var json = getFriendInfo("\(filterDialogs[curr].recipientID)")
            
            let nav = segue.destinationViewController as! UINavigationController
            let vc = nav.topViewController as! MessageDetailsVC
            vc.json = json
            vc.connectionFrom = "Messages"
            vc.showAdd = false
            vc.personNumber = 1
            
            if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("profile_pic") {
                
                vc.myImage = user as! String
                //print ("***\(userPassword)")
                
            }
            
            
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        curr = indexPath.row
        
        self.performSegueWithIdentifier("details", sender: self)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func getAllDialog()
    {
        
        print ("Requesting all dialogs...")
        
        let extendedRequest = [self.friendsString : "_id[in]"]
        
        let page = QBResponsePage(limit: 100, skip: 0)
        
        QBRequest.dialogsForPage(page, extendedRequest: extendedRequest, successBlock: { (response: QBResponse, dialogs: [QBChatDialog]?, dialogsUsersIDs: Set<NSNumber>?, page: QBResponsePage?) -> Void in
            
            print ("Dialogs count: \(dialogs?.count)")
            
            self.dialogs = dialogs!
            
            self.filterDialogs = dialogs!
            
            if (self.filterDialogs.count < 1)
            {
                self.noMessagesFound.hidden = false
            }else{
                self.noMessagesFound.hidden = true
            }
            
            self.tableView.reloadData()
            
            //self.filteFriendsrDialogs()
            
        }) { (response: QBResponse) -> Void in
            
            print("Error Response: \(response)")
            
        }
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        
        if (hours > 24 )
        {
            return ("\(Int(hours/24)) days")
        }
        else if (hours > 0 )
        {
            return ("\(Int(hours)) hours")
        }
        else if (minutes > 0 )
        {
            return ("\(Int(minutes)) min")
        }else if (seconds > 0 )
        {
            return ("\(Int(seconds)) sec")
        }
        else
        {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
    
    
    func getConnectedUserDetails(recept:String){
        
        var u:String = ""
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("user-\(recept)") {
            
            u = user as! String
            
            print ("object retreived as: \(u as! String)")
            var a = (user as! String).componentsSeparatedByString(",")
            
            connectedUserDetails = a
            
            print ("connected: \(a)")
            
            
        }
        else{
            print ("***Details for this user not found: user-\(recept)")
            
        }
        
    }
    
    func getFriendInfo(s:String) -> NSDictionary
    {
        var abc = NSDictionary()
        for x in allF{
            
            if (x.valueForKey("id") as! String == s)
            {
                abc = x
                return abc
            }
            
        }
        
        return abc
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var unreadCount = filterDialogs[indexPath.row].unreadMessagesCount
        
        var recept = filterDialogs[indexPath.row].recipientID
        
        
        var d = filterDialogs[indexPath.row].lastMessageDate
        
        
        let cell  = tableView.dequeueReusableCellWithIdentifier("messageCell") as! messageCell
        
        var text = "empty"
        
        if (filterDialogs[indexPath.row].lastMessageText != nil){
            text = filterDialogs[indexPath.row].lastMessageText!
        }else
        {
            
        }
        
        cell.lastMessage.text = text
        if (unreadCount > 0)
        {
            cell.lastMessage.text = "\(cell.lastMessage.text!) - \(unreadCount) Unread"
        }
        
        
        cell.lastMessageTime.text = getTimeDifference(d)
        
        if (getFriendInfo("\(recept)").valueForKey("full_name") as? String == nil)
        {
            self.filterDialogs.removeAtIndex(indexPath.row)
            
            
            if (self.filterDialogs.count < 1)
            {
                self.noMessagesFound.hidden = false
            }else{
                self.noMessagesFound.hidden = true
            }
            
            self.tableView.reloadData()
        }
        else
        {
            cell.imageUser.imageURL(NSURL(string: getFriendInfo("\(recept)").valueForKey("profile_pic") as! String)!)
            
            cell.username.text = getFriendInfo("\(recept)").valueForKey("full_name") as! String
        }
        
        
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    
    func getTimeDifference(t: NSDate?) -> String
    {
        let currentDate = NSDate()
        
        if (t != nil)
        {
            return stringFromTimeInterval(currentDate.timeIntervalSinceDate(t!))
        }
        else{
            return ""
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return filterDialogs.count
    }
    
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
