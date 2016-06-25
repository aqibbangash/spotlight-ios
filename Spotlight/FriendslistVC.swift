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

class FriendslistVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var url = "https://exchangeappreview.azurewebsites.net/Spotlight"
    @IBOutlet weak var tableView: UITableView!
    var userId:UInt!
    var dialogs:[QBChatDialog] = []
    var filterDialogs:[QBChatDialog] = []
    var curr :Int!
    var friendsList:[AnyObject] = []
    var allF:[NSDictionary]!
    var friendsString = ""
    var alert:UIAlertView!
    var allUsers:String = ""
    var connectedUserDetails:[AnyObject]?
    var recepts:[String] = []
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(false, forKey: "notification")
        userDefaults.synchronize()
        
       // getAllFriendsAzure()
    
        //getAllOnlineUsers()
        
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
                    
                    self.tableView.reloadData()
                    
                }
                
               
            }
            
        });
    
        
    
    }
    

    func ltzOffset() -> Double { return Double(NSTimeZone.localTimeZone().secondsFromGMT) }

    
    func getAllOnlineUsers()
    {
        
        
        
        alert = UIAlertView()
        alert.title = "Please wait"
        alert.message = "Looking for online users"
        //alert.show()
        
        //alertLoading.hidden = false
        
        let date = NSDate(timeIntervalSinceNow: (-300)-(ltzOffset()))
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([.Hour, .Minute, .Day, .Month,.Year], fromDate: date)
        
        var hour = "\(components.hour)"
        var minutes = "\(components.minute)"
        
        var day = "\(components.day)"
        var month = "\(components.month)"
        var year = "\(components.year)"
        
        var fil:String = ""
        
        if (hour.characters.count<2)
        {
            hour = "0\(hour)"
        }
        if (minutes.characters.count<2)
        {
            minutes = "0\(minutes)"
        }
        if (day.characters.count<2)
        {
            day = "0\(day)"
        }
        if (month.characters.count<2)
        {
            month = "0\(month)"
        }
        
        fil = ("date last_request_at gt \(year)-\(month)-\(day)T\(hour):\(minutes):00Z")
        
        print (fil)
        
        
        
        
        var filters = ["filter[]":fil]
        //onlineUsers = NSDictionary
        
        QBRequest.usersWithExtendedRequest(filters, page: QBGeneralResponsePage(currentPage: 1, perPage: 500), successBlock: { (response:QBResponse, page:QBGeneralResponsePage?, user:[QBUUser]?) -> Void in
            
            print ("***** number ofonline users: \(user!.count)")
            
            
            
            
            self.alert.title = "\(user!.count) users found online"
            self.alert.message = "Filtering for you..."
            
            self.allUsers = ""
            
            for u in user!{
                
                self.allUsers += "\(u.ID),"
                
            }
            
            
            
            let params = [ "UserID": "\(self.userId)"
                , "online": self.allUsers ]
            
            print (params);
            
            
            self.alert.dismissWithClickedButtonIndex(0, animated: true)
            
            
            self.getAllFriends()
            
            
        }) { (errorResponse) -> Void in
            
            print ("*** Response: \(errorResponse)")
            
            self.alert.dismissWithClickedButtonIndex(0, animated: true)
            self.alert = UIAlertView()
            self.alert.dismissWithClickedButtonIndex(0, animated: true)
            self.alert = UIAlertView()
            self.alert.title = "Error."
            self.alert.message = "Please try again later."
            self.alert.addButtonWithTitle("Ok")
            self.alert.show()
            
        }
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("id") {
            userId = user as! UInt
            print ("***\(userId)")
        }
        
        //getAllFriends()
        
        getAllOnlineUsers()
        
        
        
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
                self.tableView.reloadData()
                
//                print (result.items.count)
//                self.friendsList = result.items
//                
//                for x in result.items{
//                    
//                    print ("Adding this: \((x.valueForKey("friend") as! String).stringByReplacingOccurrencesOfString("\(self.userId)", withString: ""))")
//                    
//                    self.friendsString += (x.valueForKey("friend") as! String).stringByReplacingOccurrencesOfString("\(self.userId)", withString: "")
//                }
//             
//                print ("All Friends: \(self.friendsString)")
                
                
                //self.getAllDialog()
            }
            
        })
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "details")
        {
            
            
            let nav = segue.destinationViewController as! UINavigationController
            let vc = nav.topViewController as! MessageDetailsVC
            vc.recipientID = Int(recepts[curr])
            
            
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
        
        let extendedRequest = ["sort_desc" : "_id"]
        
        let page = QBResponsePage(limit: 100, skip: 0)
        
        QBRequest.dialogsForPage(page, extendedRequest: extendedRequest, successBlock: { (response: QBResponse, dialogs: [QBChatDialog]?, dialogsUsersIDs: Set<NSNumber>?, page: QBResponsePage?) -> Void in
            
            print ("Dialogs count: \(dialogs?.count)")
            
            self.dialogs = dialogs!
            
            //self.tableView.reloadData()
            
            self.filteFriendsrDialogs()
            
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
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print ("Occupants:\(filterDialogs[indexPath.row].occupantIDs)")
        print ("Name:\(filterDialogs[indexPath.row].name)")
        var recept = filterDialogs[indexPath.row].recipientID
        
        var url:String = ""
        
        var name:String = "xyz"
        
        print ("Last Message:\(filterDialogs[indexPath.row].lastMessageText)")
        var d = filterDialogs[indexPath.row].lastMessageDate
        
        
        let cell  = tableView.dequeueReusableCellWithIdentifier("messageCell") as! messageCell
        
        if (filterDialogs[indexPath.row].lastMessageText != nil){
            cell.lastMessage.text = "\(filterDialogs[indexPath.row].lastMessageText!)"
        }
        else{
            cell.lastMessage.text = "\(filterDialogs[indexPath.row].lastMessageText)"
        }
        
        
        cell.lastMessageTime.text = getTimeDifference(d!)
        
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("user-\(recept)") {
            
            cell.userImage.loadImageFromURLString(user as! String, placeholderImage: UIImage(named: "   ")) {
                (finished, error) in
                
                
            }
            
            print ("object saved for this user as: \(user as! String)")
            var a = (user as! String).componentsSeparatedByString(",")
            name = a[1]
            print ("name : \(name)")
            
        }
        
        cell.username.text = name
        
        getConnectedUserDetails("\((self.friendsList[indexPath.row].valueForKey("friend") as! String).stringByReplacingOccurrencesOfString("\(self.userId)", withString: ""))")
        
        if (self.connectedUserDetails != nil)
        {
            var aa = self.connectedUserDetails![7] as? String
            
            if (aa != nil)
            {
                cell.imageUser.imageURL(NSURL(string: self.connectedUserDetails![7] as! String)!)
            }
            else
            {
                cell.imageUser.imageURL(NSURL(string: self.connectedUserDetails![8] as! String)!)
            }
        }
        else{
            
            self.fetchUserInfro("\((self.friendsList[indexPath.row].valueForKey("friend") as! String).stringByReplacingOccurrencesOfString("\(self.userId)", withString: ""))")
        }
        
        
        
        
        
        
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    
    func getTimeDifference(t: NSDate) -> String
    {
        let currentDate = NSDate()
        
        return stringFromTimeInterval(currentDate.timeIntervalSinceDate(t))
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterDialogs.count
    }
    
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
