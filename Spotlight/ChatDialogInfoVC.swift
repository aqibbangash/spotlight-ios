//
//  DialogInfoVC.swift
//  Spotlight
//
//  Created by Aqib on 23/02/2016.
//  Copyright © 2016 Sofit. All rights reserved.
//

import UIKit
import Quickblox
import Alamofire
import GTToast
//import GoogleMobileAds
import FirebaseAnalytics
import Firebase

class ChatDialogInfoVC: UIViewController, QBChatDelegate, QBRTCClientDelegate, UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var uniqueId:String!
    var typeOfConvo:String!
    var json:NSDictionary!
    var personNumber = 0
    var connectedTimeInSeconds = 0
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var userInfoLocation: UILabel!
    @IBOutlet weak var userInfoAge: UILabel!
    @IBOutlet weak var userInfrogenderImage: UIImageView!
    @IBOutlet weak var userInfoGender: UILabel!
    @IBOutlet weak var userInfoName: UILabel!
    @IBOutlet weak var userInfroProVIPImage: UIImageView!
    @IBOutlet weak var userInfroProImage: PASImageView!
    @IBOutlet weak var userInfroProView: UIView!
    @IBOutlet weak var userInfoImage: PASImageView!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var callReceivedName: UILabel!
    @IBOutlet weak var friendRequestName: UILabel!
    @IBOutlet weak var friendRequestImage: UIImageView!
    @IBOutlet weak var callReceivedView: UIView!
    @IBOutlet weak var friendRequestView: UIView!
    @IBOutlet weak var initializingView: UIView!
    @IBOutlet weak var videoViewCustomToolbar: UIView!
    @IBOutlet weak var myVideo: UIView!
    @IBOutlet weak var otherPersonVideo: QBRTCRemoteVideoView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var customToolbar: UIView!
    @IBOutlet weak var chatScrollView: UIScrollView!
    @IBOutlet weak var connectionStatus: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var connectedToPerson: UILabel!
    @IBOutlet weak var connectionTime: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var url = "https://exchangeappreview.azurewebsites.net/Spotlight"
    @IBOutlet weak var addFriendButton: UIButton!
    
    var userId:UInt!
    var gender:String!
    var prefs:String!
    var allUsers:String = ""
    var moreFilteredUsers:[AnyObject]!
    var name:String = ""
    var userPassword = ""
    
    var connected = false
    var continueState = true
    var blocks = ""
    
    var myImage = ""
    var hisImage = ""
    
    let imagePicker = UIImagePickerController()
    
    var session:QBRTCSession!
    var videoCapture:QBRTCCameraCapture!
    
    var allDOne = 0
    var thisUserName:String = ""
    var thisUserAge:String = ""
    var thisUserCity:String = ""
    var thisUserCountry:String = ""
    var thisUserPic:String = ""
    var thisUserGender:String = ""
    var thisUserPro:Bool = false
    var currentConnectedUser = ""
    
    var requestId = ""
    var mineStartingX:CGFloat = 30
    var oppStartingX:CGFloat = 30
    var startingY:CGFloat = 10
    
    var allImagesUrls:[String] = []
    
    var videoFormat:QBRTCVideoFormat!
    
    var currentChatDialog: QBChatDialog!
    var capture:QBRTCVideoCapture!
    
    override func viewDidDisappear(animated: Bool) {
        
    }
    
    func showAdds()
    {
        
        if (self.interstitial.isReady)
        {
            self.interstitial.presentFromRootViewController(self)
        }
        else
        {
            //print ("***ad not ready.")
        }
    }
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-2891096036722966/7303340733")
        
        let request = GADRequest()
        
        interstitial.loadRequest(request)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        self.makeRound.layer.cornerRadius = 10.0
        
        self.messageTextField.delegate = self
        
        getUserDetails()
        
        
        QBSettings.setAutoReconnectEnabled(true);
        
        //QBRTCClient.instance().addDelegate(self)
        
    }
    
    
    
    override func pressesChanged(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        
        //print ("pressesChanged: \(presses.first?.type)")
        if ("\(presses.first?.type)" == "unavailable")
        {
            //print ("Left Chat")
            
        }
        
    }
    
    func sendMsg(message:QBChatMessage, img:UIImage)
    {
        let params : NSMutableDictionary = NSMutableDictionary()
        params["save_to_history"] = true
        message.customParameters = params
        
        self.currentChatDialog.sendMessage(message, completionBlock: { (error: NSError?) -> Void in
            
            if (error == nil)
            {
                //print ("message sent")
                
                var privateUrl: String = QBCBlob.privateUrlForID(UInt(message.attachments![0].ID!)!)!
                
                
                self.messageTextField.text = ""
                var chatBubbleData = ChatBubbleData(text: "Image Sent", link: privateUrl, date: NSDate(), type: BubbleDataType.Mine)
                
                var chatBubble = ChatBubble(data: chatBubbleData, startX:self.mineStartingX, startY: self.startingY)
                
                
                var pic = PASImageView(frame: CGRect(x: Int(self.view.frame.width-50) , y: Int(self.startingY)-10, width: 40, height: 40))
                
                pic.backgroundColor = UIColor.clearColor()
                
                pic.progressColor = UIColor.clearColor()
                
                pic.imageURL(NSURL(string: self.myImage)!)
                
                
                self.startingY += chatBubble.layer.frame.height + 30
                
                self.chatScrollView.contentSize = CGSizeMake(self.view.frame.width, self.startingY)
                
                chatBubble.tag = self.allImagesUrls.count
                
                
                let imageTap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
                
                chatBubble.addGestureRecognizer(imageTap)
                
                self.allImagesUrls.append(privateUrl)
                
                self.chatScrollView.addSubview(chatBubble)
                
                self.chatScrollView.addSubview(pic)
                
                self.scrollToBottom()
                
                
                //                let push = PFPush()
                //                push.setChannel("P-\(self.currentConnectedUser)")
                //                
                //                push.setMessage("You have received a message.")
                //                push.sendPushInBackground()
                
                //                QBRequest.sendPushWithText("You Received a message", toUsers: "\(self.currentConnectedUser)", successBlock: { (response, event) in
                //
                //                    //print ("push sent to \(self.currentConnectedUser)")
                //
                //
                //
                //                    }, errorBlock: { (error) in
                //
                //                        //print ("Error sending  to \(self.currentConnectedUser)")
                //
                //                })
                
                
            }
            else
            {
                //print ("message NOT sent")
                self.connectionStatus.text = "Sending Failded. Please Retry!"
            }
            
        });
        
        
    }
    
    
    func sendImage(img:UIImage)
    {
        
        self.connectionStatus.text = "Uploading Image"
        
        self.loadingView.hidden = false
        
        var imageData = UIImageJPEGRepresentation(img, 5)
        
        
        QBRequest.TUploadFile(imageData!, fileName: "\(userId)-\(NSDate(timeIntervalSinceNow: 0))", contentType: "image/jpg", isPublic: false, successBlock: { (response:QBResponse, block:QBCBlob) -> Void in
            
            self.connectionStatus.text = "****Done Uploading..."
            
            self.loadingView.hidden = true
            
            var message: QBChatMessage = QBChatMessage()
            
            var uploadedFileID: UInt = block.ID
            var attachment: QBChatAttachment = QBChatAttachment()
            attachment.type = "image"
            attachment.ID = String(uploadedFileID)
            message.attachments = [attachment]
            
            self.sendMsg(message, img: img)
            
            }, statusBlock: { (block) -> Void in
                
                //print ("***desc \(block.1!.percentOfCompletion*100)")
                self.connectionStatus.text = "Uploading: \(Int(block.1!.percentOfCompletion*100))/100%"
                
        }) { (resp) -> Void in
            
            //print ("***error: \(resp)")
            
            
        }
        
        //        QBRequest.TUploadFile(imageData!, fileName: "\(userId)-\(NSDate(timeIntervalSinceNow: 0))", contentType: "image/jpg", isPublic: false, successBlock: { (res:QBResponse, blob:QBCBlob) -> Void in
        //
        //
        //            //request: QBRequest?, status: QBRequestStatus?
        //
        //            }, statusBlock: { (block) -> Void in
        //
        //            self.loadingMessage.text = "Uploading Image: \(block))"
        //
        //            }) { (responseError) -> Void in
        //
        //                //print ("error: \(responseError.localizedDescription)")
        //
        //        }
        
    }
    
    var timet = 0
    var left = false
    
    func changeTimeByOne()
    {
        timet += 1
        if (timet == 60 && !left)
        {
            self.addPoint("\(self.userId)")
        }
        
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "changeTimeByOne", userInfo: nil, repeats: false)
        
        
    }
    
    func addPoint(id:String)
    {
        var params = ["id":id]
        
        //print("params:  \(params)")
        
        var apiCall = "https://exchangeappreview.azurewebsites.net/Spotlight/point_plus_plus.php"
        
        Alamofire.request(.POST, apiCall).responseJSON {
            response in
            
            //self.alert.dismissWithClickedButtonIndex(0, animated: true)
            var json  = response.result.value as? NSDictionary
            let status =  json?.valueForKey("status") as! Int
            
        }
    }
    
    
    
    func ltzOffset() -> Double { return Double(NSTimeZone.localTimeZone().secondsFromGMT) }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        
        sendImage(image)
        
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBOutlet weak var hasLeft: UILabel!
    
    func printTimestamp() -> String {
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        return (timestamp)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "toMessageDetails")
        {
            
            
            var params = ["session": "\(self.typeOfConvo)-\(self.uniqueId)", "user":"\(self.userId)", "time": printTimestamp(), "type":"found", "personNumber":self.personNumber]
            
            FIRAnalytics.logEventWithName("\(self.typeOfConvo)Search", parameters: params as! [String : NSObject])
            
            
            let nav = segue.destinationViewController as! UINavigationController
            let vc = nav.topViewController as! MessageDetailsVC
            vc.recipientID = Int(self.currentConnectedUser)
            vc.json = self.json
            vc.connectionFrom = self.typeOfConvo.capitalizedString
            //print ("My Image: \(self.myImage)")
            vc.myImage = self.myImage
            if (self.personNumber>6)
            {
                vc.showAdd = true
                self.showAdd = true
            }
            else
            {
                vc.showAdd = false
                self.showAdd = false
            }
            
            
            
        }
    }
    
    func didReceiveNewSession(session: QBRTCSession!, userInfo: [NSObject : AnyObject]!) {
        
        //print ("***Call Received.")
        
        self.session = session
        
        //print ("IN HEREE")
        //answerCall(UIButton())
        self.callReceivedView.hidden = false
        
    }
    
    
    
    func session(session: QBRTCSession!, connectedToUser userID: NSNumber!) {
        
        videoView.hidden = false
        
        self.session = session
        
        if (self.session.localMediaStream != nil)
        {
            
            self.session.localMediaStream.videoTrack.enabled = true
            self.session.localMediaStream.videoTrack.videoCapture = self.videoCapture
        }
        
    }
    
    func session(session: QBRTCSession!, receivedRemoteVideoTrack videoTrack: QBRTCVideoTrack!, fromUser userID: NSNumber!) {
        
        
        if (videoTrack != nil)
        {
            //print ("*********************received Video Track")
            self.otherPersonVideo.setVideoTrack(videoTrack)
        }
        else{
            //print ("*********NO VIDEO TRACK RECEIVED")
        }
        
    }
    
    func session(session: QBRTCSession!, hungUpByUser userID: NSNumber!, userInfo: [NSObject : AnyObject]!) {
        //print ("***hangup by user")
        
        videoView.hidden = true
        self.connectionStatus.text = "User Hanged Up."
        
    }
    
    
    func session(session: QBRTCSession!, connectionFailedForUser userID: NSNumber!) {
        //print ("connect failed with : \(userID)")
    }
    
    func session(session: QBRTCSession!, userDidNotRespond userID: NSNumber!) {
        //print ("user didn't respond.")
    }
    
    func session(session: QBRTCSession!, disconnectedByTimeoutFromUser userID: NSNumber!) {
        
        //print ("Disconned from user by timeout: \(userID)")
    }
    
    func session(session: QBRTCSession!, disconnectedFromUser userID: NSNumber!) {
        
        //print ("Disconned from user: \(userID)")
    }
    
    var showAdd = false
    
    override func viewDidAppear(animated: Bool) {
        
        if (self.showAdd)
        {
            
            //self.showAdds()
            //self.showAdd = false
            
        }
        
        self.makeRound.layer.cornerRadius = 10.0
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("nextSearch") {
            
            if (user as! Bool)
            {
                userDefaults.setObject(false, forKey: "nextSearch")
                userDefaults.synchronize()
                
                connected = false
                
                continueState = true
                
                getUserDetails()
            }
            else{
                if (self.allDOne != 0)
                {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
            }
            
        }
        else
        {
            if (self.allDOne != 0)
            {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        
    }
    
    func chatDidConnect() {
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "changeTimeByOne", userInfo: nil, repeats: false)
        
        self.currentChatDialog.onUserIsTyping = {
            
            
            [weak self] (userID)-> Void in
            
            self!.connectionStatus.text = "\(self!.thisUserName) is typing..."
            
            
        }
        
        self.currentChatDialog.onUserStoppedTyping = {
            
            
            [weak self] (userID)-> Void in
            
            self!.connectionStatus.text = "Connected"
            
            
        }
        
        //VIDEOCA.enabled = true
        
        self.connectionStatus.text = "Connected"
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        self.currentChatDialog.sendUserStoppedTyping()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if (self.currentChatDialog != nil)
        {
            self.currentChatDialog.sendUserIsTyping()
        }
        
    }
    
    
    func session(session: QBRTCSession!, acceptedByUser userID: NSNumber!, userInfo: [NSObject : AnyObject]!) {
        //print ("***accepted by user")
        
        self.connectionStatus.text = "Call accepted by user."
        
        
        
    }
    
    func session(session: QBRTCSession!, rejectedByUser userID: NSNumber!, userInfo: [NSObject : AnyObject]!) {
        
        
        self.connectionStatus.text = "Call rejected by user."
        videoView.hidden = true
        
    }
    
    
    
    func getPreviousMessages(total:UInt, startingFrom:UInt)
    {
        self.chatScrollView.contentSize.height = self.chatScrollView.frame.height
        //print ("*Getting all previos messages")
        var resPage = QBResponsePage()
        
        QBRequest.messagesWithDialogID(self.currentChatDialog.ID!, extendedRequest: nil, forPage: resPage, successBlock: { (res:QBResponse, allM:[QBChatMessage]?, newResPage:QBResponsePage?) -> Void in
            
            
            for x in allM!{
                
                if (x.attachments!.count == 0 )
                {
                    //print ("Message --------------------")
                    //print (x)
                    
                    if (x.senderID == self.userId)
                    {
                        self.messageTextField.text = ""
                        
                        var chatBubbleData = ChatBubbleData(text: x.text, image: nil, date: NSDate(), type: BubbleDataType.Mine)
                        
                        var chatBubble = ChatBubble(data: chatBubbleData, startX:self.mineStartingX, startY: self.startingY)
                        
                        
                        var pic = PASImageView(frame: CGRect(x: Int(self.view.frame.width-50) , y: Int(self.startingY)-10, width: 40, height: 40))
                        
                        
                        pic.backgroundColor = UIColor.clearColor()
                        
                        pic.progressColor = UIColor.clearColor()
                        
                        pic.imageURL(NSURL(string: "\(self.myImage)")!)
                        
                        self.chatScrollView.addSubview(pic)
                        
                        self.startingY += chatBubble.layer.frame.height + 30
                        
                        self.chatScrollView.contentSize = CGSizeMake(self.view.frame.width, self.startingY)
                        
                        
                        
                        self.chatScrollView.addSubview(chatBubble)
                        self.scrollToBottom()
                        
                    }
                    else
                    {
                        self.messageTextField.text = ""
                        
                        var chatBubbleData = ChatBubbleData(text: x.text, image: nil, date: NSDate(), type: BubbleDataType.Opponent)
                        
                        var chatBubble = ChatBubble(data: chatBubbleData, startX:self.oppStartingX, startY: self.startingY)
                        
                        var pic = PASImageView(frame: CGRect(x: 10, y: Int(self.startingY)-10, width: 40, height: 40))
                        
                        
                        pic.backgroundColor = UIColor.clearColor()
                        
                        pic.progressColor = UIColor.clearColor()
                        
                        pic.imageURL(NSURL(string: "\(self.hisImage)")!)
                        
                        self.chatScrollView.addSubview(pic)
                        
                        self.startingY += chatBubble.layer.frame.height + 30
                        
                        self.chatScrollView.contentSize = CGSizeMake(self.view.frame.width, self.startingY)
                        
                        
                        
                        self.chatScrollView.addSubview(chatBubble)
                        self.scrollToBottom()
                        
                    }
                    
                }else
                {
                    //print (x.attachments!.count)
                    
                    //print ("Message --------------------")
                    //print (x)
                    
                    var privateUrl: String = QBCBlob.privateUrlForID(UInt(x.attachments![0].ID!)!)!
                    
                    if (x.senderID == self.userId)
                    {
                        self.messageTextField.text = ""
                        
                        
                        
                        var chatBubbleData = ChatBubbleData(text: "Image Received", link: privateUrl, date: NSDate(), type: BubbleDataType.Mine)
                        
                        var chatBubble = ChatBubble(data: chatBubbleData, startX:self.mineStartingX, startY: self.startingY)
                        
                        
                        var pic = PASImageView(frame: CGRect(x: Int(self.view.frame.width-50) , y: Int(self.startingY)-10, width: 40, height: 40))
                        
                        
                        pic.backgroundColor = UIColor.clearColor()
                        
                        pic.progressColor = UIColor.clearColor()
                        
                        pic.imageURL(NSURL(string: "\(self.myImage)")!)
                        
                        chatBubble.tag = self.allImagesUrls.count
                        
                        
                        
                        let imageTap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
                        
                        chatBubble.addGestureRecognizer(imageTap)
                        
                        self.allImagesUrls.append(privateUrl)
                        
                        self.chatScrollView.addSubview(pic)
                        
                        self.startingY += chatBubble.layer.frame.height + 30
                        
                        self.chatScrollView.contentSize = CGSizeMake(self.view.frame.width, self.startingY)
                        
                        
                        
                        self.chatScrollView.addSubview(chatBubble)
                        self.scrollToBottom()
                        
                    }
                    else
                    {
                        self.messageTextField.text = ""
                        
                        var chatBubbleData = ChatBubbleData(text: "Image Received", link: privateUrl, date: NSDate(), type: BubbleDataType.Opponent)
                        
                        var chatBubble = ChatBubble(data: chatBubbleData, startX:self.oppStartingX, startY: self.startingY)
                        
                        var pic = PASImageView(frame: CGRect(x: 10, y: Int(self.startingY)-10, width: 40, height: 40))
                        
                        
                        pic.backgroundColor = UIColor.clearColor()
                        
                        pic.progressColor = UIColor.clearColor()
                        
                        pic.imageURL(NSURL(string: self.hisImage)!)
                        
                        chatBubble.tag = self.allImagesUrls.count
                        
                        
                        let imageTap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
                        
                        chatBubble.addGestureRecognizer(imageTap)
                        
                        self.allImagesUrls.append(privateUrl)
                        
                        self.chatScrollView.addSubview(pic)
                        
                        self.startingY += chatBubble.layer.frame.height + 30
                        
                        self.chatScrollView.contentSize = CGSizeMake(self.view.frame.width, self.startingY)
                        
                        
                        
                        self.chatScrollView.addSubview(chatBubble)
                        self.scrollToBottom()
                        
                    }
                }
                
                
                
            }
            
            
        }) { (errorResponse) -> Void in
            
            //print ("Error while Receiving the messages:\(errorResponse.debugDescription)")
            
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        sendMessageButtonPressed(UIButton())
        textField.endEditing(true)
        return true
    }
    
    func getNumberOfMessages()
    {
        
        //print ("*Getting number of previous messages")
        var n = UInt(0)
        QBRequest.countOfMessagesForDialogID(self.currentChatDialog.ID!, extendedRequest: nil, successBlock: { (rp:QBResponse, number:UInt) -> Void in
            
            
            n = number
            
            //print ("*previous messages count: \(n)")
            self.getPreviousMessages(n, startingFrom: 0)
            
            }, errorBlock:  {
                (errorResponse) -> Void in
                
                //print ("Error while Receiving number of messages:\(errorResponse.debugDescription)")
                
        })
        
        
    }
    
    func setupChat()
    {
        QBChat.instance().addDelegate(self)
        
        self.currentChatDialog.onJoinOccupant = {(userID: UInt) in
            
            if ("\(self.currentConnectedUser)" == "\(userID)")
            {
                //print ("\(self.thisUserName) is online now...")
                self.connectionStatus.text = ("\(self.thisUserName) is online now...")
            }
            else
            {
                //print ("Someone joined")
            }
        }
        
        self.currentChatDialog.onLeaveOccupant = {(userID: UInt) in
            
            if ("\(self.currentConnectedUser)" == "\(userID)")
            {
                //print ("\(self.thisUserName) has left chat...")
                
                self.hasLeft.text = "\(self.thisUserName) has left chat..."
                
                self.hasLeft.hidden = false
                
                self.connectionStatus.text = ("\(self.thisUserName) has left chat...")
                
                self.left = true
                
            }
            else
            {
                //print ("Someone left")
            }
        }
        
        self.getNumberOfMessages()
        
        
    }
    
    func createDialog()
    {
        let chatDialog = QBChatDialog(dialogID: nil, type: QBChatDialogType.Private)
        chatDialog.name = "\(self.userId)"
        
        chatDialog.occupantIDs = [Int(self.currentConnectedUser)!]
        
        QBRequest.createDialog(chatDialog, successBlock: { (response: QBResponse?, createdDialog : QBChatDialog?) -> Void in
            
            //print ("*Chat Dialog Created. ID: \(createdDialog!.ID)")
            
            self.currentChatDialog = createdDialog
            
            self.connectWithChat()
            
            self.setupChat()
            
            
        }) { (responce : QBResponse!) -> Void in
            
            //print ("*Error Creating Chat Dialog: \(responce.error.debugDescription)")
        }
    }
    
    func joinRoom()
    {
        
        
        // QBRTCClient.instance().addDelegate(self)
        
        //print ("All Conectcts: \(QBChat.instance().contactList!.contacts)")
        
        if ( "All Conectcts: \(QBChat.instance().contactList!.contacts)".rangeOfString(self.currentConnectedUser) != nil)
        {
            self.addFriendButton.hidden = true
        }
        else
        {
            self.addFriendButton.hidden = false
        }
        
    }
    
    func connectWithChat()
    {
        let user = QBUUser()
        user.ID = self.userId
        user.password = self.userPassword
        
        QBChat.instance().connectWithUser(user, completion: { (error) -> Void in
            
            if (error == nil){
                self.connectionStatus.text  = ("Connected")
                
                //self.joinRoom()
                
                
                
                
                
                
            }
            else
            {
                //print ("Error in connection: \(error?.localizedDescription)")
                
            }
        })
        
    }
    
    func chatDidAccidentallyDisconnect() {
        self.connectionStatus.text = "Disconnected"
    }
    
    func chatDidReconnect() {
        self.connectionStatus.text = "Connected"
    }
    
    func getUserDetails()
    {
        //print ("*GET USER DETAILS - START")
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("password") {
            userPassword = user as!String
            //print ("User Password: \(userPassword)")
        }
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("id") {
            userId = user as! UInt
            //print ("User Id: \(userId)")
        }
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("gender") {
            gender = user as! String
            //print ("User Gender: \(gender)")
        }
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("prefs") {
            prefs = user as! String
            //print ("User Prefs: \(prefs)")
        }
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("name") {
            name = user as! String
            //print ("User Name: \(name)")
        }
        //print ("*GET USER DETAILS - END")
        
        //getAllBlocks("\(userId)")
        
        getAPIResponse()
        
        
    }
    
    func getAPIResponse()
    {
        
        
        if (!connected && continueState)
        {
            //print ("*GET API RESPONSE STARTED")
            
            let params = [  "user_id": "\(self.userId)" ,
                            "gender": self.gender,
                            "prefs": self.prefs]
            
            //print ("My Params: \(params)");
            Alamofire.request(.POST, "\(self.url)/spotlight_\(self.typeOfConvo).php", parameters: params).responseJSON {
                response in
                
                ////print("GET BABY RESPONSE RAW: \(response)")
                
                let json  = response.result.value as? NSDictionary
                
                //print ("JSON: \(json)")
                
                if (json != nil)
                {
                    if (json?.valueForKey("boolean") as! Bool == true)
                    {
                        //print ("GET BABY RETURNED TRUE")
                        
                        
                        if  (json?.valueForKey("id") as? String != nil)
                        {
                            
                            
                            self.json = json
                            self.currentConnectedUser = json?.valueForKey("id") as! String
                            
                            if ((json?.valueForKey("full_name") as? String != nil))
                            {
                                self.thisUserName =  json?.valueForKey("full_name") as! String
                            }
                            
                            if ((json?.valueForKey("vip") as? Bool != nil))
                            {
                                self.thisUserPro =  json?.valueForKey("vip") as! Bool
                            }
                            
                            
                            
                            
                            if ( json?.valueForKey("requestId") as? String != nil){
                                self.requestId =  json?.valueForKey("requestId") as! String
                            }
                            else{
                                self.requestId = "something"
                            }
                            
                            if ( json?.valueForKey("age") as? String != nil){
                                self.thisUserAge =  json?.valueForKey("age") as! String
                            }
                            
                            if ( json?.valueForKey("city") as? String != nil)
                            {
                                self.thisUserCity =  json?.valueForKey("city") as! String
                            }
                            
                            if (json?.valueForKey("country") as? String != nil)
                            {
                                self.thisUserCountry =  json?.valueForKey("country") as! String
                            }
                            
                            if (json?.valueForKey("profile_pic") as? String != nil)
                            {
                                self.thisUserPic =  json?.valueForKey("profile_pic") as! String
                            }
                            
                            if (json?.valueForKey("gender") as? String != nil)
                            {
                                self.thisUserGender =  json?.valueForKey("gender") as! String
                            }
                            
                            self.continueState = false
                            
                            
                            self.allDOne = 1
                            self.personNumber = self.personNumber+1
                            
                            self.performSegueWithIdentifier("toMessageDetails", sender: self)
                            
                            //self.showConnectedUserDetails()
                            
                            //self.createDialog()
                            
                            
                            
                        }
                        else{
                            //print ("GET API RESPONSE FAILED. ATTEMPTING AGAIN")
                            self.getAPIResponse()
                        }
                        
                        
                        
                        
                    }
                    else
                    {
                        //print ("GET API RESPONSE RETURNED FALSE. ATTEMPTING AGAIN")
                        self.getAPIResponse()
                    }
                    
                }
                else
                {
                    //print ("GET API RESPONSE RETURNED NIL. ATTEMPTING AGAIN")
                    if (self.continueState)
                    {
                        
                        self.getAPIResponse()
                    }
                }
                
                
                
                
            }
        }
    }
    
    
    func chatDidReceiveAcceptContactRequestFromUser(userID: UInt) {
        GTToast.create("\(self.thisUserName) accepted your friend request")
    }
    
    
    func chatDidReceiveRejectContactRequestFromUser(userID: UInt) {
        GTToast.create("\(self.thisUserName) rejected your friend request")
    }
    
    func showConnectedUserDetails(){
        
        //print ("*SHOW USER INFO")
        
        self.connectedToPerson.text = "You are now connected with \(self.thisUserName)"
        
        self.loadingView.hidden = true
        
        
        if (self.thisUserGender == "M")
        {
            self.userInfoGender.text = "Male"
            self.userInfrogenderImage.image = UIImage(named: "btn-male")
        }
        else{
            self.userInfoGender.text = "Female"
            self.userInfrogenderImage.image = UIImage(named: "btn-female")
        }
        
        
        if (self.thisUserAge.containsString("-"))
        {
            var l = self.thisUserAge
            
            //var fullName = "First Last"
            let year = (l.characters.split{$0 == "-"}.map(String.init))[2]
            
            //print ("year received: \(year) - 2016")
            
            var age = 18
            if let abcd = Int(year)
            {
                age = 2016 - abcd
            }
            else
            {
                age = 18
            }
            
            self.userInfoAge.text = "\(age)"
        }
        else
        {
            self.userInfoAge.text = self.thisUserAge
        }
        
        self.userInfoLocation.text = "\(self.thisUserCountry) - \(self.thisUserCity)"
        
        
        if (self.thisUserPic == "image")
        {
            if (self.thisUserGender == "M")
            {
                
                self.userInfoImage.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png")!)
                self.userInfroProImage.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png")!)
                
                self.hisImage = "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png"
            }else
            {
                
                self.userInfoImage.imageURL(NSURL(string: "hhttps://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png")!)
                self.userInfroProImage.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png")!)
                
                self.hisImage = "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png"
            }
            
            
            
        }else{
            self.hisImage = self.thisUserPic
            self.userInfoImage.imageURL(NSURL(string: self.thisUserPic)!)
            self.userInfroProImage.imageURL(NSURL(string: self.thisUserPic)!)
        }
        
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("profile_pic") {
            
            self.myImage = user as! String
            ////print ("***\(userPassword)")
            
        }
        
        
        
        //self.userInfoPro.image = UIImage.gifWithName("VIP-logo")
        
        
        
        
        if (self.thisUserPro == true)
        {
            self.userInfroProView.fadeIn()
            self.userInfoView.fadeIn()
            
        }
        else
        {
            self.userInfroProView.fadeOut()
            self.userInfoView.fadeIn()
        }
        
        
        self.userInfoName.text = "\(self.thisUserName)"
        
        
        NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "dismissUserinfo", userInfo: nil, repeats: true)
        
        var u:String = ""
        
        
        
    }
    
    
    func dismissUserinfo()
    {
        
        self.userInfoView.fadeOut()
    }
    
    func getAllBlocks(id:String)
    {
        
        //print ("*GET ALL BLOCKER USERS - START")
        //newloadingView.hidden = true
        
        Alamofire.request(.POST, "https://exchangeappreview.azurewebsites.net/Spotlight/blocked_by_user.php", parameters: ["id":id]).responseJSON { response in
            
            if (response.result.error == nil)
            {
                //print(response)
                
                let json  = response.result.value as? NSDictionary
                
                self.blocks  = json?.valueForKey("returning") as! String
                
                //self.getAllOnlineUsers()
                
            }
            else{
                //print ("ERROR GET ALL BLOCKS: \(response.result.error)")
            }
            
        }
    }
    
    func chatDidReceiveMessage(message: QBChatMessage) {
        
        
        if (message.attachments == nil)
        {
            addMessageReceivedWithoutAttachment(message)
        }
        else
        {
            addMessageReceivedWithAttachment(message)
        }
        
    }
    
    func addMessageReceivedWithoutAttachment(message:QBChatMessage)
    {
        //print ("Message Received: \(message.text)")
        
        self.messageTextField.text = ""
        
        var chatBubbleData = ChatBubbleData(text: message.text, image: nil, date: NSDate(), type: BubbleDataType.Opponent)
        
        var chatBubble = ChatBubble(data: chatBubbleData, startX:oppStartingX, startY: self.startingY)
        
        
        var pic = PASImageView(frame: CGRect(x: 10 , y: Int(self.startingY)-10, width: 40, height: 40))
        
        pic.backgroundColor = UIColor.clearColor()
        
        pic.progressColor = UIColor.clearColor()
        
        //print("HIS: \(self.hisImage)")
        pic.imageURL(NSURL(string: hisImage)!)
        
        self.startingY += chatBubble.layer.frame.height + 30
        
        self.chatScrollView.contentSize = CGSizeMake(self.view.frame.width, self.startingY)
        
        self.chatScrollView.addSubview(chatBubble)
        
        self.chatScrollView.addSubview(pic)
        
        scrollToBottom()
    }
    
    func addMessageReceivedWithAttachment(message:QBChatMessage)
    {
        
        //self.loadingView.hidden = true
        
        //self.loadingMessage.text = "Downloading Image..."
        
        if (message.attachments == nil)
        {
            return
        }
        if (message.attachments![0].ID == nil)
        {
            return
        }
        var abc:String! = message.attachments![0].ID!
        
        var privateUrl: String = QBCBlob.privateUrlForID(UInt(message.attachments![0].ID!)!)!
        
        //print ("Message Received With Attachment: \(message.text)")
        
        self.messageTextField.text = ""
        
        var chatBubbleData = ChatBubbleData(text: "Image Received", link: privateUrl, date: NSDate(), type: BubbleDataType.Opponent)
        
        var chatBubble = ChatBubble(data: chatBubbleData, startX:self.oppStartingX, startY: self.startingY)
        
        
        
        var pic = PASImageView(frame: CGRect(x: 10 , y: Int(self.startingY)-10, width: 40, height: 40))
        
        pic.backgroundColor = UIColor.clearColor()
        
        pic.progressColor = UIColor.clearColor()
        
        pic.imageURL(NSURL(string: hisImage)!)
        
        self.startingY += chatBubble.layer.frame.height + 30
        
        self.chatScrollView.contentSize = CGSizeMake(self.view.frame.width, self.startingY)
        
        chatBubble.tag = allImagesUrls.count
        
        
        let imageTap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        
        chatBubble.addGestureRecognizer(imageTap)
        
        allImagesUrls.append(privateUrl)
        
        self.chatScrollView.addSubview(chatBubble)
        
        self.chatScrollView.addSubview(pic)
        
        self.scrollToBottom()
    }
    
    
    
    
    func chatDidReceiveSystemMessage(message: QBChatMessage) {
        
        //print ("*System message: \(message.text)")
        connectionStatus.text = message.text!
    }
    
    
    
    func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        self.scrollToBottom()
        
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height + 5
            self.scrollToBottom()
            }, completion: { (v) -> Void in
                
                self.scrollToBottom()
                
                
        })
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.bottomConstraint.constant = 0
        })
    }
    
    func scrollToBottom()
    {
        
        
        var bottomOffset = CGPointMake(0, self.chatScrollView.contentSize.height - self.chatScrollView.bounds.size.height);
        
        self.chatScrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    
    @IBAction func rejectCallButtonPressed(sender: UIButton) {
        
        session.rejectCall(nil)
        callReceivedView.hidden = true
        
    }
    
    @IBAction func acceptCallButtonPressed(sender: UIButton) {
        
        //acc = true
        
        self.videoFormat = QBRTCVideoFormat.init(width: 640, height: 480, frameRate: 30, pixelFormat: QBRTCPixelFormat.Format420f)
        
        self.videoCapture = QBRTCCameraCapture.init(videoFormat: videoFormat, position: AVCaptureDevicePosition.Front)
        
        self.videoCapture.previewLayer.frame = self.myVideo.bounds
        
        self.videoCapture.startSession()
        
        self.myVideo.layer.insertSublayer(self.videoCapture.previewLayer, atIndex: 0)
        
        session.acceptCall(nil)
        videoView.hidden = false
        callReceivedView.hidden = true
        
    }
    
    func session(session: QBRTCSession!, initializedLocalMediaStream mediaStream: QBRTCMediaStream!) {
        
        mediaStream.videoTrack.videoCapture = capture
        
    }
    
    func session(session: QBRTCSession!, connectionClosedForUser userID: NSNumber!) {
        
        //print ("*Session closed")
    }
    
    func session(session: QBRTCSession!, startedConnectingToUser userID: NSNumber!) {
        //print ("***started connecting to user")
        //loadingMessage.text = "Attempting to connect..."
        //loadingView.hidden = false
    }
    
    @IBAction func rejectFriendRequestButtonPressed(sender: UIButton) {
        
        
        QBChat.instance().rejectAddContactRequest(UInt(self.currentConnectedUser)!, completion: { (error: NSError?) -> Void in
            
            if (error == nil)
            {
                GTToast.create("Friend Request Rejected")
                self.friendRequestView.hidden = true
            }
            else{
                GTToast.create("Network error")
                self.friendRequestView.hidden = false
                //print ("ERROR WITH REQUEST: \(error?.localizedDescription)")
            }
            
        });
        
    }
    
    @IBAction func acceptFriendRequestButtonPressed(sender: UIButton) {
        
        QBChat.instance().confirmAddContactRequest(UInt(self.currentConnectedUser)!, completion: { (error: NSError?) -> Void in
            
            if (error == nil)
            {
                GTToast.create("Friend Request Accepted")
                self.friendRequestView.hidden = true
            }
            else{
                GTToast.create("Network error")
                self.friendRequestView.hidden = false
                //print ("ERROR WITH REQUEST: \(error?.localizedDescription)")
            }
            
        })
        
    }
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        
        self.hasLeft.hidden = true
        
        if QBChat.instance().isConnected() {
            QBChat.instance().disconnectWithCompletionBlock { (error: NSError?) -> Void in
                
                if (error == nil)
                {
                    //print ("Chat has been left")
                }else
                {
                    //print ("ERROR: \(error)")
                }
                
            }
        }
        else
        {
            //print ("You are not connected.")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        //print ("Your Memory is full")
        GTToast.create("Your memory is full...")
    }
    
    func finishVideoCall()
    {
        
        if (self.session != nil)
        {
            self.session.hangUp(["":""])
            
            
        }
        
        QBRTCClient.deinitializeRTC()
        QBRTCSoundRouter.instance().deinitialize()
        
    }
    
    @IBOutlet weak var makeRound: UIView!
    func videoCall()
    {
        
        
        QBRTCClient.initializeRTC()
        
        QBRTCClient.instance().addDelegate(self)
        
        self.capture = QBRTCVideoCapture()
        
        
        
        QBRTCSoundRouter.instance().initialize()
        
        QBRTCSoundRouter.instance().currentSoundRoute = QBRTCSoundRoute.Speaker
        //QBRTCSoundRouter.instance().setCurrentSoundRoute(QBRTCSoundRoute.Speaker)
        
        QBRTCClient.initializeRTC()
        
        let session = QBRTCClient.instance().createNewSessionWithOpponents(self.currentChatDialog.occupantIDs, withConferenceType: QBRTCConferenceType.Video)
        
        
        self.videoFormat = QBRTCVideoFormat.init(width: 1600    , height: 900, frameRate: 30, pixelFormat: QBRTCPixelFormat.Format420f)
        
        self.videoCapture = QBRTCCameraCapture.init(videoFormat: videoFormat, position: AVCaptureDevicePosition.Front)
        
        self.videoCapture.previewLayer.frame = self.myVideo.bounds
        
        
        session.startCall(nil)
        
        
    }
    
    @IBAction func requestVideoButtonPressed(sender: UIButton) {
        
        
        self.videoCall()
    }
    
    func chatDidReceiveContactAddRequestFromUser(userID: UInt) {
        
        self.friendRequestName.text = self.thisUserName
        self.friendRequestView.hidden = false
    }
    
    @IBAction func addFriendButtonPressed(sender: UIButton) {
        
        
        QBChat.instance().addUserToContactListRequest(UInt(self.currentConnectedUser)!, completion: {(error: NSError?) -> Void in
            
            
            if (error != nil)
            {
                GTToast.create("Error sending request.")
                //print ("Error with request: \(error?.localizedDescription)")
            }
            else
            {
                GTToast.create("Friend Request Sent.")
            }
        })
        
        
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        
        self.finishVideoCall()
        self.connected = false
        self.continueState = false
        
        if QBChat.instance().isConnected() {
            QBChat.instance().disconnectWithCompletionBlock { (error: NSError?) -> Void in
                
                if (error == nil)
                {
                    //print ("Chat has been left")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }else
                {
                    //print ("ERROR: \(error)")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
            }
        }
        else
        {
            //print ("You are not connected.")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
    }
    
    @IBAction func sendMessageButtonPressed(sender: UIButton) {
        
        
        let message: QBChatMessage = QBChatMessage()
        message.text = messageTextField.text
        
        let params : NSMutableDictionary = NSMutableDictionary()
        params["save_to_history"] = true
        message.customParameters = params
        
        self.currentChatDialog.sendMessage(message, completionBlock: { (error: NSError?) -> Void in
            
            if (error == nil)
            {
                //print ("message sent")
                
                self.messageTextField.text = ""
                var chatBubbleData = ChatBubbleData(text: message.text, image: nil, date: NSDate(), type: BubbleDataType.Mine)
                
                var chatBubble = ChatBubble(data: chatBubbleData, startX:self.mineStartingX, startY: self.startingY)
                
                
                var pic = PASImageView(frame: CGRect(x: Int(self.view.frame.width-50) , y: Int(self.startingY)-10, width: 40, height: 40))
                
                pic.backgroundColor = UIColor.clearColor()
                
                pic.progressColor = UIColor.clearColor()
                
                pic.imageURL(NSURL(string: self.myImage)!)
                
                
                self.startingY += chatBubble.layer.frame.height + 30
                
                self.chatScrollView.contentSize = CGSizeMake(self.view.frame.width, self.startingY)
                
                self.chatScrollView.addSubview(chatBubble)
                
                self.chatScrollView.addSubview(pic)
                
                self.scrollToBottom()
                
                
            }
            else
            {
                //print ("message NOT sent: \(error?.localizedDescription)")
                self.connectionStatus.text = "Sending Failded. Please Retry!"
            }
            
        });
        
        
    }
    
    func chatDidReceiveContactItemActivity(userID: UInt, isOnline: Bool, status: String?) {
        
        //print ("*Contact Actrivity: \(userID) isOnline: \(isOnline) status: \(status)")
        
    }
    
    
    @IBAction func selecImageButtonPressed(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func viewPersonInfoButtonPressed(sender: UIButton) {
        
    }
    
    @IBAction func reportUserButtonPressed(sender: UIButton) {
    }
    
    @IBAction func switchCameraButtonPressed(sender: UIButton) {
        
        var position = self.videoCapture.currentPosition()
        
        var newPosition:AVCaptureDevicePosition!
        
        if (position == AVCaptureDevicePosition.Front)
        {
            newPosition = AVCaptureDevicePosition.Back
        }
        else
        {
            newPosition = AVCaptureDevicePosition.Front
        }
        
        if (self.videoCapture.hasCameraForPosition(newPosition)) {
            self.videoCapture.selectCameraPosition(newPosition)
        }
        else
        {
            GTToast.create("Camera Position Not Available").show()
        }
        
        
    }
}
