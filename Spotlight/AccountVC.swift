//
//  AccountVC.swift
//  Spotlight
//
//  Created by Aqib on 11/03/2016.
//  Copyright © 2016 Sofit. All rights reserved.
//

import UIKit
import Parse
import Quickblox
import Firebase
import Alamofire
import GTToast

class AccountVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var url = "https://exchangeappreview.azurewebsites.net/"
    var userId = ""
    
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var const: NSLayoutConstraint!
    @IBOutlet weak var vipIV: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var img: PASImageView!
    @IBOutlet weak var vipbutton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    var picUrl:String = ""
    var recept = ""
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var pass1: UITextField!
    @IBOutlet weak var pass2: UITextField!
    
    let imagePicker = UIImagePickerController()
    var temp:UIPickerView?
    @IBOutlet weak var pickerView: UIPickerView!
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        print ("Finished Picking")
        dismissViewControllerAnimated(true, completion: nil)
        print ("Image: \(image)")
        uploadPhoto(image)
        
    }
    
    func uploadPhoto(userImage:UIImage)
    {
        
        let myUrl = NSURL(string: "\(url)spotlight/changeImage.php?userId=\(self.userId)");
        
        var al = UIAlertView()
        
        al.title = "Please wait"
        al.message = "Uploading Image..."
        al.show()
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(userImage, 0)
        
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters(nil, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            let httpResponse = response as! NSHTTPURLResponse
            
            
            
            let status =  httpResponse
            
            
            al.dismissWithClickedButtonIndex(0, animated: true)
            
            do {
                
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                var pp = json!.valueForKey("fileurl") as! String
                //pp = "https://exchangeappreview.azurewebsites.net/Spotlight/\(pp)"
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(pp, forKey: "profile_pic")
                userDefaults.synchronize()
                
                self.picUrl = pp
                
                self.img.imageURL(NSURL(string: pp)!)
                
                print ("xyz: \(json)")
                
                let userDefaults1 = NSUserDefaults.standardUserDefaults()
                
                userDefaults1.setObject(self.picUrl, forKey: "profile_pic")
                
                print ("This has been saved : \(self.picUrl)")
                
                userDefaults1.synchronize()
                
                al.dismissWithClickedButtonIndex(0, animated: true)
                
                
            } catch
            {
                print ("ERROR")
                
                al.dismissWithClickedButtonIndex(0, animated: true)
                
            }
            
            
            
            //            NSOperationQueue.mainQueue().addOperationWithBlock {
            //
            //                self.performSegueWithIdentifier("verifyNumber", sender: self)
            //            }
            
            
            
            
            
            
            //self.performSegueWithIdentifier("contactAdded", sender: self)
            
            //            let userDefaults = NSUserDefaults.standardUserDefaults()
            //            userDefaults.setObject("yes", forKey: "contactAdded")
            //            userDefaults.synchronize()
            //
            //            //self.dismissViewControllerAnimated(true, completion: {});
            //
            //            self.performSegueWithIdentifier("contactHasBeenAddedYes", sender: self)
            
            //unwindForSegue(<#T##unwindSegue: UIStoryboardSegue##UIStoryboardSegue#>, towardsViewController: <#T##UIViewController#>)
            
            //            do{
            //             let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
            //                print(json)
            //            } catch {
            //
            //            }
            
            
            
            
            
            //            dispatch_async(dispatch_get_main_queue(),{
            //                self.myActivityIndicator.stopAnimating()
            //                    self.contactImage.image = nil;
            //            });
            
            /*
             if let parseJSON = json {
             var firstNameValue = parseJSON["firstName"] as? String
             println("firstNameValue: \(firstNameValue)")
             }
             */
            
        }
        
        task.resume()
        
        
    }
    
    @IBOutlet weak var purchaseWindow: UIView!
    @IBAction func closePurchase(sender: UIButton) {
        
        purchaseWindow.hidden = true
        
    }
    
    @IBAction func purchaseFinal(sender: UIButton) {
        
        
        self.purchaseWindow.hidden = true
        PFPurchase.buyProduct("spotlightVip") { (error) in
            
            if (error != nil)
            {
                print ("error with the purchase: \(error?.localizedDescription)")
                
                let alert  = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            }else{
                
                print ("Successfull")
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setBool(true, forKey: "vip")
                userDefaults.synchronize()
                
                self.makeEntryForVip()
                
                
                
            }
            
        }
        
    }
    
    @IBOutlet weak var vipOn: UIView!
    @IBOutlet weak var updateInfoView: UIView!
    
    func isAnon(b:Bool) -> Bool
    {
        
        if let anon: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("name") {
            
            var name = anon as! String
            
            if (name.contains("nonymous"))
            {
                
                if (b)
                {
                    self.updateInfoView.fadeIn()
                }
                return true
                
                
            }
            else{
                return false
            }
        }
        
        return true
    }
    
    
    @IBAction func updateNo(sender: UIButton) {
        
        self.updateInfoView.fadeOut()
        
    }
    
    @IBAction func updateYes(sender: UIButton) {
        
        self.updateInfoView.fadeOut()
        self.performSegueWithIdentifier("updateInfo", sender: self)
        
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        var body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        
        let filename = "user-image-\(randomStringWithLength(15)).jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print ("Image: Not Selected")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //        bannerView.rootViewController = self
        //        bannerView.loadRequest(GADRequest())
        
        
        dialogPasswordInner.layer.shadowOffset = CGSizeMake(0, 0)
        dialogPasswordInner.layer.shadowRadius = 8.0
        dialogPasswordInner.layer.shadowOpacity = 0.8
        dialogPasswordInner.layer.borderWidth = 1
        dialogPasswordInner.layer.borderColor = UIColor(netHex:0x08142a).CGColor
        
        
        //        self.currentPaswordField.
        
        if let login: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("azureId") {
            
            self.userId  = login as! String
            
        }
        
        profilePicture.layer.cornerRadius = self.profilePicture.frame.width/2
        
        
        imagePicker.delegate = self
        
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
        
        
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    
    @IBAction func cancelPasswordUpdate(sender: UIButton) {
        
        self.changePasswordView.hidden = true
        
    }
    
    @IBAction func changePasswordButtonClicked(sender: UIButton) {
        
        self.changePasswordView.hidden = false
        
    }
    
    @IBOutlet weak var errorMessage: UILabel!
    @IBAction func updatePasswordConfirm(sender: UIButton) {
        
        //sender.enabled = false
        
        dismissKeyboard()
        
        if (currentPaswordField.text?.characters.count>0 && pass1.text?.characters.count>0 && pass2.text?.characters.count>0)
        {
            if (pass1.text! == pass2.text!)
            {
                if (pass1.text!.characters.count > 7)
                {
                    self.changePassword(self.pass1.text!, oldPass: self.currentPaswordField.text!)
                }else
                {
                    
                    self.errorMessage.text = "Minimum 8 characters password."
                    self.errorMessage.textColor = UIColor.redColor()
                    GTToast.create("Minimum 8 characters password.")
                }
                
            }
            else
            {
                GTToast.create("Passwords Mismatch")
                self.errorMessage.text = "Password Mismatch"
                self.errorMessage.textColor = UIColor.redColor()
                pass1.text = ""
                pass2.text = ""
            }
        }
        else
        {
            self.errorMessage.text = "Password can't be empty"
            self.errorMessage.textColor = UIColor.redColor()
            GTToast.create("Enter Some Text")
        }
        
        
    }
    
    @IBOutlet weak var currentPaswordField: UITextField!
    
    func changePassword(s: String, oldPass:String)
    {
        
        //        var oldPass = ""
        //        if let login: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("pass") {
        //            
        //            oldPass  = login as! String
        //            
        //        }
        
        var tempId = ""
        
        if let login: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("azureId") {
            
            tempId  = login as! String
            
        }
        
        self.errorMessage.text = "Updating... Please wait!"
        self.errorMessage.textColor = UIColor.whiteColor()
        updateBtn.enabled = false
        
        var params = QBUpdateUserParameters()
        params.password = s
        params.oldPassword = oldPass
        
        QBRequest.updateCurrentUser(params, successBlock: { (respinse, user) in
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            
            userDefaults.setObject(user?.password, forKey: "pass")
            
            userDefaults.synchronize()
            
            self.errorMessage.text = "Password updated!"
            self.errorMessage.textColor = UIColor.greenColor()
            
            
            self.updateAzurePassword(tempId, s: s)
            
        }) { (respinseError) in
            
            
            
            self.updateBtn.enabled = true
            self.errorMessage.text = "Error Updating Password. try again"
            self.errorMessage.textColor = UIColor.redColor()
            print ("*Error Updating: \(respinseError.error)")
            
        }
    }
    
    @IBAction func updateProfile(sender: UIButton) {
        
        self.performSegueWithIdentifier("updatePro", sender: self)
        
    }
    
    @IBOutlet weak var dialogPasswordInner: UIView!
    
    var urla = "https://exchangeappreview.azurewebsites.net/Spotlight"
    
    func updateAzurePassword(u:String, s:String){
        
        var params = ["userId":u,"newPassword":s]
        
        Alamofire.request(.POST, "\(self.urla)/updatePassword.php", parameters: params).responseJSON { (Response) in
            
            self.pass2.text = ""
            self.pass1.text = ""
            self.errorMessage.textColor = UIColor.whiteColor()
            self.changePasswordView.hidden = true
            self.updateBtn.enabled = true
            self.errorMessage.text = ""
            
        }
    }
    @IBAction func deactivateClicked(sender: UIButton) {
        
        //self.deleteDialog.hidden = true
        
        QBRequest.deleteCurrentUserWithSuccessBlock({ (resposnse) in
            
            self.deleteAccount()
            
        }) { (response) in
            
            
            
        }
        
        
        //self.deleteAccount()
        
    }
    
    @IBAction func cancelDeactivate(sender: UIButton) {
        
        self.deleteDialog.hidden = true
        
    }
    
    @IBAction func changeImage(sender: UIButton) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func deleteAccount()
    {
        
        
        var tempId = ""
        
        if let login: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("azureId") {
            
            tempId  = login as! String
            
        }
        
        var params = ["userId":tempId]
        
        Alamofire.request(.POST, "\(self.urla)/deleteAccount.php", parameters: params).responseJSON { (response) in
            
            if (response.result.error == nil)
            {
                self.deleteDialog.hidden = true
                self.logoutAction(UIButton())
            }
            else{
                
            }
        }
        
        
    }
    @IBOutlet weak var deleteDialog: UIView!
    @IBOutlet weak var percentage: UIImageView!
    
    @IBAction func deactivateAccount(sender: UIButton) {
        
        
        self.deleteDialog.hidden = false
        
    }
    
    @IBOutlet weak var updateBtn: UIButton!
    
    @IBAction func menuButtonPressed(sender: UIButton) {
        
        if (const.constant == -100)
        {
            openDrawer()
        }
        else
        {
            closeDrawer()
        }
        
    }
    
    @IBOutlet weak var optionsBtnView: UIView!
    func openDrawer()
    {
        self.optionsBtnView.fadeIn()
        const.constant = 0
    }
    
    func closeDrawer()
    {
        
        self.optionsBtnView.fadeOut()
        const.constant = -100
    }
    
    @IBAction func openMessages(sender: UIButton) {
        
        self.performSegueWithIdentifier("toMessages", sender: self)
        closeDrawer()
    }
    
    @IBOutlet weak var lockVip: UIImageView!
    @IBAction func openFriends(sender: UIButton) {
        self.performSegueWithIdentifier("toFriends", sender: self)
        closeDrawer()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //let jeremyGif = UIImage.gifWithName("VIP-logo")
        
        //vipIV.image = UIImage.gifWithName("VIP-logo")
        
        
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("vip") {
            
            print (user as! Bool)
            
            if (user as! Bool)
            {
                self.vipOn.hidden = true
                print (user as! Bool)
                self.vipbutton.enabled = false
                self.vipbutton.titleLabel?.text = "Spotlight VIP (Already Purchased)"
                self.vipbutton.setTitle("Spotlight VIP (Purchased)", forState: .Normal)
                
                
            }
            else{
                
                print ("This happened.")
                //   self.makeEntryForVip()
            }
            
        }
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("profile_pic") {
            
            
        }
        
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("name") {
            
            self.username.text = user as! String
            
            
            if ((user as! String).contains("nonymous"))
            {
                self.percentage.image = UIImage(named: "0percent")
                self.lockVip.hidden = false
            }
            else{
                self.percentage.image = UIImage(named: "fullpercentage")
                self.lockVip.hidden = true
                
            }
            
        }
        
        
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("profile_pic") {
            
            
            if (user as! String == "image")
            {
                
                if let gen: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("gender")
                {
                    
                    if (gen as! String == "M")
                    {
                        self.img.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png")!)
                    }else
                    {
                        self.img.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png")!)
                    }
                }
                else{
                    self.img.imageURL(NSURL(string:"https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png")!)
                }
                
                
            }
            else{
                self.img.imageURL(NSURL(string: user as! String)!)
            }
            
            //self.img.imageURL(NSURL(string: user as! String)!)
            
            
        }
        
        
        //        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("azureId") {
        //            
        //            self.recept = user as! String
        
        
        
        //        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("azureId") {
        //            
        //            self.recept = user as! String
        //            
        //            if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("user-\(self.recept)") {
        //                
        //                print ("object saved for this user as: \(user as! String)")
        //                var a = (user as! String).componentsSeparatedByString(",")
        //                self.picUrl = a[7]
        //                
        //                self.username.text = "\(a[1])n\(a[2])"
        //                
        //                print ("pic : \(self.picUrl)")
        //                
        //                self.img.imageURL(NSURL(string: self.picUrl)!)
        //                
        ////                profilePicture.loadImageFromURLString(self.picUrl, placeholderImage: UIImage(named: "btn-profile")) {
        ////                    (finished, error) in
        ////                    
        ////                    
        ////                }
        //                
        //                
        //                
        //            }
        
        //        }
        
    }
    
    func makeEntryForVip()
    {
        var apiCall = "https://exchangeappreview.azurewebsites.net/Spotlight/vip_user.php"
        var id  = ""
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("id") {
            id  = "\(user as! Int)"
        }
        
        
        Alamofire.request(.POST, apiCall, parameters: ["id":"\(id)"])
        
    }
    
    
    @IBAction func purchaseVIP(sender: UIButton) {
        
        if (self.isAnon(true))
        {
            
        }else{
            purchaseWindow.hidden = false
        }
        
    }
    
    
    @IBAction func logoutAction(sender: AnyObject) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        var login_status = false
        
        userDefaults.setObject(login_status, forKey: "login_status")
        
        userDefaults.synchronize()
        
        let deviceIdentifier: String = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        QBRequest.unregisterSubscriptionForUniqueDeviceIdentifier(deviceIdentifier, successBlock: { (response) in
            
            
            self.performSegueWithIdentifier("toLogout", sender: self)
            
        }) { (error) in
            print ("**ERROR UNREG: \(error!.error!.localizedDescription) ")
            self.performSegueWithIdentifier("toLogout", sender: self)
        }
        
        
        
        
        
    }
    
    
    
    @IBAction func openWebsite(sender: UIButton) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "http://spotlightrc.com/")!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
