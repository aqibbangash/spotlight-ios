//
//  SignUp1.swift
//  Spotlight
//
//  Created by Aqib on 27/02/2016.
//  Copyright © 2016 Sofit. All rights reserved.
//

import UIKit

class SignUp1: UIViewController, UITextFieldDelegate {

    var firstNameS:String = "", lastNameS:String = "", genderS:String = ""
    
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        firstName.attributedPlaceholder = NSAttributedString(string:"First Name",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        lastName.attributedPlaceholder = NSAttributedString(string:"Last Name",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        firstName.delegate = self
        lastName.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.topConstraint.constant = -30
            }, completion: { (v) -> Void in
                
                
                
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(1, animations: { () -> Void in
             self.topConstraint.constant =  44
        })
    }
    

    @IBOutlet weak var femaleSelection: UIView!
    @IBOutlet weak var maleSelection: UIView!
    
    func textViewDidEndEditing(textView: UITextView) {
        
        textView.endEditing(true)
        
    }
    
    @IBAction func continueButtonPressed(sender: UIButton) {
        

        firstNameS = firstName.text!
        lastNameS = firstName.text!
        
        if (lastNameS != "" || firstNameS != "")
        {
            
            

        }
        
        
    }
    
    
    @IBAction func `continue`(sender: UIButton) {
    
        self.firstNameS = self.firstName.text!
        self.lastNameS = self.lastName.text!
        
        if (self.firstNameS != "" && self.lastNameS != "" && genderS != "")
        {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            
            userDefaults.setObject(self.firstNameS, forKey: "newFName")
            
            userDefaults.setObject(self.lastNameS, forKey: "newLName")
            
            userDefaults.setObject(self.genderS, forKey: "newGender")
            
            userDefaults.synchronize()
            
            self.performSegueWithIdentifier("step2", sender: self)
        }
        
        
    }
    
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func maleButtonPressed(sender: UIButton) {
        
        genderS = "M"
        self.maleSelection.hidden = false
        self.femaleSelection.hidden = true
        
    }
    
    @IBAction func femaleButtonPressed(sender: UIButton) {
    
                genderS = "F"
        self.maleSelection.hidden = true
        self.femaleSelection.hidden = false
    }
}
