//
//  VideoChatVC.swift
//  Spotlight
//
//  Created by Aqib on 23/02/2016.
//  Copyright © 2016 Sofit. All rights reserved.
//

import UIKit
import Quickblox


class VideoChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, QBRTCClientDelegate

{

    
    var chatDialog: [QBChatDialog] = []
    var userEmail:String!
    var userPassword:String!
    var userId:UInt!
    var i:Int!

    
    @IBOutlet weak var id: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connectButton(sender: UIButton) {
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("videoCells")! as UITableViewCell
        
        return cell
        
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
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.i  = indexPath.row
        self.performSegueWithIdentifier("toDialogInfo", sender: self)
        
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
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
        
    }

}
