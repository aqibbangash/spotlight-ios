//
//  SignUp1.swift
//  Spotlight
//
//  Created by Aqib on 27/02/2016.
//  Copyright © 2016 Sofit. All rights reserved.
//

import UIKit
import MICountryPicker
import GTToast
import Quickblox

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}

extension NSLocale {
    
    struct Locale {
        let countryCode: String
        let countryName: String
    }
    
    class func getAllLocales() -> [Locale] {
        
        var locales = [Locale]()
        for localeCode in NSLocale.ISOCountryCodes() {
            let countryName = NSLocale.systemLocale().displayNameForKey(NSLocaleCountryCode, value: localeCode)!
            let countryCode = localeCode as! String
            let locale = Locale(countryCode: countryCode, countryName: countryName)
            locales.append(locale)
        }
        
        return locales
    }
    
}



class SignUp2: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CountrySelectorViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var doneTopMargin: NSLayoutConstraint!
    
    @IBOutlet weak var theView: UIView!
    @IBOutlet weak var selectView: CountrySelectorView!
    var countryString = ""
    var cityString = ""
    var ageString = ""
    var picUrl = "https://res.cloudinary.com/dkwzeynei/image/upload/v1456997527/q4a5bblbhuyi2g87ov5q.jpg"
    
    
    var url = "https://exchangeappreview.azurewebsites.net/Spotlight/uploadImage.php"
    var maleImage = "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png"
    var femaleImage = "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png"
    
    
    var currentUser:[AnyObject] = []
    var userImage:UIImage?
    let alert = UIAlertView()
    @IBOutlet weak var pickerView: UIPickerView!
    var temp:UIPickerView?
    
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var uploadbtn: UIButton!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var countryLabel: UITextField!
    @IBOutlet weak var ageLabel: UITextField!
    @IBOutlet weak var profilePictureButton: UIButton!
    
    
    func layoutPickView(pickerView: UIPickerView) {
        
        let variableBindings = [ "pickerView": pickerView]
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-[pickerView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: variableBindings)
        self.view.addConstraints(horizontalConstraints)
        
        let bottomConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[pickerView]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: variableBindings)
        
        self.view.bringSubviewToFront(pickerView)
        
        temp = pickerView
        
        self.view.addConstraints(bottomConstraints)
    }
    
    func showPickInView()->UIView {
        
        cityLabel.endEditing(true)
        ageLabel.endEditing(true)
        
        var bu = UIButton()
        bu.tag = 0
        openPicker(bu)
        return  self.theView
    }
    
    func phoneCodeDidChange(myPickerView: UIPickerView, phoneCode: String) {
        print(phoneCode)
        self.countryLabel.text = phoneCode
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print ("Number of rows: \(NSLocale.getAllLocales().count)")
        return NSLocale.getAllLocales().count
    }
    
    @IBAction func openDatePicker(sender: UIButton) {
        
        self.view.endEditing(true)
        self.openPicker(sender)
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var a = NSLocale.getAllLocales()[row].countryName
        
        
        return a.localizedCapitalizedString
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.countryLabel.text = NSLocale.getAllLocales()[row].countryName.localizedCapitalizedString
    }
    
    func countryPicker(picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        print(code)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    
    func loadDefaultImageForPerson(s:String)
    {
        
        
        
        if (s == "F")
        {
            self.picUrl = "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png"
            let u = UIImage(named: "default-female")
            self.picUrl = self.femaleImage
            if (u == nil)
            {
                print ("Nil found")
            }
            self.profilePictureButton.setImage(u, forState: UIControlState.Normal)
            // imageView?.image = UIImage(named: "")
        }
        else
        {
            self.picUrl = "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png"
            self.picUrl = self.maleImage
            let u = UIImage(named: "default-male")
            if (u == nil)
            {
                print ("Nil found")
            }
            self.profilePictureButton.setImage(u, forState: UIControlState.Normal)
            // self.profilePictureButton.imageView?.image = UIImage(named: "default-male")
            
        }
        
        self.profilePictureButton.imageView!.contentMode = .ScaleAspectFill
        self.profilePictureButton.imageView?.layer.cornerRadius = self.profilePictureButton.imageView!.frame.width/2
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        selectView.delegate = self;
        selectView.setDefaultCountry("US")
        selectView.setFrequentCountryList(["TW","US"])
        
        alert.title = "Uploading image"
        alert.message = "Please wait..."
        
        imagePicker.delegate = self
        
        self.profilePictureButton.imageView?.contentMode = .ScaleAspectFill
        
        
        cityLabel.attributedPlaceholder = NSAttributedString(string:"City",
                                                             attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        countryLabel.attributedPlaceholder = NSAttributedString(string:"Country",
                                                                attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        ageLabel.attributedPlaceholder = NSAttributedString(string:"Date Of Birth",
                                                            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("newGender") {
            loadDefaultImageForPerson(username as! String)
        }
        
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        self.pickerDrop(UIButton())
        
        //MICountryPicker.
        
        
    }
    
    @IBAction func profilePictureAction(sender: AnyObject) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        profilePictureButton.imageView!.contentMode = .ScaleAspectFit
        profilePictureButton.imageView!.image = image
        
        profilePictureButton.setImage(image, forState: UIControlState.Normal)
        
        profilePictureButton.contentMode = .ScaleAspectFill
        
        profilePictureButton.imageView?.hidden = false
        
        profilePictureButton.imageView?.contentMode = .ScaleAspectFill
        
        profilePictureButton.imageView?.image = image
        
        dismissViewControllerAnimated(true, completion: nil)
        
        self.userImage = image
        
        uploadbtn.enabled = true
        
        uploadPhoto()
        
    }
    
    
    @IBAction func dateSelected(sender: UIDatePicker) {
        
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        var strDate = dateFormatter.stringFromDate(sender.date)
        
        self.ageLabel.text = strDate
        
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func openPicker(sender: UIButton) {
        
        if (sender.tag == 0)
        {
            datePicker.hidden = true
            //pickerView.hidden = false
            if (self.temp != nil)
            {
                self.temp!.hidden = false
            }
            
            
            
        }
        else
        {
            datePicker.hidden = false
            //  pickerView.hidden = true
            if (self.temp != nil)
            {
                self.temp!.hidden = true
            }
        }
        
        if (doneTopMargin.constant == -210)
        {
            doneTopMargin.constant = 0
        }
        
    }
    
    @IBAction func pickerDrop(sender: UIButton) {
        if (doneTopMargin.constant == 0)
        {
            doneTopMargin.constant = -210
        }
    }
    
    @IBAction func `continue`(sender: UIButton) {
        
        if (self.picUrl == "")
        {
            self.uploadbtn.titleLabel?.textColor = UIColor.redColor()
            //show Alert
            //upload picture
        } else
        {
            self.countryString = self.countryLabel.text!
            self.cityString = self.cityLabel.text!
            self.ageString = self.ageLabel.text!
            
            
            if (self.countryString != "" && self.cityString != "" && ageString != "")
            {
                let userDefaults = NSUserDefaults.standardUserDefaults()
                
                userDefaults.setObject(self.countryString, forKey: "newCName")
                
                userDefaults.setObject(self.cityString, forKey: "newCityName")
                
                userDefaults.setObject(self.ageString, forKey: "newAgeString")
                
                userDefaults.setObject(self.picUrl, forKey: "newPicUrl")
                
                
                
                userDefaults.synchronize()
                
                updateInfo()
                //self.performSegueWithIdentifier("step3", sender: self)
            }
            
        }
        
        
    }
    
    
    var userId:String  = ""
    
    
    
    func updateInfo()
    {
        
        var alert = UIAlertView()
        
        alert.title = "Updating"
        alert.message = "Please wait"
        alert.show()
        var id = ""
        var fName:String = "", lName:String = "", gender:String = "", country:String = "", city:String = "", profile:String = "", email:String = "", password:String = "" ;
        
        var age:String = "", quickblox:String = ""
        
        
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("email") {
            email = username as! String
        }
        
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("password") {
            password = username as! String
        }
        
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("newFName") {
            fName = username as! String
        }
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("newLName") {
            lName = username as! String
        }
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("newGender") {
            gender = username as! String
        }
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("newCName") {
            country = username as! String
        }
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("newCityName") {
            city = username as! String
        }
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("newAgeString") {
            age = username as! String
        }
        
        quickblox = id
        
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("newPicUrl") {
            profile = username as! String
        }
        
        
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("newEmail") {
            email = username as! String
        }
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("newPassword") {
            password = username as! String
        }
        
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("azureId") {
            id = username as! String
            quickblox = username as! String
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
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let item = params
        let itemTable = client.tableWithName("Users")
        
        print ("New Info: \(params)")
        itemTable.update(item as [NSObject : AnyObject] as [NSObject : AnyObject]){
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
                
                
                alert.dismissWithClickedButtonIndex(0, animated: true)
                //self.dismissViewControllerAnimated(true, completion: nil)
                
                //self.performSegueWithIdentifier("backToLogin", sender: self)
                
                //self.signInWithUsernamePassword()
                
                self.signInWithUsernamePassword(email, pass: password)
                //self.dismissViewControllerAnimated(true, completion: nil)
                
            }
            
            
        }
        
        
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
    
    
    
    @IBAction func back(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    
    
    func signInWithUsernamePassword(usern:String, pass:String) {
        
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setObject(usern, forKey: "user")
        userDefaults.setObject(pass, forKey: "pass")
        
        var alert = UIAlertView()
        alert.title = "Please wait..."
        alert.message = "Logging in"
        //alert.show()
        
        
        
        alert.dismissWithClickedButtonIndex(0, animated: true)
        alert = UIAlertView()
        alert.title = "Going Back"
        alert.message = "Please wait...."
        alert.show()
        
        
        //self.loadingView.hidden = false
        
        
        
        
        QBRequest.logInWithUserEmail(usern, password: pass, successBlock: {(response:QBResponse!, user:QBUUser?) -> Void in
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
            
            userDefaults.setObject(pass, forKey: "password")
            
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
            
            
            var params = ["email":user!, "password":pass]
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let client = delegate.client
            let item = params
            let itemTable = client.tableWithName("Users")
            //var predicate = NSPredicate(format: "email == [c] %@", user!)
            
            var query = MSQuery(table: itemTable)
            query.predicate = NSPredicate(format: "email == '\(usern)' AND password == '\(pass)'")
            
            print ("Predicate: \(query.predicate)")
            
            query.readWithCompletion({ (result, error) -> Void in
                
                
                
                alert.dismissWithClickedButtonIndex(0, animated: true)
                
                if ((error) != nil)
                {
                    print (error.localizedDescription)
                    
                    //self.loadingView.hidden = true
                    
                    GTToast.create("Updating Failed")
                    
                }
                else
                {
                    print (result.items.count)
                    if (result.items.count>0)
                    {
                        self.currentUser = result.items as! [AnyObject]
                        
                        userDefaults.setObject(result.items[0].valueForKey("id") as! String, forKey: "azureId")
                        
                        
                        //                        let currentInstallation = PFInstallation.currentInstallation()
                        //                        currentInstallation.addUniqueObject("P-\(result.items[0].valueForKey("id") as! String)", forKey: "channels")
                        //                        currentInstallation.addUniqueObject("P-11263008", forKey: "channels")
                        //                        currentInstallation.saveInBackground()
                        //                        
                        //                        let subscribedChannels = PFInstallation.currentInstallation().channels
                        
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
                        //self.performSegueWithIdentifier("toHome", sender: self)
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
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
            
            GTToast.create("Updating Failed")
            
        }
        
        userDefaults.synchronize()
        
    }
    
    func uploadPhoto()
    {
        
        let myUrl = NSURL(string: url);
        
        var al = UIAlertView()
        
        al.title = "Please wait"
        al.message = "Uploading Image..."
        al.show()
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(userImage!, 0)
        
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
                pp = "https://exchangeappreview.azurewebsites.net/Spotlight/\(pp)"
                
                self.picUrl = pp
                
                print ("xyz: \(json)")
                
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
    
    
    @IBAction func uploadPictureAction(sender: UIButton) {
        
        //showPickInView()
        
        self.profilePictureAction(UIButton())
        
        //        if (userImage != nil)
        //        {
        //            uploadPhoto()
        //            self.uploadbtn.titleLabel?.textColor = UIColor.whiteColor()
        //        }
        
        
        
    }
    
    
    
    
    
}
