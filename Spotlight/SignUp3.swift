//
//  SignUp1.swift
//  Spotlight
//
//  Created by Aqib on 27/02/2016.
//  Copyright © 2016 Sofit. All rights reserved.
//

import UIKit
import Quickblox
import Alamofire
import GTToast
import Parse
import FirebaseAnalytics
import Firebase

class SignUp3: UIViewController {
    
    
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    
    var userId:String  = ""
    var currentUser:[AnyObject] = []
    var stringEmail = ""
    var stringPassword = ""
    var stringRePassword = ""
    
    var url = "https://exchangeappreview.azurewebsites.net/"
    
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        emailLabel.attributedPlaceholder = NSAttributedString(string:"Email",
                                                              attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        passwordLabel.attributedPlaceholder = NSAttributedString(string:"Password",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        confirmPassword.attributedPlaceholder = NSAttributedString(string:"Confirm Password",
                                                                   attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        
        //        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        //        let underlineAttributedString = NSAttributedString(string: "Terms and Conditions", attributes: underlineAttribute)
        //labelTerms.attributedText = underlineAttributedString
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @IBAction func registerButtonAction(sender: UIButton) {
        
        self.stringEmail = emailLabel.text!
        self.stringPassword = passwordLabel.text!
        self.stringRePassword = confirmPassword.text!
        
        
        
        if (stringPassword == stringRePassword)
        {
            
            if (self.stringEmail != "" && self.stringPassword != "" && self.stringRePassword != "")
            {
                let userDefaults = NSUserDefaults.standardUserDefaults()
                
                userDefaults.setObject(self.stringEmail, forKey: "newEmail")
                
                userDefaults.setObject(self.stringPassword, forKey: "newPassword")
                
                userDefaults.synchronize()
                
                
                registerQuickBlox()
            }
        }
        else
        {
            let alert = UIAlertView()
            alert.title = "Problem"
            alert.message = "Passwords mismatch"
            alert.addButtonWithTitle("Ok")
            alert.show()
            
            self.passwordLabel.text = ""
            self.confirmPassword.text = ""
            
        }
    }
    
    @IBOutlet weak var labelTerms: UILabel!
    
    
    
    func registerQuickBlox()
    {
        var alert = UIAlertView()
        alert.title = "Registering"
        alert.message = "Creating your Spotlight account. Please wait"
        //alert.addButtonWithTitle("Ok")
        alert.show()
        
        let user  = QBUUser()
        
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("newEmail") {
            user.email = stringEmail
            user.login = stringEmail
        }
        
        var n = "Anonymous"
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("newFName") {
            n = username as! String
        }
        
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("newLName") {
            
            n += " \(username as! String)"
            
        }
        
        user.fullName = n
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("newPassword") {
            user.password = stringPassword;
        }
        
        user.fullName = "Anonymous"
        if let fullN: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("first_name") {
            user.fullName = "\(fullN as! String)"
        }
        if let fullN: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("last_name") {
            user.fullName = "\(user.fullName) \(fullN as! String)"
        }
        
        
        
        
        QBRequest.signUp(user, successBlock: { (response:QBResponse, user:QBUUser?) -> Void in
            
            //            self.dismissViewControllerAnimated(true, completion: nil)
            
            
            alert.message = "Setting Things Up For you..."
            
            var fName:String = "Anonymous", lName:String = "User", gender:String = "A", country:String = "Unknown", city:String = "Unknown", profile:String = "https://www.drupal.org/files/profile_default.jpg", email:String = "", password:String = "" ;
            
            var age:String = "Jan 31 2016"
            var quickblox:String = ""
            
            quickblox = "\(user!.ID)"
            
            if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("newEmail") {
                email = username as! String
            }
            if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("newPassword") {
                password = username as! String
            }
            
            
            var params = ["first_name":fName,
                "last_name":lName,
                "gender":gender,
                "country":country,
                "city":city,
                "age":age.stringByReplacingOccurrencesOfString(",", withString: ""),
                "quickblox_id":quickblox,
                "id":quickblox,
                "profile_pic":profile,
                "email":email,
                "password":password,
                "points":"100",
                "prefs":"MFA",
                "vip":false
                
            ]
            
            //            FIRAnalytics.logEventWithName(kFIREventSelectContent, parameters: [
            //                kFIRParameterContentType:"cont",
            //                kFIRParameterItemID:"1"
            //                ])
            
            
            FIRAnalytics.logEventWithName("UserSignup", parameters: params as! [String : NSObject])
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let client = delegate.client
            let item = params
            let itemTable = client.tableWithName("Users")
            itemTable.insert(item as [NSObject : AnyObject] as [NSObject : AnyObject]){
                (insertedItem, error) in
                
                if (error != nil)
                {
                    
                    
                    alert.dismissWithClickedButtonIndex(0, animated: true)
                    alert = UIAlertView()
                    alert.title = "Error."
                    alert.message = error.localizedDescription
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                }
                else
                {
                    alert.message = "Logging In."
                    
                    alert.dismissWithClickedButtonIndex(0, animated: true)
                    //self.dismissViewControllerAnimated(true, completion: nil)
                    
                    //self.performSegueWithIdentifier("backToLogin", sender: self)
                    
                    self.signInWithUsernamePassword()
                    
                }
                
                
            }
            
        }) { (errorResponse) in
            
            
            var msg = "Error"
            if (errorResponse.error?.error?.localizedRecoverySuggestion != nil)
            {
                msg = (errorResponse.error?.error?.localizedRecoverySuggestion!)!
            }
            
            var dataJson = msg.dataUsingEncoding(NSUTF8StringEncoding)
            
            do
            {
                var json = try NSJSONSerialization.JSONObjectWithData(dataJson!, options: .AllowFragments)
                
                var errorEmail = ((json.valueForKey("errors") as! NSDictionary).valueForKey("email") as? NSArray)
                var errorPassword = ((json.valueForKey("errors") as! NSDictionary).valueForKey("password") as? NSArray)
                
                if (errorEmail != nil)
                {
                    print ("Error Email: \(errorEmail)")
                    var errorMsg =  ("*****\((errorEmail)!.firstObject as? String)")
                }
                if (errorPassword != nil)
                {
                    print ("Error Password : \(errorPassword)")
                    var errorMsg =  ("*****\((errorPassword!).firstObject as? String)")
                }
                
                
                alert.dismissWithClickedButtonIndex(0, animated: true)
                
                
                
                
                var alert = UIAlertView()
                alert.title = "Error"
                alert.message = "Try again with different username/password"
                alert.addButtonWithTitle("Ok")
                //alert.show()
                
                if (errorEmail != nil)
                {
                    var errorMsg = errorEmail!.firstObject as? String
                    if (errorMsg != nil)
                    {
                        alert.message = "Email \(errorMsg!)"
                    }
                    
                    
                }
                else{
                    print ("error Email")
                }
                
                if (errorPassword != nil){
                    
                    var errorMsg = errorPassword!.firstObject as? String
                    if (errorMsg != nil)
                    {
                        alert.message = "Password \(errorMsg!)"
                    }
                    
                }else{
                    print ("error Pss")
                }
                
                
                alert.show()
                
            } catch {
                
            }
            
        }
        
        
    }
    
    func signInWithUsernamePassword() {
        
        var usern = emailLabel.text
        var pass = passwordLabel.text
        
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setObject(usern, forKey: "user")
        userDefaults.setObject(pass, forKey: "pass")
        
        var alert = UIAlertView()
        alert.title = "Please wait..."
        alert.message = "Logging in"
        //alert.show()
        
        
        
        alert.dismissWithClickedButtonIndex(0, animated: true)
        alert = UIAlertView()
        alert.title = "Logging in"
        alert.message = "Please wait...."
        alert.show()
        
        
        //self.loadingView.hidden = false
        
        
        
        
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
            
            userDefaults.setObject(self.passwordLabel.text! as String, forKey: "password")
            
            var name = user!.fullName
            print(name)
            
            
            var email = user!.valueForKey("email")
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
            
            
            var params = ["email":user!, "password":pass!]
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let client = delegate.client
            let item = params
            let itemTable = client.tableWithName("Users")
            //var predicate = NSPredicate(format: "email == [c] %@", user!)
            
            var query = MSQuery(table: itemTable)
            query.predicate = NSPredicate(format: "email == '\(usern!)' AND password == '\(pass!)'")
            
            print ("Predicate: \(query.predicate)")
            
            query.readWithCompletion({ (result, error) -> Void in
                
                
                
                alert.dismissWithClickedButtonIndex(0, animated: true)
                
                if ((error) != nil)
                {
                    print (error.localizedDescription)
                    
                    //self.loadingView.hidden = true
                    
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
                        
                        
                        
                        
                        alert.dismissWithClickedButtonIndex(0, animated: true)
                        
                        alert.dismissWithClickedButtonIndex(0, animated: true)
                        
                        //self.unRegPrev()
                        
                        //                        alert.dismissWithClickedButtonIndex(0, animated: true)
                        self.performSegueWithIdentifier("toHome", sender: self)
                        
                        //self.loadingView.hidden = true
                        
                    }
                    
                }
                
            })
            
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
            print (QBResponse.error?.error?.localizedDescription)
            
            //self.loadingView.hidden = true
            
            GTToast.create("Login Failed")
            
        }
        
        userDefaults.synchronize()
        
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
    
    
}
