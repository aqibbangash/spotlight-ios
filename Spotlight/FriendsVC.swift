//
//  FriendsVC.swift
//  Spotlight
//
//  Created by Aqib on 09/03/2016.
//  Copyright © 2016 Sofit. All rights reserved.
//

import Quickblox
import UIKit
import Alamofire

class FriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var const: NSLayoutConstraint!
    var friendsList:[AnyObject] = []
    @IBOutlet weak var tableView: UITableView!
    var userId:UInt!
    var url = "https://spotlight.azure-mobile.net/api"
    var allF:[NSDictionary] = []
    var gender:String!
    var userPassword:String!
    var myName:String = ""
    var alert:UIAlertView!
    var allUsers:String = ""
     var connectedUserDetails:[AnyObject]!
    var curr:Int!
    @IBOutlet weak var noFriendsFound: UILabel!
    
    @IBOutlet weak var optionsBtnView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserDetails()
        
        getAllFriendsAzure()
        
        //getAllOnlineUsers()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openMessages(sender: UIButton) {
        
        self.performSegueWithIdentifier("toMessages", sender: self)
        closeDrawer()
    }
    
    @IBAction func openFriends(sender: UIButton) {
        self.performSegueWithIdentifier("toAccount", sender: self)
        closeDrawer()
    }
    
    @IBAction func toggleDrawer(sender: UIButton) {
    
        if (const.constant == -100)
        {
            
            openDrawer()
        }
        else{
            closeDrawer()
        }
    }
    
    
    func openDrawer()
    {
        self.optionsBtnView.fadeIn()
        self.const.constant = 0
    }
    
    func closeDrawer()
    {
        self.optionsBtnView.fadeOut()
        self.const.constant = -100
    }
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "details")
        {
            
            

            
//            var recept = (self.friendsList[curr].valueForKey("friend") as! String).stringByReplacingOccurrencesOfString("\(self.userId)", withString: "")
//            print ("recept!")
//            
            let nav = segue.destinationViewController as! UINavigationController
            let vc = nav.topViewController as! MessageDetailsVC
            vc.json = self.allF[self.curr]
            vc.connectionFrom = "Messages"
            vc.showAdd = false
            
            if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("profile_pic") {
                
               vc.myImage = user as! String
                //print ("***\(userPassword)")
                
            }
            
            //vc.recipientID = Int(recept)
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        curr = indexPath.row
        
        self.performSegueWithIdentifier("details", sender: self)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //        return UITableViewCell()
        
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell") as! friendCell
        
        cell.statusColor.layer.cornerRadius = cell.statusColor.frame.width/2
        
//        var senderid = self.friendsList[indexPath.row].valueForKey("sentby") as! String
//        
//        var f_name  = ""
//        
//        if (senderid == "\(userId)"){
//            
//            f_name = self.friendsList[indexPath.row].valueForKey("receivername") as! String
//            
//        }
//        else
//        {
//            f_name = self.friendsList[indexPath.row].valueForKey("sendername") as! String
//        }
//        
//        
//        
//        
//        print ("data: \(self.friendsList[indexPath.row])")
//        
        cell.name.text = "\(allF[indexPath.row].valueForKey("full_name") as! String)"
        
//        print ("allOnlineUsers: \(self.allUsers)")
//        print ("myId: \(self.userId)")
//        print ("both: \(self.friendsList[indexPath.row].valueForKey("friend") as! String)")
//        print ("friend: \((self.friendsList[indexPath.row].valueForKey("friend") as! String).stringByReplacingOccurrencesOfString("\(self.userId)", withString: ""))")
//        
//        var f = "\(((self.friendsList[indexPath.row].valueForKey("friend") as! String).stringByReplacingOccurrencesOfString("\(self.userId)", withString: "")))"
//        
//        
//        if (self.allUsers.rangeOfString(f) != nil)
//        {
//            cell.status.text = "Online"
//            cell.statusColor.backgroundColor = UIColor.greenColor()
//        }
//        else
//        {
//            cell.status.text = "Offline"
//            cell.statusColor.backgroundColor = UIColor.redColor()
//        }
//        
        if ((allF[indexPath.row].valueForKey("online_status") as! String) == "online")
        {
            cell.status.text = "Online"
            cell.statusColor.backgroundColor = UIColor.greenColor()
        }else
        {
            cell.status.text = "Offline"
            cell.statusColor.backgroundColor = UIColor.redColor()
        }
        
        
        cell.imageUser.imageURL(NSURL(string: allF[indexPath.row].valueForKey("profile_pic") as! String)!)
        
        //print ("\(self.connectedUserDetails[7] as! String)")
        
        return cell
        
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
                    
                    if (self.allF.count > 0)
                    {
                        self.noFriendsFound.hidden = true
                    }
                    else
                    {
                        self.noFriendsFound.hidden = false
                    }
                    
                    self.tableView.reloadData()
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
                
                if (result.items.count == 0)
                {
                    self.noFriendsFound.hidden = false
                }
                else{
                    self.noFriendsFound.hidden = true
                }
                
                self.tableView.reloadData()
            }
            
        })
        
    }
    
    func ltzOffset() -> Double { return Double(NSTimeZone.localTimeZone().secondsFromGMT) }

    
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
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allF.count
    }
    
    func getUserDetails()
    {
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("password") {
            userPassword = user as!String
            print ("***\(userPassword)")
        }
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("id") {
            userId = user as! UInt
            print ("***\(userId)")
        }
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("gender") {
            gender = user as! String
            print ("***\(gender)")
        }
        
        
        
    }
    
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
