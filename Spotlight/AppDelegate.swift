//
//  AppDelegate.swift
//  Spotlight
//
//  Created by Aqib on 12/02/2016.
//  Copyright © 2016 Sofit. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Quickblox
import Parse
import Bolts
import GTToast
import Fabric
import Crashlytics
import Firebase
import FirebaseAnalytics



let kQBApplicationID:UInt = 5
let kQBAuthKey = "vRPMj3Tc-UZvVan"
let kQBAuthSecret = "RE2VfCJBxzXzrj8"
let kQBAccountKey = "UXYA8bBthmuaRzxk3Qkh"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var client = MSClient()
    var user:String!
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        
        
        
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 0)
        notification.alertBody = (userInfo["aps"] as! NSDictionary)["alert"] as! String
        notification.alertAction = "be awesome!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["CustomField1": "w00t"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        
        //PFPush.handlePush(userInfo)
        
        //print ("Notification Received: \(userInfo.first?.0)")
        
        //        if let notification = userInfo["aps"] as? NSDictionary,
        //            let alert = notification["alert"] as? String {
        //            var alertCtrl = UIAlertController(title: "Spotlight", message: alert as String, preferredStyle: UIAlertControllerStyle.Alert)
        //            alertCtrl.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        //            // Find the presented VC...
        //            var presentedVC = self.window?.rootViewController
        //            while (presentedVC!.presentedViewController != nil)  {
        //                presentedVC = presentedVC!.presentedViewController
        //            }
        //            presentedVC!.presentViewController(alertCtrl, animated: true, completion: nil)
        //            
        //            
        //            // call the completion handler
        //            // -- pass in NoData, since no new data was fetched from the server.
        //            completionHandler(UIBackgroundFetchResult.NoData)
        //        }
        
        
        
        //PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        
    }
    
    
    
    
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        NSNotificationCenter.defaultCenter().postNotificationName("TodoListShouldRefresh", object: self)
        
        
        
        
        if let userInfo = notification.userInfo {
            let customField1 = userInfo["CustomField1"] as! String
            print("didReceiveLocalNotification: \(customField1)")
        }
        
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        
        //        let userDefaults  = NSUserDefaults.standardUserDefaults()
        //        
        //        userDefaults.setBool(true, forKey: "notification")
        //        
        //        userDefaults.synchronize()
        
        
        // Store the deviceToken in the current Installation and save it to Parse
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.channels = ["global"]
        installation.addUniqueObject("global", forKey: "channels")
        
        installation.saveInBackground()
        
        
        let deviceIdentifier: String = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        let subscription: QBMSubscription! = QBMSubscription()
        
        //let a =
        
        subscription.notificationChannel = Quickblox.QBMNotificationChannelAPNS
        
        subscription.deviceUDID = deviceIdentifier
        subscription.deviceToken = deviceToken
        
        
        
        
        
        QBRequest.createSubscription(subscription, successBlock: { (response: QBResponse!, objects: [QBMSubscription]?) -> Void in
            
            print ("REGISTERED***")
            print (response.description)
            
        }) { (response: QBResponse!) -> Void in
            //
            
            print ("ERROR REG: *** \(response.error!.error!.localizedDescription)")
        }
        
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        
        print ("Something happened...")
        GTToast.create("Notification Received")
        
        
        scheduleLocal("test")
        NSLog("my push is: %@", userInfo)
        if (application.applicationState == UIApplicationState.Inactive || application.applicationState == UIApplicationState.Active || application.applicationState == UIApplicationState.Background) {
            let dialogID: String? = "Message"
            if application.applicationState == UIApplicationState.Inactive {
                let dialogID: String? = userInfo["aqib"] as? String
                if (!dialogID!.isEmpty && dialogID != nil) {
                    
                    scheduleLocal("aqibbangash")
                }
            }
        }
    }
    
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Set QuickBlox credentials (You must create application in admin.quickblox.com).
        
        Fabric.with([Crashlytics.self])
        
        
        if let options = launchOptions {
            if let notification = options[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
                if let userInfo = notification.userInfo {
                    let customField1 = userInfo["CustomField1"] as! String
                    print ("*Opened From Notifications")
                    // do something neat here
                    
                    
                    
                    //                   // var navController:UINavigationController = self.window?.rootViewController as! UINavigationController
                    //                    
                    //                    //if navController.viewControllers != nil {
                    //                        var vc:MessagesVC = navController.viewControllers[1] as! MessagesVC
                    //                        navController.presentViewController(vc, animated: false, completion: nil)
                    //                    //}
                    
                }else{
                    print ("*ELSE Opened From Notifications")
                }
            }
        }else{
            print ("*NOT Opened From Notifications")
        }
        
        Parse.setApplicationId("8kxaf8GGPh2oS3sN0drrQ0shs4kghppqbnnW6OSf", clientKey: "ivbeqFJJuwtMV721ioXiY96qL5KL4ZBxnraL4zMu")
        
        let userNotificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "8kxaf8GGPh2oS3sN0drrQ0shs4kghppqbnnW6OSf"
            $0.clientKey = "ivbeqFJJuwtMV721ioXiY96qL5KL4ZBxnraL4zMu"
        }
        Parse.initializeWithConfiguration(configuration)
        
        if let options = launchOptions {
            if let notification = options[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
                if let userInfo = notification.userInfo {
                    let customField1 = userInfo["CustomField1"] as! String
                    // do something neat here
                    
                    let userDefaults  = NSUserDefaults.standardUserDefaults()
                    
                    userDefaults.setBool(true, forKey: "notification")
                    
                    userDefaults.synchronize()
                    
                }
            }
        }
        
        
        
        PFPurchase.addObserverForProduct("spotlightVip") { (transaction) in
            
            print ("That happened.")
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setBool(true, forKey: "vip")
            userDefaults.synchronize()
            
            
        }
        
        QBSettings.setApiEndpoint("https://apispotlightrc.quickblox.com", chatEndpoint: "chatspotlightrc.quickblox.com", forServiceZone: QBConnectionZoneType(2))
        //QBSettings.setApiEndpoint("", chatEndpoint: "", forServiceZone: QBConnectionZoneType(2))
        
        
        var stun:QBRTCICEServer = QBRTCICEServer(URL:"stun:turn.quickblox.com", username: "quickblox", password: "baccb97ba2d92d71e26eb9886da5f1e0")
        var turnUDPUrl = NSURL(string: "turn:turn.quickblox.com:3478?transport=udp")
        
        var turnUDPServer:QBRTCICEServer = QBRTCICEServer(URL: "turn:turn.quickblox.com:3478?transport=udp", username: "quickblox", password: "baccb97ba2d92d71e26eb9886da5f1e0")
        
        var turnTCPServer:QBRTCICEServer = QBRTCICEServer(URL: "turn:turn.quickblox.com:3478?transport=tcp", username: "quickblox", password: "baccb97ba2d92d71e26eb9886da5f1e0")
        
        print ("* I*\(QBConnectionZoneType(2))")
        
        QBSettings.setServiceZone(QBConnectionZoneType(2))
        
        
        QBSettings.setApplicationID(kQBApplicationID)
        QBSettings.setAuthKey(kQBAuthKey)
        QBSettings.setAuthSecret(kQBAuthSecret)
        QBSettings.setAccountKey(kQBAccountKey)
        
        
        
        QBSettings.setLogLevel(.Debug)
        QBSettings.enableXMPPLogging()
        
        
        
        QBSettings.setAutoReconnectEnabled(true)
        QBSettings.setKeepAliveInterval(50)
        
        
        // Enables Quickblox REST API calls debug console output.
        QBSettings.setLogLevel(QBLogLevel.Debug)
        
        // Enables detailed XMPP logging in console output.
        QBSettings.enableXMPPLogging()
        
        QBSettings.setAutoReconnectEnabled(true);
        
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        if #available(iOS 8.0, *) {
            let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
            let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
            application.registerForRemoteNotificationTypes(types)
        }
        
        
        
        let expireyDate = NSDate(timeIntervalSinceNow: 30*60*1000)
        
        let session = QBASession()
        session.token = "abcdefghijklmno12345"
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        self.client = MSClient(
            applicationURLString:"https://spotlight.azure-mobile.net/",
            applicationKey:"nuHGNSZKlXSDRzlzsZFHFeIcWtPQgW72"
        )
        
        
        var userDetails = getCurrentUser()
        
        
        QBRequest.logInWithUserLogin(userDetails[0], password: userDetails[1], successBlock: { (response, user) -> Void in
            
            
            print ("***LOGGED IN REGISTERING")
            //self.registerForRemoteNotifications()
            
            
            
            
        }) { (error) -> Void in
            print ("***ERROR REGISTERING - LOGIN")
            print (error.error?.error?.localizedDescription)
        }
        
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                //PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        if #available(iOS 8.0, *) {
            let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
            let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
            print ("***local registered.")
            
        } else {
            let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
            application.registerForRemoteNotificationTypes(types)
        }
        
        //        
        //        QBRequest.sendPushWithText("HELLOOOO", toUsers: "11145289,11145312", successBlock: { (respinse, event) in
        //            
        //            
        //            print ("* *Sent")
        //            
        //            }) { (error) in
        //            
        //                
        //                print ("error sending")
        //        }
        //        
        
        
        FIRApp.configure()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    
    func registerForRemoteNotifications(){
        
        
        let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let remoteTypes: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
        
        
        if (UIApplication.sharedApplication().respondsToSelector("registerUserNotificationSettings"))
        {
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: types, categories: nil))
            UIApplication.sharedApplication().registerForRemoteNotifications()
            print ("registerForRemoteNotifications IF BODY")
            
        }
        else
        {
            UIApplication.sharedApplication().registerForRemoteNotificationTypes(remoteTypes)
            print ("registerForRemoteNotifications ELSE BODY")
        }
        
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        QBChat.instance().disconnectWithCompletionBlock { (error: NSError?) -> Void in
            
            GTToast.create("Chat Disconnedted").show();
        }
        
    }
    
    func getCurrentUser() -> [String]{
        
        var usern = ""
        var pass = ""
        
        
        if let login: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("user") {
            
            usern = login as! String
        }
        
        if let login: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("pass") {
            
            pass = login as! String
        }
        
        return [usern, pass]
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        var m = QBUUser()
        m.login = getCurrentUser()[0]
        m.password = getCurrentUser()[1]
        
        QBChat.instance().connectWithUser(m) { (error: NSError?) -> Void in
            
            if (error == nil)
            {
                
                GTToast.create("Reconnecting...").show();
            }
            else
            {
                GTToast.create("Error: \(error?.localizedDescription)").show();
                
            }
            
        }
        
    }
    
    func scheduleLocal(sender: AnyObject) {
        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if settings!.types == .None {
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            //presentViewController(ac, animated: true, completion: nil)
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
    
    
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        application.applicationIconBadgeNumber = 0;
        
        NSNotificationCenter.defaultCenter().postNotificationName("TodoListShouldRefresh", object: self)
        
        FBSDKAppEvents.activateApp()
    }
    
    
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // ServicesManager.instance().chatService.disconnectWithCompletionBlock(nil)
        
        //deleteRequestsFor()
        
        deleteRoomsFor()
        
        QBChat.instance().disconnectWithCompletionBlock { (error: NSError?) -> Void in
            
        }
    }
    
    func deleteRequestsFor()
    {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("Request")
        
        
        itemTable.delete(["user_id":user]) { (obj, error) -> Void in
            
            
        }
    }
    
    func deleteRoomsFor()
    {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("ChatRoom")
        
        
        itemTable.delete(["person1":user]) { (obj, error) -> Void in
            
            
        }
    }
    
    
}

