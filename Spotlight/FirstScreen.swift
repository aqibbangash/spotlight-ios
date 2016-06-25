//
//  FirstScreen.swift
//  Spotlight
//
//  Created by Aqib on 28/03/2016.
//  Copyright © 2016 Sofit. All rights reserved.
//

import UIKit
import GTToast
import Quickblox

class FirstScreen: UIViewController {

    @IBOutlet weak var connect: UIButton!
    
    let a = "abcc@abc.com"
    let p = "aqibbangash"
    
    @IBAction func connectBtnPressed(sender: UIButton) {
        
        self.performSegueWithIdentifier("connect", sender: self)
        //createAccount()
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        if let login: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("notification") {
            
            if (login as! Bool)
            {
                let userDefaults  = NSUserDefaults.standardUserDefaults()
                
                userDefaults.setBool(false, forKey: "notification")
                
                userDefaults.synchronize()
                
                self.performSegueWithIdentifier("toMessagesDirect", sender: self)
            }
            
           
            
        }
    }
    
    
    func createAccount()
    {
        let user  = QBUUser()
        user.email = self.a
        user.login = self.a
        user.password = self.p
        
        QBRequest.signUp(user, successBlock: { (response, user) in
            
            
            GTToast.create("Created")
            
            }) { (errorResponse) in
            
                
                var msg = errorResponse.error?.error?.localizedRecoverySuggestion!
                var dataJson = msg?.dataUsingEncoding(NSUTF8StringEncoding)
                
                do
                {
                    var json = try NSJSONSerialization.JSONObjectWithData(dataJson!, options: .AllowFragments)
                    
                    var errorEmail = ((json.valueForKey("errors") as! NSDictionary).valueForKey("email") as? NSArray)
                    var errorPassword = ((json.valueForKey("errors") as! NSDictionary).valueForKey("password") as? NSArray)
                    
                    
                    var errorMsg =  ("*****\(((json.valueForKey("errors") as! NSDictionary).valueForKey("email") as! NSArray).firstObject as! String)")
                    var alert = UIAlertView()
                    alert.title = "Error"
                    alert.message = "Try again with different username/password"
                    alert.show()
                    
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
                    
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                    
                    } catch {
                    
                }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.connect.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        
        //createAccount()
    }

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
