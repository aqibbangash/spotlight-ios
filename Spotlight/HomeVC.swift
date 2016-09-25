//
//  HomeVC.swift
//  Spotlight
//
//  Created by Aqib on 13/02/2016.
//  Copyright © 2016 Sofit. All rights reserved.
//

import UIKit
import Quickblox
//import GoogleMobileAds
import Alamofire
import GTToast
import CTShowcase
//import GoogleMobileAds
import Firebase
import FirebaseAnalytics

extension String {
    
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class HomeVC: UIViewController {
    
    
    var token: dispatch_once_t = 0
    
    
    @IBOutlet weak var updateInfoView: UIView!
    @IBOutlet weak var lockPrefs: UIImageView!
    @IBOutlet weak var videoBg: LoopingVideoView!
    var userId:String!
    var requestId:String!
    @IBOutlet weak var topDistance: NSLayoutConstraint!
    var profileP = ""
    @IBOutlet weak var loopingVideo: LoopingVideoView!
    @IBOutlet weak var ad: GADBannerView!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var bothButton: UIButton!
    @IBOutlet weak var preferenceDialog: UIView!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    var currentUser:[AnyObject]!
    var friendsString = ""
    var allF:[NSDictionary]!
    var url = "https://spotlight.azure-mobile.net/api"
    
    @IBAction func openFriendsList(sender: UIButton) {
        
        if (!isAnon(true))
        {
            self.performSegueWithIdentifier("toFriendslist", sender: self)
            menuButtonPress(UIButton())
            
        }else{
            GTToast.create("You need to add you information first.").show()
        }
        
    }
    
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
    
    @IBAction func openAccount(sender: UIButton) {
        
        self.performSegueWithIdentifier("toAccount", sender: self)
        menuButtonPress(UIButton())
        
    }
    
    @IBAction func updateNo(sender: UIButton) {
        
        self.updateInfoView.fadeOut()
        
    }
    
    @IBAction func updateYes(sender: UIButton) {
        
        self.updateInfoView.fadeOut()
        self.performSegueWithIdentifier("updateInfo", sender: self)
        
    }
    @IBOutlet weak var lockMessages: UIImageView!
    @IBOutlet weak var lockFriends: UIImageView!
    @IBOutlet weak var bgPrefs: UIView!
    @IBOutlet weak var t2: UIButton!
    @IBOutlet weak var t1: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBAction func openYoutubee(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.instagram.com/spotlightrc/")!)
        // menuButtonPress(UIButton())
    }
    @IBAction func openTwitter(sender: AnyObject) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/SpotlightRC")!)
        //menuButtonPress(UIButton())
    }
    @IBAction func openMessages(sender: UIButton) {
        
        if (!isAnon(true))
        {
            self.performSegueWithIdentifier("toMessages", sender: self)
            menuButtonPress(UIButton())
            
        }else{
            GTToast.create("You need to add you information first.").show()
        }
    }
    @IBAction func openFacebook(sender: AnyObject) {
        
        
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/spotlightrc")!)
        
    }
    
    @IBOutlet weak var optionsBtnsView: UIView!
    
    
    func menuButtonOpen()
    {
        if (topDistance.constant == -100)
        {
            
            self.topDistance.constant = 0
            
            self.optionsBtnsView.fadeIn()
            
            
            UIView.animateWithDuration(10, animations: {
                
                
                
                }, completion: { finished in
                    //print("menu open")
            })
            
            
        }
    }
    
    
    func menuButtonClose()
    {
        if (topDistance.constant == 0)
        {
            
            self.topDistance.constant = -100
            
            self.optionsBtnsView.fadeOut()
            
            
            UIView.animateWithDuration(1000, animations: {
                
                
                
                }, completion: { finished in
                    //print("menu closed")
            })
            
        }
    }
    
    
    @IBAction func menuButtonPress(sender: AnyObject) {
        
        if (topDistance.constant == -100)
        {
            
            self.topDistance.constant = 0
            
            self.optionsBtnsView.fadeIn()
            
            
            UIView.animateWithDuration(10, animations: {
                
                
                
                }, completion: { finished in
                    //print("menu open")
            })
            
            
        }
        else
        {
            
            self.topDistance.constant = -100
            
            self.optionsBtnsView.fadeOut()
            
            
            UIView.animateWithDuration(1000, animations: {
                
                
                
                }, completion: { finished in
                    //print("menu closed")
            })
            
        }
        
    }
    
    @IBOutlet weak var videoooo: LoopingVideoView!
    @IBOutlet weak var loadingView: UIView!
    override func viewDidAppear(animated: Bool) {
        
        
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("totalCalls") {
            
            if (username as! Int == 100)
            {
                self.showRatingView()
            }
            
        }
        
        
        deleteAllShit()
        
        // self.videoooo.
        
        setCurrentPref()
        
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("vip") {
            
            if (!(username as! Bool))
            {
                var rand = (random() % 4)
                if (rand == 1)
                {
                    //print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
                    
                    ad.adUnitID = "ca-app-pub-2891096036722966/5826607539"
                    ad.rootViewController = self
                    ad.loadRequest(GADRequest())
                    
                }
                else{
                    //print ("Random: \(rand)")
                }
            }
            else{
                //print ("This is a pro user")
            }
            
        }
        
        self.getAllFriendsAzure()
        
        
        
        if AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) ==  AVAuthorizationStatus.Authorized
        {
            // Already Authorized
            //print ("***Authorised")
        }
        else
        {
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (granted :Bool) -> Void in
                if granted == true
                {
                    // User granted
                    //print ("***Granted")
                }
                else
                {
                    
                    GTToast.create("Please Provide Camera Permission From Settings>Spotlight").show()
                    // User Rejected
                    //print ("***Rejected")
                }
            });
        }
        
        
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if allowed {
                        //print ("Mic Allowed")
                        //self.loadRecordingUI()
                    } else {
                        GTToast.create("Provide Microphone Permission From Settings>Spotlight").show()
                        //print ("Mic NOT Allowed")
                        //self.loadFailUI()
                    }
                }
            }
        } catch {
            // self.loadFailUI()
        }
        
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("profile_pic") {
            
            self.profileP = username as! String
            
        }
        else{
            if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("gender")
            {
                
                var thisUserGender  = username as! String
                
                if (thisUserGender == "M")
                {
                    self.profileP = "https://spotlight.azure-mobile.net/api/profilePictures/default-male.png"
                }
                else
                {
                    self.profileP = "https://spotlight.azure-mobile.net/api/profilePictures/default-female.png"
                }
            }
        }
        
        if (isAnon(false))
        {
            self.lockPrefs.hidden = false
            self.lockFriends.hidden = false
            self.lockMessages.hidden = false
        }
        else
        {
            self.lockPrefs.hidden = true
            self.lockFriends.hidden = true
            self.lockMessages.hidden = true
        }
        
        
        
    }
    
    func getAllFriendsAzure()
    {
        
        var params  = ["user_id": "\(self.userId)"]
        var apiCall = "\(self.url)/getFriends"
        
        
        //print ("ApiCall: \(apiCall)")
        //print ("Params: \(params)")
        
        
        Alamofire.request(.POST, apiCall, parameters: params).responseJSON { (response) in
            
            
            
            if (response.result.error == nil)
            {
                ////print (response.result.value)
                var json  = response.result.value as? [NSDictionary]
                
                
                if (json != nil)
                {
                    //print ("json: \(json!)")
                    self.allF = json!
                    
                    
                    
                    for c in json!{
                        
                        self.friendsString += "\(c.valueForKey("id") as! String),"
                    }
                    
                    
                    //self.getAllDialog1()
                    
                }
                
                
                
                
                //let status =  json?.valueForKey("status") as! Int
                
                
            }
            
        }
    }
    
    var count  = 0
    
    func getAllDialog1()
    {
        self.count  = 0
        //print ("Requesting all dialogs...")
        
        let extendedRequest = [self.friendsString : "_id[in]"]
        
        let page = QBResponsePage(limit: 100, skip: 0)
        
        QBRequest.dialogsForPage(page, extendedRequest: extendedRequest, successBlock: { (response: QBResponse, dialogs: [QBChatDialog]?, dialogsUsersIDs: Set<NSNumber>?, page: QBResponsePage?) -> Void in
            
            //print ("Dialogs count: \(dialogs?.count)")
            
            if (dialogs != nil)
            {
                for x in dialogs!{
                    
                    self.count += Int(x.unreadMessagesCount)
                    
                }
                if (self.count<1)
                {
                    self.t1.setBadgeHidden(true)
                    self.t2.setBadgeHidden(true)
                }
                else
                {
                    self.t1.setBadgeHidden(false)
                    
                    self.t2.setBadgeHidden(false)
                }
                
                //self.menuButton.setBadgeStyle(BadgeStyle.Point(CGSizeMake(10, 10)))
                self.t1.setBadgeStyle(BadgeStyle.Number(UInt(self.count))
                )
                
                self.t2.setBadgeStyle(BadgeStyle.Number(UInt(self.count))
                )
                
                
                //self.getAllDialog1()
                
                
                
            }
            
            //self.tableView.reloadData()
            
            //self.filteFriendsrDialogs()
            
        }) { (response: QBResponse) -> Void in
            
            //print("Error Response: \(response)")
            
        }
    }
    
    @IBOutlet weak var loopingVideo2: LoopingVideoView!
    @IBOutlet weak var openMessagesBtn: UIButton!
    @IBOutlet weak var loadingImage: UIImageView!
    
    @IBAction func openWebsite(sender: UIButton) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.spotlightrc.com")!)
        //menuButtonPress(UIButton())
        
    }
    
    func videoTwo()
    {
        //        self.loopingVideo2 = LoopingVideoView(frame: self.loopingVideo.frame)
        
        //self.loopingVideo2 = LoopingVideo();
        
        //self.loopingVideo2.mainBundleFileName = "Page 1_loop_long_1.mp4"
        
        self.loopingVideo2.hidden = false
        self.loopingVideo2.playCount = 1
        self.loopingVideo.hidden = true
        //print ("Video 2")
        
        
        self.loopingVideo2.hidden = false
        
        
        // NSTimer.scheduledTimerWithTimeInterval(7, target: self, selector: "videoThree", userInfo: nil, repeats: false)
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.cancelPrefs(UIButton())
        self.updateInfoView.fadeOut()
    }
    
    @IBOutlet weak var tChat: UIButton!
    
    
    
    func setupAllShowcases()
    {
        
        
        
        
        
    }
    @IBOutlet weak var vChat: UIButton!
    @IBOutlet weak var prefs: UIButton!
    @IBOutlet weak var accnt: UIButton!
    @IBOutlet weak var friends: UIButton!
    @IBOutlet weak var messages: UIButton!
    
    func videoThree()
    {
        self.loopingVideo2.hidden = true
        //print ("Video 3")
        self.loopingVideo3.mainBundleFileName = "Page 1_loop_short_1.mp4"
        self.loopingVideo3.hidden = false
    }
    
    @IBOutlet weak var loopingVideo3: LoopingVideoView!
    
    @IBOutlet weak var bgupdate: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateDialogView.layer.shadowOpacity = 0.9
        
        self.updateDialogView.layer.shadowRadius = 7.0
        
        self.updateDialogView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        
        self.prefsD.layer.shadowOpacity = 0.9
        
        self.prefsD.layer.shadowRadius = 7.0
        
        self.prefsD.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        
        
        
        self.loopingVideo.mainBundleFileName = "Page 1_intro_1.mp4"
        self.loopingVideo.playCount = 1
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        bgPrefs.addGestureRecognizer(tap)
        bgupdate.addGestureRecognizer(tap)
        
        //print ("Video 1")
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "videoTwo", userInfo: nil, repeats: false)
        
        UIView.setAnimationsEnabled(true)
        
        //        let jeremyGif = UIImage.gifWithName("Spinner (1)")
        //        
        //        loadingImage.image = jeremyGif
        
        
        NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "getAllDialog", userInfo: nil, repeats: false)
        
        
        setCurrentPref()
        
        getAllDialog()
        
        
        
        NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "getAllDialog1", userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
        
        self.setupAllShowcases()
    }
    
    @IBAction func howTo(sender: UIButton) {
        
        //menuButtonPress(UIButton())
        menuButtonOpen()
        let highlighter = CTDynamicGlowHighlighter()
        highlighter.highlightColor = UIColor.whiteColor()
        highlighter.animDuration = 0.5
        highlighter.glowSize = 5
        highlighter.maxOffset = 10
        
        var showcase:CTShowcaseView!
        var showcase1:CTShowcaseView!
        var showcase2:CTShowcaseView!
        var showcase3:CTShowcaseView!
        var showcase4:CTShowcaseView!
        var showcase5:CTShowcaseView!
        var showcase6:CTShowcaseView!
        
        
        
        showcase = CTShowcaseView(withTitle: "Text Chat", message: "Text Chat with Random People", key: nil) { () -> Void in
            //print("dismissed")
            
            
            showcase1.setupShowcaseForView(self.vChat, offset: CGPointZero, margin: 0)
            showcase1.show()
            
            
        }
        
        showcase1 = CTShowcaseView(withTitle: "Video Chat", message: "Video Chat with Random People", key: nil) { () -> Void in
            //print("dismissed")
            
            
            showcase2.setupShowcaseForView(self.prefs, offset: CGPointZero, margin: 0)
            showcase2.show()
        }
        
        
        showcase2 = CTShowcaseView(withTitle: "Preferences", message: "Change your preferences ", key: nil) { () -> Void in
            //print("dismissed")
            
            
            showcase3.setupShowcaseForView(self.menuButton, offset: CGPointZero, margin: 0)
            showcase3.show()
        }
        
        showcase3 = CTShowcaseView(withTitle: "Toggle Menu", message: "Click here to slide down the menu", key: nil) { () -> Void in
            //print("dismissed")
            
            showcase4.setupShowcaseForView(self.friends, offset: CGPointZero, margin: 0)
            showcase4.show()
        }
        
        showcase4 = CTShowcaseView(withTitle: "Friendslist", message: "All your friends can be found here", key: nil) { () -> Void in
            //print("dismissed")
            
            
            showcase5.setupShowcaseForView(self.accnt, offset: CGPointZero, margin: 0)
            showcase5.show()
        }
        
        showcase5 = CTShowcaseView(withTitle: "Account", message: "View/Update Account Settings here", key: nil) { () -> Void in
            //print("dismissed")
            
            
            showcase6.setupShowcaseForView(self.messages, offset: CGPointZero, margin: 0)
            showcase6.show()
        }
        
        showcase6 = CTShowcaseView(withTitle: "Messages", message: "Your conversations are stored here", key: nil) { () -> Void in
            //print("dismissed")
            
            self.menuButtonClose()
            
            
        }
        
        
        
        
        
        showcase.highlighter = highlighter
        
        showcase1.highlighter = highlighter
        
        showcase2.highlighter = highlighter
        
        showcase3.highlighter = highlighter
        
        showcase4.highlighter = highlighter
        
        showcase5.highlighter = highlighter
        
        showcase6.highlighter = highlighter
        
        
        
        
        
        showcase.setupShowcaseForView(self.tChat, offset: CGPointZero, margin: 0)
        showcase.show()
        
        
    }
    
    
    func deleteAllShit()
    {
        if (userId != nil)
        {
            var params = [ "user_id": userId ]
            Alamofire.request(.POST, "https://spotlight.azure-mobile.net/api/delete_request", parameters: params).responseJSON(completionHandler: { (Res) in
                
                if (Res.result.error != nil)
                {
                    print ("Error: \(Res.result)")
                    
                }
                else
                {
                    print ("Error: \(Res.result)")
                }
                
            })
        }
    }
    
    func getAllDialog()
    {
        
        
        var params = ["userId" : "\(self.userId)"]
        
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let item = params
        let itemTable = client.tableWithName("online")
        
        
        itemTable.insert(item){
            (insertedItem, error) in
            
            if (error != nil)
            {
                //print ("Network: \(error.localizedDescription)")
                GTToast.create("Network Error")
            }
            else
            {
                //print ("Marked Online")
                
                
                if let anon: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("login_status") {
                    
                    if (anon as! Bool)
                    {
                        
                        NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "getAllDialog", userInfo: nil, repeats: false)
                    }
                }
            }
            
        }
        
        
    }
    
    @IBOutlet weak var prefsD: UIView!
    @IBAction func noRate(sender: UIButton) {
        
        self.ratingView.hidden = true
    }
    
    @IBAction func rateBtnPressed(sender: UIButton) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "itms://itunes.apple.com/de/app/1030986145")!)
        self.ratingView.hidden = true
        
    }
    
    @IBOutlet weak var updateDialogView: UIView!
    
    func showRatingView()
    {
        
        self.ratingView.hidden = false
    }
    
    @IBOutlet weak var ratingView: UIView!
    func setCurrentPref()
    {
        
        
        
        var p = ""
        
        
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("prefs") {
            p = username as! String
        }
        
        //print ("*Current Prefs: \(p)")
        
        if (p == "M")
        {
            
            self.maleButton.titleLabel?.textColor = UIColor.whiteColor()
            self.femaleButton.titleLabel?.textColor = UIColor(netHex:0x01deff)
            self.bothButton.titleLabel?.textColor = UIColor(netHex:0x01deff)
            
        }
        else if (p == "F")
        {
            self.maleButton.titleLabel?.textColor = UIColor(netHex:0x01deff)
            self.femaleButton.titleLabel?.textColor = UIColor.whiteColor()
            self.bothButton.titleLabel?.textColor = UIColor(netHex:0x01deff)
        }else
        {
            self.maleButton.titleLabel?.textColor = UIColor(netHex:0x01deff)
            self.femaleButton.titleLabel?.textColor = UIColor(netHex:0x01deff)
            self.bothButton.titleLabel?.textColor = UIColor.whiteColor()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textChat(sender: UIButton) {
        
        self.performSegueWithIdentifier("direct", sender: self)
        //makeTextChatRequest()
        
        //        var timer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "makeTextChatRequest", userInfo: nil, repeats: true)
        
    }
    
    func makeTextChatRequest()
    {
        var params = ["user_id":userId!, "completed":"false", "type": "text"]
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let item = params
        let itemTable = client.tableWithName("Request")
        
        
        itemTable.insert(item){
            (insertedItem, error) in
            
            if (error != nil)
            {
                
            }
            else
            {
                
                //print ("Created request!")
                var iid = "\(insertedItem.first!.1 as! String)"
                
                
                self.requestId = iid
                
                //print (self.requestId)
                self.performSegueWithIdentifier("direct", sender: self)
            }
            
        }
        
        
    }
    
    
    func makeVideoChatRequest()
    {
        var params = ["user_id":userId!, "completed":"false", "type": "video"]
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let item = params
        let itemTable = client.tableWithName("Request")
        
        
        itemTable.insert(item){
            (insertedItem, error) in
            
            if (error != nil)
            {
                
            }
            else
            {
                
                //print ("Created request!")
                var iid = "\(insertedItem.first!.1 as! String)"
                
                
                self.requestId = iid
                
                //print (self.requestId)
                self.performSegueWithIdentifier("toVideoChat", sender: self)
            }
            
        }
        
        
    }
    
    
    @IBAction func videoChat(sender: UIButton) {
        
        self.performSegueWithIdentifier("videoConvo", sender: self)
        //makeVideoChatRequest()
        
        
    }
    
    @IBAction func bothPrefs(sender: UIButton) {
        var prefs = "MFA"
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("Users")
        
        GTToast.create("Updating...").show()
        
        var params = ["first_name":self.currentUser[0].valueForKey("first_name") as! String,
                      "last_name":self.currentUser[0].valueForKey("last_name") as! String,
                      "gender":self.currentUser[0].valueForKey("gender") as! String,
                      "country":self.currentUser[0].valueForKey("country") as! String,
                      "city":self.currentUser[0].valueForKey("city") as! String,
                      "age":self.currentUser[0].valueForKey("age") as! String,
                      "quickblox_id":self.currentUser[0].valueForKey("quickblox_id") as! String,
                      "id":self.currentUser[0].valueForKey("id") as! String,
                      "profile_pic":self.profileP,
                      "email":self.currentUser[0].valueForKey("email") as! String,
                      "password":self.currentUser[0].valueForKey("password") as! String,
                      "points":"100",
                      "prefs":prefs
            
        ]
        
        itemTable.update(params, completion: { (obj, error) -> Void in
            if (error == nil)
            {
                
                self.bothButton.titleLabel?.textColor = UIColor.whiteColor()
                self.maleButton.titleLabel?.textColor = UIColor(netHex:0x01deff)
                self.femaleButton.titleLabel?.textColor = UIColor(netHex:0x01deff)
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(prefs, forKey: "prefs")
                userDefaults.synchronize()
                
                GTToast.create("Your preferences has been updated").show()
                
                //self.preferenceDialog.hidden = true
                self.preferenceDialog.fadeOut()
            }else
            {
                //print ("error: \(error.localizedDescription)")
            }
            
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(prefs, forKey: "prefs")
            userDefaults.synchronize()
            
        });
        
    }
    
    
    @IBAction func maleFrefs(sender: UIButton) {
        var prefs = "M"
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("Users")
        
        
        GTToast.create("Updating...").show()
        
        var params = ["first_name":self.currentUser[0].valueForKey("first_name") as! String,
                      "last_name":self.currentUser[0].valueForKey("last_name") as! String,
                      "gender":self.currentUser[0].valueForKey("gender") as! String,
                      "country":self.currentUser[0].valueForKey("country") as! String,
                      "city":self.currentUser[0].valueForKey("city") as! String,
                      "age":self.currentUser[0].valueForKey("age") as! String,
                      "quickblox_id":self.currentUser[0].valueForKey("quickblox_id") as! String,
                      "id":self.currentUser[0].valueForKey("id") as! String,
                      "profile_pic":self.profileP,
                      "email":self.currentUser[0].valueForKey("email") as! String,
                      "password":self.currentUser[0].valueForKey("password") as! String,
                      "points":"100",
                      "prefs":prefs
            
        ]
        
        itemTable.update(params, completion: { (obj, error) -> Void in
            if (error == nil)
            {
                self.maleButton.titleLabel?.textColor = UIColor.whiteColor()
                self.femaleButton.titleLabel?.textColor = UIColor(netHex:0x01deff)
                self.bothButton.titleLabel?.textColor = UIColor(netHex:0x01deff)
                //self.preferenceDialog.hidden = true
                self.preferenceDialog.fadeOut()
                GTToast.create("Your preferences has been updated").show()
                
            }else
            {
                //print ("error: \(error.localizedDescription)")
            }
            
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(prefs, forKey: "prefs")
            userDefaults.synchronize()
            
            
        });
        
    }
    
    @IBAction func femaleFrefs(sender: UIButton) {
        var prefs = "F"
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("Users")
        
        
        GTToast.create("Updating...").show()
        
        var params = ["first_name":self.currentUser[0].valueForKey("first_name") as! String,
                      "last_name":self.currentUser[0].valueForKey("last_name") as! String,
                      "gender":self.currentUser[0].valueForKey("gender") as! String,
                      "country":self.currentUser[0].valueForKey("country") as! String,
                      "city":self.currentUser[0].valueForKey("city") as! String,
                      "age":self.currentUser[0].valueForKey("age") as! String,
                      "quickblox_id":self.currentUser[0].valueForKey("quickblox_id") as! String,
                      "id":self.currentUser[0].valueForKey("id") as! String,
                      "profile_pic":self.profileP,
                      "email":self.currentUser[0].valueForKey("email") as! String,
                      "password":self.currentUser[0].valueForKey("password") as! String,
                      "points":"100",
                      "prefs":prefs
            
        ]
        
        itemTable.update(params, completion: { (obj, error) -> Void in
            if (error == nil)
            {
                self.femaleButton.titleLabel?.textColor = UIColor.whiteColor()
                self.maleButton.titleLabel?.textColor = UIColor(netHex:0x01deff)
                self.bothButton.titleLabel?.textColor = UIColor(netHex:0x01deff)
                
                //self.preferenceDialog.hidden = true
                self.preferenceDialog.fadeOut()
                GTToast.create("Your preferences has been updated").show()
                
            }
            else
            {
                //print ("error: \(error.localizedDescription)")
            }
            
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(prefs, forKey: "prefs")
            userDefaults.synchronize()
            
        });
    }
    
    
    @IBAction func cancelPrefs(sender: UIButton) {
        //self.preferenceDialog.hidden = true
        self.preferenceDialog.fadeOut()
    }
    
    
    @IBAction func changePreferences(sender: UIButton) {
        //self.preferenceDialog.hidden = false
        if (!isAnon(true))
        {
            self.preferenceDialog.fadeIn()
        }
        else
        {
            GTToast.create("You need to add you information first.")//.show()
        }
        
        
        
    }
    
    func printTimestamp() -> String {
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        return (timestamp)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        var baseIntA = Int(arc4random() % 65535)
        var baseIntB = Int(arc4random() % 65535)
        var str = String(format: "%06X%06X", baseIntA, baseIntB)
        
        
        if (segue.identifier == "direct")
        {
            let nav = segue.destinationViewController as! UINavigationController
            
            //print ("Self Req id: \(self.requestId)")
            let vc = nav.topViewController as! ChatDialogInfoVC
            vc.typeOfConvo = "text"
            vc.uniqueId = "text-\(str)"
            var params = ["session": "text-\(str)", "user":"\(self.userId)", "time": printTimestamp(), "type":"start"]
            FIRAnalytics.logEventWithName("textSearch", parameters: params)
            //print ("Self Req id: \(self.requestId)")
            //print ("Sent Req id: \(vc.requestId)")
            
        }
        
        if (segue.identifier == "videoConvo")
        {
            let nav = segue.destinationViewController as! UINavigationController
            
            //print ("Self Req id: \(self.requestId)")
            let vc = nav.topViewController as! ChatDialogInfoVC
            vc.typeOfConvo = "video"
            vc.uniqueId = "video-\(str)"
            var params = ["session": "video-\(str)", "user":"\(self.userId)", "time": printTimestamp(), "type":"start"]
            FIRAnalytics.logEventWithName("videoSearch", parameters: params)
            //print ("Self Req id: \(self.requestId)")
            //print ("Sent Req id: \(vc.requestId)")
            
        }
        
        
        if (segue.identifier == "toFriendslist")
        {
            let nav = segue.destinationViewController as! UINavigationController
            let vc = nav.topViewController as! FriendsVC
            vc.myName = "\(self.currentUser[0].valueForKey("first_name") as! String) \(self.currentUser[0].valueForKey("last_name") as! String)"
        }
    }
    
}
