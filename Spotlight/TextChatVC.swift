//
//  TextChatVC.swift
//  Spotlight
//
//  Created by Aqib on 13/02/2016.
//  Copyright © 2016 Sofit. All rights reserved.
//

import UIKit
import Quickblox
import Alamofire

class TextChatVC: UIViewController, QBChatDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    var currentUserNumber  = 0;
    @IBOutlet weak var user_id: UITextField!
    var chatDialog: [QBChatDialog] = []
    var userEmail:String!
    var userPassword:String!
    var userId:UInt!
    var i:Int!
    var cur:Int!
    var onlineUsers:[NSDictionary] = []
    var filteredUsers:[String] = []
    let alert = UIAlertView()
    var url = "https://exchangeappreview.azurewebsites.net/"
    var dialog:QBChatDialog!
    var requestId:String!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func connectToUser(sender: UIButton) {
        
        createDialogForUser(UInt(user_id.text!)!)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if (segue.identifier == "toDialogInfo")
        {
            
            let vc = segue.destinationViewController as! DialogInfoVC
            vc.chatDialog = self.chatDialog[i]
            print ("**curr: \(self.chatDialog[i].name)")
            print ("**curr: \(vc.chatDialog.name)")
            
        }
        
        if (segue.identifier == "toDialogInfoAuto")
        {
            
            let vc = segue.destinationViewController as! DialogInfoVC
            vc.chatDialog = dialog
            
        }
        
        
        
    }
    
    func ltzOffset() -> Double { return Double(NSTimeZone.localTimeZone().secondsFromGMT) }
    
    func getAllOnlineUsers()
    {
        
        alert.title = "Please wait"
        alert.message = "Looking for online users"
        alert.show()
        
        let date = NSDate(timeIntervalSinceNow: (-60)-(ltzOffset()))
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
        
        QBRequest.usersWithExtendedRequest(filters, page: QBGeneralResponsePage(currentPage: 1, perPage: 100), successBlock: { (response:QBResponse, page:QBGeneralResponsePage?, user:[QBUUser]?) -> Void in
            
            print ("***** number ofonline users: \(user!.count)")
            
            
            
            self.alert.title = "\(user!.count) users found"
            self.alert.message = "Filtering for you..."
            
            var allUsers = ""
            
            for u in user!{
                
                allUsers += "\(u.ID),"
            }
            
            let params = [ "UserID": "\(self.userId)"
                , "online": allUsers ]
            
            print (params);
            
            
            Alamofire.request(.POST, "\(self.url)matchSpecifictions.php", parameters: params).responseJSON {
                response in
                
                print(response)
                
                let json  = response.result.value as? NSDictionary
                
                if (response.result.isSuccess)
                {
                    self.alert.dismissWithClickedButtonIndex(0, animated: true)
                    
                    self.filteredUsers = json!.valueForKey("data") as! [String]
                    
                    print ("Online Users per prefs: \(self.filteredUsers.count)")
                    
                    self.startCreatingDialogs()
                    
                }
                
                //print ("**Response: \(json)")
                
            }
            
            
            }) { (errorResponse) -> Void in
                
                print ("*** Response: \(errorResponse)")
                
        }
        
    }
    
    func startCreatingDialogs()
    {
        createDialogForUserAuto(UInt(self.filteredUsers[currentUserNumber])!)
    }
    
    func createDialogForUser(uid:UInt){
        
        let chatDialog = QBChatDialog(dialogID: nil, type: QBChatDialogType.Private)
        chatDialog.name = "Chat Dialog"
        chatDialog.occupantIDs = [uid]
        
        QBRequest.createDialog(chatDialog, successBlock: { (response: QBResponse?, createdDialog : QBChatDialog?) -> Void in
            
            print("***Response: \(createdDialog?.ID)")
            self.getAllDialogs()
            
            self.tableView.reloadData()
            
            }) { (responce : QBResponse!) -> Void in
                print("***Error: \(responce)")
                
        }
        
    }
    
    func createDialogForUserAuto(uid:UInt){
        
        let chatDialog = QBChatDialog(dialogID: nil, type: QBChatDialogType.Private)
        chatDialog.name = "Chat Dialog"
        chatDialog.occupantIDs = [uid]
        
        QBRequest.createDialog(chatDialog, successBlock: { (response: QBResponse?, createdDialog : QBChatDialog?) -> Void in
            
            print("***Response: \(createdDialog?.ID)")
            
            self.dialog = createdDialog!
            
            self.performSegueWithIdentifier("toDialogInfoAuto", sender: self)
            
            
            
            }) { (responce : QBResponse!) -> Void in
                print("***Error: \(responce)")
                
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("chatDialog")! as! CellController
        
        cell.label.text = chatDialog[indexPath.row].name
        
        cell.deleteButton.addTarget(self, action: "shareButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.deleteButton.tag = indexPath.row
        
        return cell
    }
    
    
    func shareButtonAction(sender:UIButton!)
    {
        
        var num:Int = sender.tag as! Int
        cur = num
        deleteDialog(chatDialog[num].ID!)
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.i  = indexPath.row
        self.performSegueWithIdentifier("toDialogInfo", sender: self)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatDialog.count
    }
    
    func chatDidReceiveSystemMessage(message: QBChatMessage!) {
        
        print ("Message Received: \(message.text)")
    }
    
    func getUserDetails()
    {
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("email") {
            userEmail = user as!String
            print ("***\(userEmail)")
        }
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("password") {
            userPassword = user as!String
            print ("***\(userPassword)")
        }
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("id") {
            userId = user as! UInt
            print ("***\(userId)")
        }
        
        
    }
    
    func deleteDialog(id:String)
    {
        
        QBRequest.deleteDialogsWithIDs([id], forAllUsers: true, successBlock: { (response, St, st, st3) -> Void in
            
            
            self.chatDialog.removeAtIndex(self.cur)
            self.tableView.reloadData()
            
            
            }) { (error) -> Void in
                
                print ("***Error")
        }
        
    }
    
    func getAllDialogs()
    {
        let extendedRequest = ["sort_desc" : "_id"]
        
        let page = QBResponsePage(limit: 100, skip: 0)
        
        QBRequest.dialogsForPage(page, extendedRequest: extendedRequest, successBlock: { (response: QBResponse, dialogs: [QBChatDialog]?, dialogsUsersIDs: Set<NSNumber>?, page: QBResponsePage?) -> Void in
            
            self.chatDialog = dialogs!
            self.tableView.reloadData()
            
            }) { (response: QBResponse) -> Void in
                
                print ("Error Found")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getAllOnlineUsers()
        
        //getAllDialogs()
        
        //QBChat.instance().addDelegate(self)
        
        //getUserDetails()
        
        //findUserCreateDialog(10168239)
        
    }
    
    //    func findUserCreateDialog(userId:Int)
    //    {
    //        let chatDialog = QBChatDialog(dialogID: nil, type: QBChatDialogType.Group)
    //        chatDialog.name = "One on One Chat"
    //        chatDialog.occupantIDs = [userId]
    //        
    //        QBRequest.createDialog(chatDialog, successBlock: { (response: QBResponse?, createdDialog : QBChatDialog?) -> Void in
    //            
    //            print("***Response: \(createdDialog?.ID)")
    //            self.chatDialog = createdDialog
    //            
    //            
    //            
    //            
    //            let user = QBUUser()
    //            user.ID = self.userId
    //            user.password = "aqibbangash"
    //            
    //           
    //            
    //            QBChat.instance().connectWithUser(user, completion: { (error) -> Void in
    //            
    //                if (error == nil){
    //                    print ("connected")
    //                    self.sendButton.enabled = true                }
    //                else
    //                {
    //                    print ("not connected: \(error!.localizedDescription)")
    //                }
    //                
    //            })
    //            
    //
    //            }) { (responce : QBResponse!) -> Void in
    //                print("***Error(Guess): \(responce)")
    //
    //        }
    //    }
    
    @IBOutlet weak var sendButton: UIButton!
    
    
    func chatDidNotConnectWithError(error: NSError?) {
        print ("***error in connections: \(error?.localizedDescription)")
    }
    
    
    func chatDidReceiveMessage(message: QBChatMessage!) {
        
        print ("Message Received: \(message)")
        
    }
    
    //    @IBAction func sendMessage(sender: UIButton) {
    //        
    //        let message: QBChatMessage = QBChatMessage()
    //        message.text = messageField.text
    //        
    //        let params : NSMutableDictionary = NSMutableDictionary()
    //        params["save_to_history"] = true
    //        message.customParameters = params
    //        
    //        chatDialog.sendMessage(message, completionBlock: { (error: NSError?) -> Void in
    //            
    //                if (error == nil)
    //                {
    //                    print("***message sent")
    //                }else
    //                {
    //                    print("***message NOT sent: \(error?.localizedDescription)")
    //                }
    //            
    //            })
    //        
    //        
    //    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
