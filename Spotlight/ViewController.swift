//
//  ViewController.swift
//  Spotlight
//
//  Created by Aqib on 12/02/2016.
//  Copyright © 2016 Sofit. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Quickblox
import VideoBackgroundViewController
import GTToast
import Parse
import Alamofire



class ViewController: VideoBackgroundViewController {
    
    @IBOutlet weak var loading: LoopingVideoView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var loadingGif: UIImageView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var rememberDetails: UISwitch!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var mySwitch: UISwitch!
   // @IBOutlet weak var loginButton: FBSDKLoginButton!
    var userId:String!
    var currentUser:[AnyObject]!
    
    @IBOutlet weak var loopingVideo: LoopingVideoView!
    
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
        print("Unwind Fired...")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "toHome")
        {
            let nav = segue.destinationViewController as! UINavigationController
            let vc = nav.topViewController as! HomeVC
            vc.userId = self.userId
            vc.currentUser = self.currentUser
        }
        
    }
    @IBAction func switchChanged(sender: UISwitch) {
        
        
    }
    
    func checkLoginStatus()
    {
        
        
        self.checkButton.setImage(UIImage(named: "checked"), forState: .Selected)
            
            
        self.checkButton.setImage(UIImage(named: "unchecked"), forState: .Normal)
                
                
        
        
        if let login: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("login_status") {
            
            if (login as! Bool)
            {
                //self.performSegueWithIdentifier("toHome", sender: self)
                
                self.checkButton.tag = 1
                //self.checkButton.selected = true
                
                self.checkButton.selected = true
                self.rememberDetails.setOn(login as! Bool, animated: true)
                print ("***Logged In")
                
                if let login: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("user") {
                    username.text = login as! String
                }
                
                if let login: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("pass") {
                    password.text = login as! String
                }
                
                //signInWithUsernamePassword(UIButton())
                
            }else
            {
                
                
                self.checkButton.selected = false
                self.rememberDetails.setOn(login as! Bool, animated: true)
                self.checkButton.tag = 0
                print ("***Not Logged In")
            }
        }
        else
        {
            print("login not saved!")
        }
        
        
    }
    
    
    
    @IBAction func forgotPassword(sender: UIButton) {
        
        self.view.endEditing(true)
        
        if (username.text == nil)
        {
            self.status.text = "Enter Email first"
            self.status.hidden = false
        } else if (username.text!.characters.count < 1 )
        {
            
            self.status.text = "Enter Email first"
            self.status.hidden = false
        } else
        {
            var aa = GTToast.create("Attempting Forgot Password Request")
            aa.show()
            forgotPasswordAttemp(aa)
        }
        
        
    }
    
    
    func scheduleLocal(sender: AnyObject) {
        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if settings!.types == .None {
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
        notification.alertBody = "Hey you! Yeah you! Swipe to unlock!"
        notification.alertAction = "be awesome!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["CustomField1": "w00t"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    
    @IBAction func signInWithUsernamePassword(sender: UIButton) {
        
        var usern = username.text
        var pass = password.text
        
        self.status.text = ""
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setObject(usern, forKey: "user")
        userDefaults.setObject(pass, forKey: "pass")
        
        var alert = UIAlertView()
        alert.title = "Please wait..."
        alert.message = "Logging in"
        //alert.show()
        
        
        self.loadingView.hidden = false
        
        
        
        
        QBRequest.logInWithUserEmail(usern!, password: pass!, successBlock: {(response:QBResponse!, user:QBUUser?) -> Void in
            //success goes here
            
            
            print ("***Succeeded: \(user!)")
            
            let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
            let remoteTypes: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
            
            let notificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
            
            //self.scheduleLocal("Sreing")
            
            
            print ("***results: \((user!.valueForKey("ID") as! Int))")
            
            //            var name = user!.valueForKey("full name")
            //            userDefaults.setObject(name, forKey: "full_name")
            
            userDefaults.setObject(self.password.text! as String, forKey: "password")
            
            var name = user!.fullName
            print(name)
            
            
            var email = user!.valueForKey("email")!
            print (email)
            userDefaults.setObject(email, forKey: "email")
            
            
            var id = user!.ID
            print (id)
            userDefaults.setObject(id, forKey: "id")
            
            var login = user!.login
            print (login)
            userDefaults.setObject(email, forKey: "login")
            
            var login_status = true
            userDefaults.setObject(login_status, forKey: "login_status")
            
            
            var params = ["email":"\(email)", "password":pass!]
            
            print ("Params: \(params)")
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            let client = delegate.client
//            let item = params
//            let itemTable = client.tableWithName("Users")
            
            
            
            Alamofire.request(.POST, "https://spotlight.azure-mobile.net/api/login", parameters: params).responseJSON(completionHandler: { (response) in
                
                
                if (response.result.error == nil)
                {
                    print ("Response Received")
                        var json = response.result.value as! NSDictionary
                    
                    
                    print ("*JSON: \(json)")
                    
                    if (json.valueForKey("messages") as! String == "Success")
                    {
                    
                        self.currentUser = json.valueForKey("user") as! [NSDictionary]
                        
                        userDefaults.setObject(self.currentUser[0].valueForKey("id") as! String, forKey: "azureId")
                        
                        
                        let currentInstallation = PFInstallation.currentInstallation()
                        currentInstallation.addUniqueObject("P-\(self.currentUser[0].valueForKey("id") as! String)", forKey: "channels")
                        currentInstallation.addUniqueObject("P-11263008", forKey: "channels")
                        currentInstallation.saveInBackground()
                        
                        let subscribedChannels = PFInstallation.currentInstallation().channels
                        
                        var name  = "\(self.currentUser[0].valueForKey("first_name") as! String) \(self.currentUser[0].valueForKey("last_name") as! String)"
                        
                        userDefaults.setObject(name, forKey: "name")
                        
                        userDefaults.setObject(self.currentUser[0].valueForKey("gender") as! String, forKey: "gender")
                        userDefaults.setObject(self.currentUser[0].valueForKey("profile_pic") as! String, forKey: "profile_pic")
                        
                        userDefaults.setObject(self.currentUser[0].valueForKey("prefs") as! String, forKey: "prefs")
                        
                        if (self.currentUser[0].valueForKey("vip") as? Bool != nil)
                        {
                            userDefaults.setObject(self.currentUser[0].valueForKey("vip") as! Bool, forKey: "vip")
                        }
                        else
                        {
                            userDefaults.setObject(false, forKey: "vip")
                        }
                        
                        
                        print ("***user id***:  \(self.currentUser[0].valueForKey("id") as! String)")
                        delegate.user = self.currentUser[0].valueForKey("id") as! String
                        self.userId = self.currentUser[0].valueForKey("id") as! String
                        
                        userDefaults.synchronize()
                        
                        //self.unRegPrev()
                        
                        //                        alert.dismissWithClickedButtonIndex(0, animated: true)
                        self.performSegueWithIdentifier("toHome", sender: self)
                        
                        self.loadingView.hidden = true
                        
                        
                    }else
                    {
                            
                            self.loadingView.hidden = true
                            self.status.text = "Wrong Username Password combination"
                            GTToast.create("Login Failed")
                    }
                }
                else
                {
                    GTToast.create("Login Failed.").show()
                    self.loadingView.hidden = true
                    self.status.text = "Wrong Username Password combination"
                    GTToast.create("Login Failed")
                }
                
            })
            
            //var predicate = NSPredicate(format: "email == [c] %@", user!)
            
            
            
            
            /*
            var query = MSQuery(table: itemTable)
            
            query.predicate = NSPredicate(format: "email == '\(usern!)' AND password == '\(pass!)'")
            
            print ("Predicate: \(query.predicate)")
            
            query.readWithCompletion({ (result, error) -> Void in
                
                if ((error) != nil)
                {
                    print (error.localizedDescription)
                    
                    self.loadingView.hidden = true
                    
                    self.status.text = "Wrong Username Password combination"
                    
                    GTToast.create("Login Failed")
                    
                }
                else
                {
                    print (result.items.count)
                    if (result.items.count>0)
                    {
                        self.currentUser = result.items as! [AnyObject]
                        
                        userDefaults.setObject(result.items[0].valueForKey("id") as! String, forKey: "azureId")
                        
                        
                        let currentInstallation = PFInstallation.currentInstallation()
                        currentInstallation.addUniqueObject("P-\(result.items[0].valueForKey("id") as! String)", forKey: "channels")
                        currentInstallation.addUniqueObject("P-11263008", forKey: "channels")
                        currentInstallation.saveInBackground()
                        
                        let subscribedChannels = PFInstallation.currentInstallation().channels
                        
                        var name  = "\(result.items[0].valueForKey("first_name") as! String) \(result.items[0].valueForKey("last_name") as! String)"
                        
                        userDefaults.setObject(name, forKey: "name")
                        
                        userDefaults.setObject(result.items[0].valueForKey("gender") as! String, forKey: "gender")
                        userDefaults.setObject(result.items[0].valueForKey("profile_pic") as! String, forKey: "profile_pic")
                        
                        userDefaults.setObject(result.items[0].valueForKey("prefs") as! String, forKey: "prefs")
                        
                        if (result.items[0].valueForKey("vip") as? Bool != nil)
                        {
                            userDefaults.setObject(result.items[0].valueForKey("vip") as! Bool, forKey: "vip")
                        }
                        else
                        {
                            userDefaults.setObject(false, forKey: "vip")
                        }
                        
                        
                        print ("***user id***:  \(result.items[0].valueForKey("id") as! String)")
                        delegate.user = result.items[0].valueForKey("id") as! String
                        self.userId = result.items[0].valueForKey("id") as! String
                        
                        userDefaults.synchronize()
                        
                        //self.unRegPrev()
                        
                        //                        alert.dismissWithClickedButtonIndex(0, animated: true)
                        self.performSegueWithIdentifier("toHome", sender: self)
                        
                        self.loadingView.hidden = true
                        
                    }
                    
                }
                
            })*/
            
            
            
            //            query.readWithPredicate(predicate, completion: { (block) -> Void in
            //                
            //                if (block.1 != nil)
            //                {
            //                    print (block.1.localizedDescription)
            //                }
            //                else
            //                {
            //                    
            //                    print (block.0.totalCount)
            //                    //self.performSegueWithIdentifier("toHome", sender: self)
            //                    
            //                }
            //                
            //            })
            
            
            
            }) { (QBResponse) -> Void in
                //error goes here
                
                print ("***Error")
                self.status.hidden  = false
                self.status.text = "Invalid Username/Password"
                print (QBResponse.error?.error?.localizedDescription)
                GTToast.create("Invalid Username/Password").show()
                
                if ((QBResponse.error?.error?.localizedDescription.rangeOfString("be offline.")) != nil){
                    
                    self.status.text = "Network Error."
                    
                }
                
                self.loadingView.hidden = true
                
                
                
        }
        
        userDefaults.synchronize()
        
    }
    
    
    func unRegPrev()
    {
        let deviceIdentifier: String = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        QBRequest.unregisterSubscriptionForUniqueDeviceIdentifier(deviceIdentifier, successBlock: { (response) in
            
            
            //self.performSegueWithIdentifier("toLogout", sender: self)
            
        }) { (error) in
            print ("**ERROR UNREG: \(error!.error!.localizedDescription) ")
            //self.performSegueWithIdentifier("toLogout", sender: self)
        }
    }
    
    func forgotPasswordAttemp(v:GTToastView)
    {
        var params = ["email": self.username.text!]
        var apiCall = "https://spotlight.azure-mobile.net/api/forgetPassword"
        
        print ("APICall : \(apiCall)")
        print ("Params: \(params)")
        
        Alamofire.request(.POST, apiCall, parameters: params).responseJSON { (response) in
            
            
            v.dismiss()
            
            print ("response: \(response.result.value)")
            
            if (response.result.error == nil)
            {
                var json  = response.result.value as? NSDictionary
                
                print ("json: \(json)")
                
                if (json != nil)
                {
                    if ((json!.valueForKey("status") as! Bool) == true){
                    
                        GTToast.create("Email Sent. Check your Email Inbox and Junk Folder.").show()
                    }else{
                    
                        GTToast.create("Invalid Email Address").show()
                    
                    }
                }
                else
                {
                      GTToast.create("Network Error").show()
                }
            }
            else
            {
                print ("Error: \(response.result.error)")
                GTToast.create("Network Error").show()
            }
        }
        
    }
    
    @IBOutlet weak var videoView: UIView!
    
    override func viewDidAppear(animated: Bool) {
        
        checkLoginStatus()
        
        self.loading.layer.cornerRadius = 100.0
        self.videoView.layer.cornerRadius = 10.0
        
        
        self.status.text = ""
        self.status.hidden = true
        
        
    }
   
    
    @IBOutlet weak var checkButton: UIButton!
    
    @IBAction func checkPressed(sender: UIButton) {
        
        
        
        if (sender.tag == 0)
        {
            self.mySwitch.on = true
            self.checkButton.tag = 1
            self.checkButton.selected = true
            
            self.rememberDetails.setOn(true, animated: true)
            
        }
        else
        {
            self.mySwitch.on = false
            self.checkButton.tag = 0
             self.checkButton.selected = false
            self.rememberDetails.setOn(false, animated: true)
        }
        
        
        stateChanged(self.rememberDetails)
        
    }
    
    func stateChanged(switchState: UISwitch) {
        
        print ("State: \(switchState.on)")
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(switchState.on, forKey: "login_status")
        userDefaults.synchronize()
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
        
        
//        
//        let jeremyGif = UIImage.gifWithName("Spinner (1)")
//        
//        loadingGif.image = jeremyGif
        
        
        mySwitch.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
//        let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("login", ofType: "mp4")!)
        
//        self.videoURL = url
//        self.videoFrame = view.frame
//        self.videoShouldLoop = true
//        self.alpha = 1.0
//        self.playSound = true
//        self.videoScalingMode = .ResizeAspectFill
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //        loginButton.delegate = self
        //        
        //        
        //        if (FBSDKAccessToken.currentAccessToken() != nil)
        //        {
        //            
        //            print ("logged in")
        //            
        //            loginUser()
        //            
        //            
        //        }
        //        else
        //        {
        //            print ("NOT logged in")
        //        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginUser()
    {
        
        var alert = UIAlertView()
        alert.title = "Logging in"
        alert.message = "Please wait while we setup everything..."
        //alert.show()
        
        loadingView.hidden = false
        
        QBRequest.logInWithSocialProvider("facebook", accessToken: FBSDKAccessToken.currentAccessToken().tokenString, accessTokenSecret: "RE2VfCJBxzXzrj8", successBlock: {(response:QBResponse!, user:QBUUser?)-> Void in
            
            print("User: \(user)")
            
            //
            let userDefaults = NSUserDefaults.standardUserDefaults()
            
            print("current User:\(user)")
            
            
            
            
            alert.dismissWithClickedButtonIndex(0, animated: true)
            
            self.performSegueWithIdentifier("toHome", sender: self)
            
            }, errorBlock: {(response:QBResponse!)-> Void in
                
                self.status.text = "Wrong Username Password combination"
                var alert = UIAlertView(title: "ERROR", message: "Unable to login. Please try later.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                
                
                
        })
        
    }
    
    
}

