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
import GoogleMobileAds

class VideoDialogInfoVC: UIViewController, QBChatDelegate, QBRTCClientDelegate, UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var acc:Bool = false
    var type:String!
    @IBOutlet weak var blurBG =  UIView()
    @IBOutlet weak var locationInfo: UILabel!
    @IBOutlet weak var ageInfo: UILabel!
    @IBOutlet weak var genderInfo: UILabel!
    @IBOutlet weak var userInfoView: UIView!
    var currentConnectedUser = ""
    var currentConnectedUserName = ""
    var currentConnectedRoomId = ""
    var connectedUserDetails:[AnyObject]!
    var url = "https://exchangeappreview.azurewebsites.net/Spotlight"
    var requestId:String!
    var blocks:String  = ""
    
    
    var timet = 0;
    var left  = false
    @IBOutlet weak var loadingGif: UIImageView!
    @IBOutlet weak var videoView: UIView!
    var currentUserNumber  = 0;
    var currentRoomNumber  = 0;
    @IBOutlet weak var imageViewImage: UIImageView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var callByName: UILabel!
    
    @IBOutlet weak var newloadingView: UIView!
    
    @IBOutlet weak var callReceivedDialog: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var requestVideoBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var localVideo: UIView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var connectionTime: UILabel!
    @IBOutlet weak var connectionStatus: UILabel!
    @IBOutlet weak var chatScrollView: UIScrollView!
    @IBOutlet weak var flagButton: UIButton!
    @IBOutlet weak var friendRequestDialog: UIView!
    var isFriend:Bool = false
    
    var timeInSeconds = 0;
    var connected:Bool = false
    
    var tenSeconds = false
    
    var isCaller = false
    
    var gender:String!
    var prefs:String!
    var allUsers:String = ""
    var moreFilteredUsers:[AnyObject]!
    var name:String = ""
    
    var interstitial: GADInterstitial!
    var startingY:CGFloat = 10
    var allImagesUrls:[String] = []
    var allChatPages:[QBResponsePage]!
    var mineStartingX:CGFloat = 30
    var oppStartingX:CGFloat = 30
    let imagePicker = UIImagePickerController()
    var cur:Int!
    var onlineUsers:[NSDictionary] = []
    var filteredUsers:[String] = []
    // let alert = UIAlertView()
    
    var tap:UITapGestureRecognizer!
    
    
    var thisUserName:String = ""
    var thisUserAge:String = ""
    var thisUserCity:String = ""
    var thisUserCountry:String = ""
    var thisUserPic:String = ""
    var thisUserGender:String = ""
    
    @IBAction func pictureCancelPressed(sender: UIButton) {
        
    }
    @IBAction func pictureSavePressed(sender: UIButton) {
        
    }
    
    @IBOutlet weak var waitingDialog: UIView!
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var personNameString:String = ""
    
    var videoCapture:QBRTCCameraCapture!
    var session:QBRTCSession!
    //@IBOutlet weak var connectionStatus: UILabel!
    @IBOutlet weak var members: UILabel!
    var chatDialog: QBChatDialog!
    
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var messageText: UITextField!
    
    @IBOutlet weak var otherVideo: QBRTCRemoteVideoView!
    
    var capture:QBRTCVideoCapture!
    
    var userPassword:String!
    var userId:UInt!
    
    var alert:UIAlertView!
    
    
    var peopleDone:String = ""
    
    @IBOutlet weak var reportDialogButton: UIButton!
    @IBOutlet weak var reportView: UIView!
    @IBAction func rejectCall(sender: UIButton) {
        
        session.rejectCall(nil)
        callReceivedDialog.hidden = true
        
    }
    
    func getAllBlocks(id:String)
    {
       
        //print ("IN HEREE")
        newloadingView.hidden = true
        
        Alamofire.request(.POST, "https://exchangeappreview.azurewebsites.net/Spotlight/blocked_by_user.php", parameters: ["id":id]).responseJSON { response in
            
            if (response.result.error == nil)
            {
                //print(response)
                
                let json  = response.result.value as? NSDictionary
                
                self.blocks  = json?.valueForKey("returning") as! String
                
                self.getAllOnlineUsers()
                
            }
            
        }
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        
    }
    
    func createUserForId(id:String) //-> [NSDictionary]
    {
        
    }
    
    func nextPersonAttempt()
    {
        
        if (tenSeconds)
        {
            self.report(UIButton())
            
            
        }
        
        //print ("Next person attempt.")
        if QBChat.instance().isConnected() {
            QBChat.instance().disconnectWithCompletionBlock { (error: NSError?) -> Void in
                
            }
        }
        
        
        self.connected = false
        self.continueState = false
        self.startingY = 0
        self.chatScrollView.subviews.forEach({ $0.removeFromSuperview() })
        //self.waitingDialog.hidden = true
        self.continueState = true
        //self.getAllOnlineUsers()
        //self.getAllBlocks("\(userId)")
        //self.getUserDetails()
        
        self.deleteRequestsForThis(self.requestId)
    }
    
    func reportuser(id:String, s:String)
    {
        self.reportView.hidden = true
        alert = UIAlertView()
        alert.title = "Please wait"
        alert.message = "Submitting Report"
        ////alert.show()
        
        var params = ["userId":id, "points": -10, "reporter":s]
        
        
        
        //print("params:  \(params)")
        
        var apiCall = "https://exchangeappreview.azurewebsites.net/Spotlight/report_user.php"
        
        Alamofire.request(.POST, apiCall).responseJSON {
            response in
            
             self.reportDialogButton.enabled = true
            
            self.alert.dismissWithClickedButtonIndex(0, animated: true)
            var json  = response.result.value as? NSDictionary
            let status =  json?.valueForKey("status") as! Int
            
            if (status == 1)
            {
//                self.alert = UIAlertView()
//                self.alert.title = "Report"
//                self.alert.message = "Report has been submitted"
//                self.alert.addButtonWithTitle("Ok")
                //self.alert.show()
                
                GTToast.create("Report has been submitted")
                
                self.blockPerm("\(id)", myId: "\(s)")
            }
            else
            {
//                self.alert = UIAlertView()
//                self.alert.title = "Report"
//                self.alert.message = "You have already reported this user."
//                
//                
//                self.alert.addButtonWithTitle("Ok")
//                
//                
                //self.alert.show()
                
                GTToast.create("You have already reported this user.")
            }
            
        }
    }

    
    @IBAction func answerCall(sender: UIButton) {
        
        acc = true
        
        self.videoFormat = QBRTCVideoFormat.init(width: 640, height: 480, frameRate: 30, pixelFormat: QBRTCPixelFormat.Format420f)
        
        self.videoCapture = QBRTCCameraCapture.init(videoFormat: videoFormat, position: AVCaptureDevicePosition.Front)
        
        self.videoCapture.previewLayer.frame = self.localVideo.bounds
        
        self.videoCapture.startSession()
        
        self.localVideo.layer.insertSublayer(self.videoCapture.previewLayer, atIndex: 0)
        
        session.acceptCall(nil)
        videoView.hidden = false
        callReceivedDialog.hidden = true
        
    }
    
    func tenSecondsPlus()
    {
        self.tenSeconds = true
    }
    
    @IBAction func nextPersonButtonPressed(sender: UIButton) {
        
        QBRTCSoundRouter.instance().deinitialize()
        if (self.session != nil)
        {
            self.session.hangUp(nil)
        }
        
        //print ("Call hanged up.")
        
        self.videoView.hidden = true
        
        if QBChat.instance().isConnected() {
            QBChat.instance().disconnectWithCompletionBlock { (error: NSError?) -> Void in
                
                
                
            }
        }
        
        
        self.blockForOneHour("\(self.currentConnectedUser)", myId: "\(self.userId)")
        
        self.continueState = false
        self.nextPersonAttempt()
        
    }
    
    
    @IBAction func switchCam(sender: UIButton) {
        
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
    
    func session(session: QBRTCSession!, hungUpByUser userID: NSNumber!, userInfo: [NSObject : AnyObject]!) {
        //print ("***hangup by user")
        QBRTCSoundRouter.instance().deinitialize()
        
        videoView.hidden = true
        //loadingMessage.text = "User Hanged Up."
        
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        
        QBRTCClient.deinitializeRTC()
        
        QBRTCClient.instance().removeDelegate(self)
        
        QBChat.instance().removeDelegate(self)
        
        self.capture = nil
        
        
        self.continueState = false
         self.connected = false
        
        
        self.blockForOneHour("\(self.currentConnectedUser)", myId: "\(self.userId)")
        
        if (self.session != nil)
        {
            QBRTCSoundRouter.instance().deinitialize()
            self.session.hangUp(["":""])
            
            
            self.connected = false
            self.connected = false
            self.continueState = false
            
            if QBChat.instance().isConnected() {
                QBChat.instance().disconnectWithCompletionBlock { (error: NSError?) -> Void in
                    //self.deleteRequestsFor()
                    //self.deleteChatRoomFor()
                    self.connected = false
                    self.connected = false
                    self.continueState = false
                    if (self.requestId != nil)
                    {
                        self.deleteRequestsForAndLeave(self.requestId)
                    }else{
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    //self.dismissViewControllerAnimated(true, completion: nil)
                }
            }

        }
        else
        {
            
            self.connected = false
            self.continueState = false
            //self.deleteRequestsFor()
            //self.deleteChatRoomFor()
            self.connected = false
            if (self.requestId != nil)
            {
                self.deleteRequestsForAndLeave(self.requestId)
            }
            else{
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            //self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
    }
    
    @IBAction func addFriendButtonPressed(sender: UIButton) {
        
        if (Int(userId) > Int(currentConnectedUser))
        {
            var params = ["id": "\(currentRequest)","sentby":"\(userId)" , "sendername":self.name, "receivername":self.personNameString, "friend":"\(currentConnectedUser)\(userId)", "responded":"false"]
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let client = delegate.client
            let itemTable = client.tableWithName("friends")
            
            itemTable.insert(params, completion: { (obj, error) -> Void in
                if (error == nil)
                {
                    
                    GTToast.create("   Request Sent.   ").show()
                    
                    sender.enabled = false
                    sender.hidden = true
                }
                else
                {
                    GTToast.create("   Request already sent.   ").show()
                    
                }
                
            });
            
            
        }
        else
        {
            var params = ["id": "\(currentRequest)", "friends":"\(userId)\(currentConnectedUser)", "sendername":self.name,"responded":"false", "receivername":self.personNameString]
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let client = delegate.client
            let itemTable = client.tableWithName("friend")
            
            itemTable.insert(params, completion: { (obj, error) -> Void in
                if (error == nil)
                {
                    
                    GTToast.create("   Request Sent.   ").show()
                    
                    sender.enabled = false
                    sender.hidden = true
                }
                else
                {
                    GTToast.create("   Request already sent.   ").show()
                    
                }
                
            });
        }
        
    }
    
    @IBOutlet weak var makeRound: UIView!
    @IBOutlet weak var videoView2: UIView!
    @IBAction func requestVideoButtonPressed(sender: UIButton) {
        startVideoSession()
        
    }
    
    
    var videoFormat:QBRTCVideoFormat!
    func chatDidConnect() {
        
        
        self.chatDialog.onUserIsTyping = {
            
            
            [weak self] (userID)-> Void in
            
            self!.connectionStatus.text = "\(self!.personNameString) is typing..."
            
            
        }
        
        self.chatDialog.onUserStoppedTyping = {
            
            
            [weak self] (userID)-> Void in
            
            self!.connectionStatus.text = "Connected"
            
            
        }
        
        self.connectionStatus.text = "Connected"
        
        connectButton.titleLabel?.text = "Disconnect from Dialog"
        
        
    }
    @IBAction func nextPressed(sender: UIBarButtonItem) {
        
        QBRTCSoundRouter.instance().deinitialize()
        self.session.hangUp(nil)
        
        if QBChat.instance().isConnected() {
            QBChat.instance().disconnectWithCompletionBlock { (error: NSError?) -> Void in
                
                self.deleteChatRoomFor()
                self.nextPersonAttempt()
                
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        self.chatDialog.sendUserStoppedTyping()
    }
    
    @IBAction func toggleOnOff(sender: UIButton) {
        
        self.session.localMediaStream.videoTrack.enabled = true;
    }
    @IBAction func requestVideoOnButtonPressed(sender: UIBarButtonItem) {
        startVideoSession()
    }
    
    @IBAction func requestVideo(sender: UIButton) {
        
        startVideoSession()
        
    }
    
    //    func session(session: QBRTCSession!, receivedRemoteVideoTrack videoTrack: QBRTCVideoTrack!, fromUser userID: NSNumber!) {
    //        otherVideo.setVideoTrack(videoTrack)
    //        
    //        self.otherVideo.setVideoTrack(videoTrack)
    //
    //        
    //    }
    
    func session(session: QBRTCSession!, initializedLocalMediaStream mediaStream: QBRTCMediaStream!) {
        
        mediaStream.videoTrack.videoCapture = capture
        
        //       mediaStream.videoTrack.videoCapture = self.;
    }
    
    func chatDidAccidentallyDisconnect() {
        
        //print ("*****Chat Disconnected")
        
        connectButton.titleLabel?.text = "Connect To Dialog"
        
        // self.unwindForSegue(self., towardsViewController: <#T##UIViewController#>)
        
    }
    
    @IBAction func backFromVideo(sender: UIBarButtonItem) {
        
        QBRTCSoundRouter.instance().deinitialize()
        self.session.hangUp(nil)
        
        self.videoView.hidden = true
        
    }
    
    @IBAction func unwindDialogVC(segue: UIStoryboardSegue)
    {
        //print ("unwind segue done")
    }
    
    //    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
    //        
    //        
    //    }
    //    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        chatDialog.sendUserIsTyping()
        
    }
    
    
    func session(session: QBRTCSession!, acceptedByUser userID: NSNumber!, userInfo: [NSObject : AnyObject]!) {
        //print ("***accepted by user")
        
        //loadingMessage.text = "Accepted by user..."
        
        
        
    }
    
    func session(session: QBRTCSession!, rejectedByUser userID: NSNumber!, userInfo: [NSObject : AnyObject]!) {
        
        //loadingMessage.text = "Rejected by user..."
        videoView.hidden = true
        
    }
    
    func session(session: QBRTCSession!, startedConnectingToUser userID: NSNumber!) {
        //print ("***started connecting to user")
        //loadingMessage.text = "Attempting to connect..."
        //loadingView.hidden = false
    }
    
    
    func session(session: QBRTCSession!, connectedToUser userID: NSNumber!) {
        //print ("***connected to user")
        //loadingMessage.text = "Connected to User"
        //loadingView.hidden = true
        
        videoView.hidden = false
        
        self.session = session
        
        if (self.session.localMediaStream != nil)
        {
            
            self.session.localMediaStream.videoTrack.enabled = true
            self.session.localMediaStream.videoTrack.videoCapture = self.videoCapture
        }
    }
    
    
    
    func session(session: QBRTCSession!, userDidNotRespond userID: NSNumber!) {
        //print ("***user didn't respond")
        //loadingMessage.text = "User didn't respond"
    }
    
    
    func session(session: QBRTCSession!, receivedRemoteVideoTrack videoTrack: QBRTCVideoTrack!, fromUser userID: NSNumber!) {
        
        //loadingView.hidden = true
        
        //print ("*********************received Video Track")
        self.otherVideo.setVideoTrack(videoTrack)
        //self.loadingMessage.text = "Received Video Track..."
        
        //session.acceptCall(nil)
    }

    
    
    func didReceiveNewSession(session: QBRTCSession!, userInfo: [NSObject : AnyObject]!) {
        
        //print ("***Call Received.")
        
        self.session = session
        
        //print ("IN HEREE")
        answerCall(UIButton())
        //callReceivedDialog.hidden = false
        
    }
    
    
    
    
    func sendImage(img:UIImage)
    {
        
        //self.loadingMessage.text = "Uploading Image"
        
        //self.loadingView.hidden = false
        
        var imageData = UIImageJPEGRepresentation(img, 5)
        
        
        QBRequest.TUploadFile(imageData!, fileName: "\(userId)-\(NSDate(timeIntervalSinceNow: 0))", contentType: "image/jpg", isPublic: false, successBlock: { (response:QBResponse, block:QBCBlob) -> Void in
            
            //self.loadingMessage.text = "****Done Uploading..."
            
            //self.loadingView.hidden = true
            
            var message: QBChatMessage = QBChatMessage()
            
            var uploadedFileID: UInt = block.ID
            var attachment: QBChatAttachment = QBChatAttachment()
            attachment.type = "image"
            attachment.ID = String(uploadedFileID)
            message.attachments = [attachment]
            
            self.sendMsg(message, img: img)
            
            }, statusBlock: { (block) -> Void in
                
                //print ("***desc \(block.1!.percentOfCompletion*100)")
                //self.loadingMessage.text = "Uploading: \(Int(block.1!.percentOfCompletion*100))/100%"
                
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
    
    func startVideoSession()
    {
        QBRTCSoundRouter.instance().initialize()
        
        QBRTCSoundRouter.instance().currentSoundRoute = QBRTCSoundRoute.Speaker
        //QBRTCSoundRouter.instance().currentSoundRoute = QBRTCSoundRoute.Speaker
        
        //loadingMessage.text = "Initializing..."
        
        //loadingView.hidden = false
        let session = QBRTCClient.instance().createNewSessionWithOpponents(self.chatDialog.occupantIDs, withConferenceType: QBRTCConferenceType.Video)
        
        
        self.videoFormat = QBRTCVideoFormat.init(width: 1600    , height: 900, frameRate: 30, pixelFormat: QBRTCPixelFormat.Format420f)
        
        self.videoCapture = QBRTCCameraCapture.init(videoFormat: videoFormat, position: AVCaptureDevicePosition.Front)
        
        self.videoCapture.previewLayer.frame = self.localVideo.bounds
        
        self.videoCapture.startSession()
        
        self.localVideo.layer.insertSublayer(self.videoCapture.previewLayer, atIndex: 0)
        
        
        session.startCall(nil)
        
        //loadingView.hidden = true
        
        
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        
        sendImage(image)
        
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func selectPicture(sender: UIButton) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func sendMsg(message:QBChatMessage, img:UIImage)
    {
        let params : NSMutableDictionary = NSMutableDictionary()
        params["save_to_history"] = true
        message.customParameters = params
        
        chatDialog.sendMessage(message, completionBlock: { (error: NSError?) -> Void in
            
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
                
                pic.imageURL(NSURL(string: "https://worldarts2015.s3-us-west-2.amazonaws.com/images/default-profile-picture.jpg?cache=1442935010")!)
                
                
                self.startingY += chatBubble.layer.frame.height + 30
                
                self.chatScrollView.contentSize = CGSizeMake(self.view.frame.width, self.startingY)
                
                chatBubble.tag = self.allImagesUrls.count
                
                
                let imageTap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
                
                chatBubble.addGestureRecognizer(imageTap)
                
                self.allImagesUrls.append(privateUrl)
                
                self.chatScrollView.addSubview(chatBubble)
                
                self.chatScrollView.addSubview(pic)
                
                self.scrollToBottom()
                
                
            }
            else
            {
                //print ("message NOT sent")
                self.connectionStatus.text = "Sending Failded. Please Retry!"
            }
            
        });
        
        
    }
    
    
    @IBAction func sendMessage(sender: UIButton) {
        
        let message: QBChatMessage = QBChatMessage()
        message.text = messageTextField.text
        
        let params : NSMutableDictionary = NSMutableDictionary()
        params["save_to_history"] = true
        message.customParameters = params
        
        chatDialog.sendMessage(message, completionBlock: { (error: NSError?) -> Void in
            
            if (error == nil)
            {
                //print ("message sent")
                
                self.messageTextField.text = ""
                var chatBubbleData = ChatBubbleData(text: message.text, image: nil, date: NSDate(), type: BubbleDataType.Mine)
                
                var chatBubble = ChatBubble(data: chatBubbleData, startX:self.mineStartingX, startY: self.startingY)
                
                
                var pic = PASImageView(frame: CGRect(x: Int(self.view.frame.width-50) , y: Int(self.startingY)-10, width: 40, height: 40))
                
                pic.backgroundColor = UIColor.clearColor()
                
                pic.progressColor = UIColor.clearColor()
                
                pic.imageURL(NSURL(string: "https://worldarts2015.s3-us-west-2.amazonaws.com/images/default-profile-picture.jpg?cache=1442935010")!)
                
                
                self.startingY += chatBubble.layer.frame.height + 30
                
                self.chatScrollView.contentSize = CGSizeMake(self.view.frame.width, self.startingY)
                
                self.chatScrollView.addSubview(chatBubble)
                
                self.chatScrollView.addSubview(pic)
                
                self.scrollToBottom()
                
                
            }
            else
            {
                //print ("message NOT sent")
                self.connectionStatus.text = "Sending Failded. Please Retry!"
            }
            
        });
        
    }
    
    func getNumberOfMessages()
    {
        var n = UInt(0)
        QBRequest.countOfMessagesForDialogID(chatDialog.ID!, extendedRequest: nil, successBlock: { (rp:QBResponse, number:UInt) -> Void in
            
            n = number
            
            self.getPreviousMessages(n, startingFrom: 0)
            
            }, errorBlock:  {
                (errorResponse) -> Void in
                
                //print ("Error while Receiving number of messages:\(errorResponse.debugDescription)")
                
        })
        
        
    }
    
    
    func getPreviousMessages(total:UInt, startingFrom:UInt)
    {
        
        var resPage = QBResponsePage(limit: Int(total), skip: Int(startingFrom))
        
        QBRequest.messagesWithDialogID(chatDialog.ID!, extendedRequest: nil, forPage: resPage, successBlock: { (res:QBResponse, allM:[QBChatMessage]?, newResPage:QBResponsePage?) -> Void in
            
            
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
                        
                        pic.imageURL(NSURL(string: "https://worldarts2015.s3-us-west-2.amazonaws.com/images/default-profile-picture.jpg?cache=1442935010")!)
                        
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
                        
                        pic.imageURL(NSURL(string: "https://worldarts2015.s3-us-west-2.amazonaws.com/images/default-profile-picture.jpg?cache=1442935010")!)
                        
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
                        
                        pic.imageURL(NSURL(string: "https://worldarts2015.s3-us-west-2.amazonaws.com/images/default-profile-picture.jpg?cache=1442935010")!)
                        
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
                        
                        pic.imageURL(NSURL(string: "https://worldarts2015.s3-us-west-2.amazonaws.com/images/default-profile-picture.jpg?cache=1442935010")!)
                        
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
    
    func chatDidReceiveContactItemActivity(userID: UInt, isOnline: Bool, status: String?) {
        
        //print ("Here")
        
    }
    
    @IBOutlet weak var imageInfo: PASImageView!
    
    
    func chatDidReceiveSystemMessage(message: QBChatMessage) {
        
        //print ("message: \(message.text)")
        connectionStatus.text = message.text!
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
        
        pic.imageURL(NSURL(string: "https://worldarts2015.s3-us-west-2.amazonaws.com/images/default-profile-picture.jpg?cache=1442935010")!)
        
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
        
        pic.imageURL(NSURL(string: "https://worldarts2015.s3-us-west-2.amazonaws.com/images/default-profile-picture.jpg?cache=1442935010")!)
        
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
    
    func scrollToBottom()
    {
        
        
        var bottomOffset = CGPointMake(0, self.chatScrollView.contentSize.height - self.chatScrollView.bounds.size.height);
        
        self.chatScrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    var thisUserPro = false
    
    func getMyBaby()
    {
        
        
        if (!connected && continueState)
        {
        //print ("***GET BABY*** HAPPENED")
        
        let params = [  "user_id": "\(self.userId)" ,
                        "gender": self.gender,
                        "prefs": self.prefs]
        
        //print ("My Params: \(params)");
        Alamofire.request(.POST, "\(self.url)/spotlight_video.php", parameters: params).responseJSON {
            response in
            
            //print("GET BABY RESPONSE RAW: \(response)")
            
            let json  = response.result.value as? NSDictionary
            
            //print ("JSON: \(json)")
            
            if (json != nil)
            {
                if (json?.valueForKey("boolean") as! Bool == true)
                {
                    //print ("GET BABY RETURNED TRUE")
                    
                    
                    if  (json?.valueForKey("id") as? String != nil)
                    {
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
                        
                        self.startMakingConnectionToUser()
                        
                        
                    }
                    else{
                        //print ("GET BABY TRIED BUT FAILED. ATTEMPTING AGAIN")
                        self.getMyBaby()
                    }
                    
                    
                    
                    
                }
                else
                {
                    //print ("GET BABY RETURNED FALSE. ATTEMPTING AGAIN")
                    self.getMyBaby()
                }
                
            }
            else
            {
                //print ("GET BABY RETURNED NIL. ATTEMPTING AGAIN")
                if (self.continueState)
                {
                    
                    self.getMyBaby()
                }
            }
            
            
            
            
        }
        }
    }
    
    func deleteRequestsForAndLeave(id: String)
    {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("Request")
        
        //print("deleting request: \(id)")
        itemTable.deleteWithId(id) { (object, error) -> Void in
            if (error != nil)
            {
                //print ("error deleting the request: \(self.requestId). Error : \(error.localizedDescription)")
                
            }
            else
            {
                
                //print ("Deleted Request with Iself.D: \(self.requestId)")
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        //        itemTable.deleteWithId(requestId, completion: )
        //itemTable.delete(["id": requestId], completion: nil)
        //itemTable.deleteWithId(requestId, completion: nil)
        
    }
    
    
    
    func startMakingConnectionToUser()
    {
        
        createDialogForUserAutoNew(self.currentConnectedUser)
        
    }
    
    func createDialogForUserAutoNew(uid:String){
        
        //print ("userId: \(uid)")
        
        let chatDialog = QBChatDialog(dialogID: nil, type: QBChatDialogType.Private)
        
        chatDialog.name = "Chat Dialog"
        
        self.showConnectedUserDetails()
        
        chatDialog.occupantIDs = [Int(uid)!]
        
        QBRequest.createDialog(chatDialog, successBlock: { (response: QBResponse?, createdDialog : QBChatDialog?) -> Void in
            
            //print("***Response: \(createdDialog?.ID)")
            
            self.chatDialog = createdDialog!
            
            //           self.alert.dismissWithClickedButtonIndex(0, animated: true)
            
            self.startMakingConnection()
            
            
        }) { (responce : QBResponse!) -> Void in
            //print("***Error: \(responce)")
            
        }
        
    }
    
    @IBOutlet weak var infoLocation: UILabel!
    
    @IBOutlet weak var imgGender: UIImageView!
    
    func showConnectedUserDetails(){
        
        //print ("*CONNECTED*")
        
        self.personName.text = "You are now connected with \(self.thisUserName))"
        
        newloadingView.hidden = true
        
        
        if (self.thisUserGender == "M")
        {
            self.genderInfo.text = "Male"
            self.imgGender.image = UIImage(named: "btn-male")
        }else{
            self.genderInfo.text = "Female"
            self.imgGender.image = UIImage(named: "btn-female")
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
            
            self.ageInfo.text = "\(age)"
        }
        else
        {
            self.ageInfo.text = self.thisUserAge
        }
        
        self.infoLocation.text = "\(self.thisUserCountry) - \(self.thisUserCity)"
        
        
        if (self.thisUserPic == "image")
        {
            if (self.thisUserGender == "M")
            {
                
                self.imageInfo.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png")!)
                self.proInfoImage.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png")!)
                
                
            }else
            {
                
                self.imageInfo.imageURL(NSURL(string: "hhttps://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png")!)
                self.proInfoImage.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png")!)
                
            }
            
            
            
        }else
        {
            ////print ("* * * *\(self.connectedUserDetails[7] as! String)")
            self.imageInfo.imageURL(NSURL(string: self.thisUserPic)!)
            self.proInfoImage.imageURL(NSURL(string: self.thisUserPic)!)
            
            //self.hisimage = self.thisUserPic
            
        }
        
        
        self.imageInfo.imageURL(NSURL(string: self.thisUserPic)!)
        self.proInfoImage.imageURL(NSURL(string: self.thisUserPic)!)
        
        self.vipGifIV.image = UIImage.gifWithName("VIP-logo")
        
        
        
        
        if (self.thisUserPro == true)
        {
            //                    self.proInfo.hidden = false
            //                    self.userInfoView.hidden = false
            //
            //self.leftChat.hidden = false
            self.proInfo.fadeIn()
            self.userInfoView.fadeIn()
            
        }
        else
        {
            self.proInfo.fadeOut()
            self.userInfoView.fadeIn()
            //                    self.proInfo.hidden = true
            //                    self.userInfoView.hidden = false
        }
        
        
        self.infoName.text = "\(self.thisUserName)"
        
        
        NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: "dismissUserinfo", userInfo: nil, repeats: true)
        
        var u:String = ""
        
        
        
    }


    
    func getUserDetails()
    {
        //print ("***THIS*** HAPPENED")
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("password") {
            userPassword = user as!String
            //print ("***\(userPassword)")
        }
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("id") {
            userId = user as! UInt
            //print ("***\(userId)")
        }
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("gender") {
            gender = user as! String
            //print ("***\(gender)")
        }
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("prefs") {
            prefs = user as! String
            //print ("***\(prefs)")
        }
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("name") {
            name = user as! String
            //print ("***\(name)")
        }
        
        self.getMyBaby()
        
        //getAllBlocks("\(userId)")
        
        
        
    }
    
    func showChatView()
    {
        
    }
    
    func ltzOffset() -> Double { return Double(NSTimeZone.localTimeZone().secondsFromGMT) }
    
    
    func getAllOnlineUsers()
    {
        
        alert = UIAlertView()
        alert.title = "Please wait"
        alert.message = "Looking for online users"
        //alert.show()
        //self.newloadingView.hidden = false
        
        let date = NSDate(timeIntervalSinceNow: (-120)-(ltzOffset()))
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([.Hour, .Minute, .Day, .Month,.Year], fromDate: date)
        
        var hour = "\(components.hour)"
        var minutes = "\(components.minute)"
        
        var day = "\(components.day)"
        var month = "\(components.month)"
        var year = "\(components.year)"
        
        var fil:String = ""
        
        if (hour.characters.count<2)
        {
            hour = "0\(hour)"
        }
        if (minutes.characters.count<2)
        {
            minutes = "0\(minutes)"
        }
        if (day.characters.count<2)
        {
            day = "0\(day)"
        }
        if (month.characters.count<2)
        {
            month = "0\(month)"
        }
        
        fil = ("date last_request_at gt \(year)-\(month)-\(day)T\(hour):\(minutes):00Z")
        
        //print (fil)
        
        
        
        
        var filters = ["filter[]":fil]
        //onlineUsers = NSDictionary
        
        QBRequest.usersWithExtendedRequest(filters, page: QBGeneralResponsePage(currentPage: 1, perPage: 100), successBlock: { (response:QBResponse, page:QBGeneralResponsePage?, user:[QBUUser]?) -> Void in
            
            //print ("***** number ofonline users: \(user!.count)")
            
            
            
            self.alert.title = "\(user!.count) users found online"
            self.alert.message = "Filtering for you..."
            
            self.allUsers = ""
            
            for u in user!{
                
                if (!self.peopleDone.containsString("\(u.ID)") && (!self.blocks.containsString("\(u.ID)")))
                {
                    //print ("IT HGOT PAST: \(u.ID) BLOCKS: \(self.blocks)")
                    self.allUsers += "\(u.ID),"
                }
                
            }
            
            let params = [ "UserID": "\(self.userId)"
                , "online": self.allUsers ]
            
            //print (params);
            
            
            self.alert.dismissWithClickedButtonIndex(0, animated: true)
            
            self.matchSpecifications(self.allUsers)
            
            
            }) { (errorResponse) -> Void in
                
                //print ("*** Response: \(errorResponse)")
                
                self.alert.dismissWithClickedButtonIndex(0, animated: true)
                self.alert = UIAlertView()
                self.alert.dismissWithClickedButtonIndex(0, animated: true)
                self.alert = UIAlertView()
                self.alert.title = "Error."
                self.alert.message = "Please try again later."
                self.alert.addButtonWithTitle("Ok")
                //self.alert.show()
                
        }
        
    }
    
    func getFriendRequest()
    {
        
        if (!isFriend && connected)
        {
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let client = delegate.client
            let itemTable = client.tableWithName("friends")
            var query = MSQuery(table: itemTable)
            
            query.fetchLimit = 500;
            
            query.predicate = NSPredicate(format: "friend contains[c] '\(userId)' AND responded != true AND sentby != '\(userId)'")
            
            //print ("predicate: \(query.predicate)")
            
            query.readWithCompletion({ (result, error) -> Void in
                
                if (error != nil)
                {
                    //print (error.localizedDescription)
                }
                else
                {
                    
                    //print ("**get friend req ELSE body")
                    if (result.items.count>0)
                    {
                        self.friendRequestDialog.hidden = false
                        self.requestyName.text = result.items[0].valueForKey("sendername") as! String
                        
                        self.currentRequest = result.items[0].valueForKey("id") as! String
                        self.currentRequestyId = (result.items[0].valueForKey("friend") as! String).stringByReplacingOccurrencesOfString("\(self.userId)", withString: "")
                        //print ("Requests found.")
                        self.respondRequest()
                    }
                    else{
                        self.friendRequestDialog.hidden = true
                        //print ("No requests found.")
                        
                        if (self.connected)
                        {
                            self.getFriendRequest()
                            self.checkBlockWithBool("\(self.userId)", u2: "\(self.currentConnectedUser)", user: self.connectedUserDetails)
                        }
                        
                    }
                }
            })
            
        }
        
        
    }
    
    func checkBlockWithBool(u1: String, u2: String, user:[AnyObject])
    {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("block")
        
        var query = MSQuery(table: itemTable)
        
        query.fetchLimit = 500;
        
        query.predicate = NSPredicate(format: "both contains[c] '\(u1)' AND both contains[c] '\(u2)'")
        
        //print ("predicate: \(query.predicate)")
        
        query.readWithCompletion({ (result, error) -> Void in
            
            if ((error) != nil)
            {
                //print ("error with the query while checkBlock")
                
            }
            else
            {
                //
                if (result.items.count > 0)
                {
                    
                    //print ("This user has blocked you. Checking next")
                    
                    if ((self.interstitial.isReady) && (result.items[0].valueForKey("blocker") as! String != "\(self.userId)") && (result.items[0].valueForKey("blocktype") as! String != "1")) {
                        self.interstitial.presentFromRootViewController(self)
                    }else
                    {
                        //print ("***ad not ready.")
                    }
                    
                    //self.nextPersonButtonPressed(UIButton())
                    //self.nextPressed(UIBarButtonItem())
                    
                }
                else
                {
                    
                    //print ("This user has NOT blocked you. Checking next")
                    
                    
                }
            }
            
        })
        
        
    }
    
    
    func checkBlock(u1: String, u2: String, user:[AnyObject])
    {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("block")
        
        var query = MSQuery(table: itemTable)
        
        query.fetchLimit = 500;
        
        query.predicate = NSPredicate(format: "both contains[c] '\(u1)' AND both contains[c] '\(u2)'")
        
        //print ("predicate: \(query.predicate)")
        
        query.readWithCompletion({ (result, error) -> Void in
            
            if ((error) != nil)
            {
                //print ("error with the query while checkBlock")
                
            }
            else
            {
                
                //print ("* * *items = \(result.items)")
                //print ("result= \(result)")
                //print ("result.count = \(result.totalCount)")
                //print ("result items count = \(result.items.count)")
                
                
                if (result.items.count > 0)
                {
                    
                    //print ("This user has blocked you. Checking next")
                    
                    self.currentUserNumber++
                    
                    if (self.currentUserNumber>=user.count)
                    {
                        //print ("No User Online and Available, Creating room...")
                        self.createRoomAndWaitForUser()
                    }
                    else
                    {
                        //print ("checking next user's availability...")
                        self.forUser(user)
                        
                    }
                    
                }
                else{
                    
                    //print ("This is free user. Creating Room with him/her")
                    self.createRoomWithUser((user[self.currentUserNumber].valueForKey("id") as! String))
                }
            }
            
        })
        
    }
    
    
    func respondRequest()
    {
        
        
        if (Int(userId) > Int(currentRequestyId))
        {
            var params = [  "id": "\(currentRequest)",
                "friend":"\(currentConnectedUser)\(userId)", "responded":"true", "sendername":self.personNameString, "receivername":self.name]
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let client = delegate.client
            let itemTable = client.tableWithName("friends")
            
            itemTable.update(params, completion: nil)
            
        }
        else
        {
            var params = ["id": "\(currentRequest)", "friend":"\(currentConnectedUser)\(userId)", "responded":"true", "sendername":self.personNameString, "receivername":self.name]
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let client = delegate.client
            let itemTable = client.tableWithName("friends")
            
            itemTable.update(params, completion: nil)
        }
        
        
    }
    
    
    
    func respondRequestAccept()
    {
        
        
        if (Int(userId) > Int(currentRequestyId))
        {
            var params = [  "id"            :   "\(currentRequest)",
                "friend"        :   "\(currentConnectedUser)\(userId)",
                "sendername"    :   self.personNameString,
                "receivername"  :   self.name ,
                "responded"     :   "true",
                "accepted"      :   "true"      ]
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let client = delegate.client
            let itemTable = client.tableWithName("friends")
            
            itemTable.update(params, completion: { (obj, error) -> Void in
                if (error == nil)
                {
                    
                    // GTToast.create("Request Sent.").show()
                    self.friendRequestDialog.hidden = true
                }
                else{
                    // GTToast.create("Request already sent.").show()
                }
                
            });
            
        }
        else
        {
            var params = [  "id"            :   "\(currentRequest)",
                "friend"        :   "\(userId)\(currentConnectedUser)",
                "sendername"    :   self.personNameString,
                "receivername"  :   self.name,
                "responded"     :   "true",
                "accepted"      :   "true"
            ]
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let client = delegate.client
            let itemTable = client.tableWithName("friends")
            
            itemTable.update(params, completion: { (obj, error) -> Void in
                if (error == nil)
                {
                    // GTToast.create("Request Sent.").show()
                    self.friendRequestDialog.hidden = true
                }
                else{
                    // GTToast.create("Request already sent.").show()
                }
                
            });
        }
        
        
    }
    
    
    func respondRequestReject()
    {
        
        
        if (Int(userId) > Int(currentRequestyId))
        {
            var params = ["id": "\(currentRequest)", "friend":"\(currentConnectedUser)\(userId)","sendername":self.personNameString, "receivername":self.name ,"responded":"true","sendername":self.personNameString, "receivername":self.name, "accepted":"false"]
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let client = delegate.client
            let itemTable = client.tableWithName("friends")
            
            itemTable.update(params, completion: { (obj, error) -> Void in
                if (error == nil)
                {
                    self.friendRequestDialog.hidden = true
                }
                
            });
            
        }
        else
        {
            var params = ["id": "\(currentRequest)", "friend":"\(userId)\(currentConnectedUser)","sendername":self.personNameString, "receivername":self.name, "responded":"true", "accepted":"true"]
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let client = delegate.client
            let itemTable = client.tableWithName("friends")
            
            itemTable.update(params, completion: { (obj, error) -> Void in
                if (error == nil)
                {
                    self.friendRequestDialog.hidden = true
                }
                
            });
        }
        
        
    }
    
    
    var currentRequest:String = ""
    var currentRequestyId:String = ""
    
    
    @IBAction func acceptRequest(sender: UIButton) {
        respondRequestAccept()
    }
    
    @IBAction func rejectRequest(sender: UIButton) {
        respondRequestReject()
    }
    
    @IBOutlet weak var requestyName: UILabel!
    
    func matchSpecifications(allUsers:String)
    {
        
        self.filteredUsers = [];
        self.alert = UIAlertView()
        self.alert.title = "Please wait"
        self.alert.message = "while we look for a perfect match..."
        //self.alert.show()
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("Users")
        
        //var predicate = NSPredicate(format: "email == [c] %@", user!)
        
        var query = MSQuery(table: itemTable)
        
        query.fetchLimit = 500;
        
        query.predicate = NSPredicate(format: "'\(prefs!)' contains[c] gender AND prefs contains[c] '\(gender!)'")
        
        //print ("Predicate: \(query.predicate)")
        
        query.readWithCompletion({ (result, error) -> Void in
            
            self.alert.dismissWithClickedButtonIndex(0, animated: true)
            if ((error) != nil)
            {
                
                //print (error.localizedDescription)
                self.alert = UIAlertView()
                self.alert.title = "Error."
                self.alert.message = "Please try again later."
                self.alert.addButtonWithTitle("Ok")
                //self.alert.show()
            }
            else
            {
                
                //print ("Matching prefs user count: \(result.items.count)")
                
                if (result.items.count>0)
                {
                    //print ("count received: \(result.items.count)")
                    
                    if (self.currentUserNumber<result.items.count)
                    {
                        self.forUser(result.items)
                        
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        
                        for u in result.items{
                            
                            
                            //print ("Attempting save for user")
                            
                            var details = "\(u.valueForKey("id") as! String),\(u.valueForKey("first_name") as! String),\(u.valueForKey("last_name") as! String),\(u.valueForKey("gender") as! String),\(u.valueForKey("country") as! String),\(u.valueForKey("city") as! String),\(u.valueForKey("age") as! String),\(u.valueForKey("profile_pic") as! String),\(u.valueForKey("email") as! String),\(u.valueForKey("points") as! String),\(u.valueForKey("prefs") as! String)"
                            
                            if (u.valueForKey("vip") as? Bool != nil)
                            {
                                details += ",\(u.valueForKey("vip") as! Bool)"
                            }else
                            {
                                details += ",false"
                            }
                            //print ("Saved info for user \(u.valueForKey("id") as! String)")
                            //print ("DETAILS : \(details)")
                            //print ("user-\(u.valueForKey("id") as! String)")
                            userDefaults.setObject(details, forKey: "user-\(u.valueForKey("id") as! String)")
                            
                        }
                        
                        userDefaults.synchronize()
                    }else
                    {
                        //print ("No One Else Online")
                        self.createRoomAndWaitForUser()
                    }
                    
                }
            }
            
        })
        
        
        
        
    }
    
    func forUser(u:[AnyObject])
    {
        moreFilteredUsers = u
        acc = false
        
        if (allUsers.containsString(u[currentUserNumber].valueForKey("id") as! String) && (u[currentUserNumber].valueForKey("id") as! String) != "\(self.userId)")
        {
            self.filteredUsers.append(u[currentUserNumber].valueForKey("id") as! String)
            //print ("Found Online and Matching: \(u[currentUserNumber].valueForKey("id") as! String)")
            
            
            
            self.checkOrCreateRoomForUser(u)
        }
        else{
            currentUserNumber++
            if (currentUserNumber>=u.count){
                //print ("No User was found available.")
                createRoomAndWaitForUser()
            }
            else
            {
                //print ("This user didn't work. Attempting Next User.")
                forUser(u)
            }
        }
    }
    
    func createRoomAndWaitForUser()
    {
        
//        if self.interstitial.isReady {
//            self.interstitial.presentFromRootViewController(self)
//        }
//        else
//        {
//            //print ("Not Ready")
//        }
        
        currentSeconds = 60
        //print ("Creating Room...")
        self.alert.dismissWithClickedButtonIndex(0, animated: true)
        self.alert = UIAlertView()
        self.alert.title = "Please wait"
        self.alert.message = "Creating room"
        //self.alert.show()
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("ChatRoom")
        
        var item = ["person1":"\(self.userId)", "isfull":"false"]
        
        itemTable.insert(item)     {
            (item) in
            
            if (item.1 == nil)
            {
                //print ("RoomCreated")
                self.startListeningtoRoom("\(item.0!["id"]!)")
                self.alert.dismissWithClickedButtonIndex(0, animated: true)
                //self.waitingDialog.hidden = false
                self.updateTimeByOne()
                
            }
            else
            {
                //print ("Error Creating room.")
                self.alert = UIAlertView()
                self.alert.title = "Error"
                self.alert.message = "We hit an error."
                self.alert.addButtonWithTitle("OK")
                //self.alert.show()
            }
        }
    }
    
    @IBAction func cancelWaitingPressed(sender: UIButton) {
        if (sender.currentTitle! == "Retry")
        {
            
        }else{
            continueState = false
            if QBChat.instance().isConnected() {
                QBChat.instance().disconnectWithCompletionBlock { (error: NSError?) -> Void in
                    
                }
            }
            self.dismissViewControllerAnimated(true, completion: nil)
            
            
        }
        
    }
    @IBOutlet weak var cancelButtonWaiting: UIButton!
    @IBOutlet weak var waitingTime: UILabel!
    var continueState = true;
    @IBOutlet weak var retryButtonWaiting: UIButton!
    
    @IBAction func retryWaitingPressed(sender: UIButton) {
        
        
    }
    var currentSeconds = 60
    
    func updateTimeByOne()
    {
        //self.waitingTime.text = "\(self.currentSeconds) seconds"
        self.currentSeconds--
        
        if (continueState && currentSeconds<=0)
        {
            //self.waitingTime.text = "No body available."
            //self.cancelButtonWaiting.setTitle("Retry", forState: .Normal)
            //retryButtonWaiting.enabled = true
        }
        else if(continueState){
            
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimeByOne", userInfo: nil, repeats: false)
            
        }else{
            //print ("user connected.")
            self.waitingDialog.hidden = true
        }
        
    }
    
    func startListeningtoRoom(id: String)
    {
        isCaller = true
        currentConnectedRoomId = id
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("ChatRoom")
        
        var query = MSQuery(table: itemTable)
        
        query.fetchLimit = 500;
        
        query.predicate = NSPredicate(format: "id == '\(id)' AND isfull != false")
        
        //print ("Predicate: \(query.predicate)")
        
        query.readWithCompletion({ (result, error) -> Void in
            
            if (error != nil)
            {
                //print (error.localizedDescription)
            }
            else
            {
                //print ("totalCount: \(result.totalCount)")
                
                
                if (result.items.count>0)
                {
                    //print ("user has joined room")
                    self.continueState = false
                    self.startCreatingDialogs(result.items[0].valueForKey("person2") as! String)
                    self.deleteRequestsFor()
                    self.deleteChatRoomFor()
                    self.continueState = false
                    
                }
                else{
                    //print ("listening again...")
                    if (self.continueState)
                    {
                        self.startListeningtoRoom(id)
                    }else
                    {
                        
                    }
                }
            }
            
        })
        
    }
    
    func checkOrCreateRoomForUser(uIDs:[AnyObject])
    {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("ChatRoom")
        
        var query = MSQuery(table: itemTable)
        
        query.fetchLimit = 500;
        
        
        query.predicate = NSPredicate(format: "person1=='\(uIDs[self.currentUserNumber].valueForKey("id") as! String)' OR person2=='\(uIDs[self.currentUserNumber].valueForKey("id") as! String)'")
        
        //print ("Predicate: \(query.predicate)")
        
        query.readWithCompletion({ (result, error) -> Void in
            
            if ((error) != nil)
            {
                //print (error.localizedDescription)
            }
            else
            {
                if (result.items.count>0)
                {
                    //print ("This user has a room. Checking availability")
                    self.checkAvailability(result.items, uID: uIDs[self.currentUserNumber].valueForKey("id") as! String)
                    
                }
                else
                {
                    //print ("This is free user. Checking Requests for him/her")
                    self.checkPendingRequestsFor(uIDs)
                    
                    
                }
                
            }
            
        })
        
    }
    
    func checkPendingRequestsFor(user:[AnyObject])
    {
        var id:String = user[self.currentUserNumber].valueForKey("id") as! String
        var type:String  = "video"
        
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("Request")
        
        var query = MSQuery(table: itemTable)
        
        query.fetchLimit = 500;
        
        
        query.predicate = NSPredicate(format: "user_id == '\(id)' AND type == 'text' ")
        
        //print ("predicate: \(query.predicate)")
        
        query.readWithCompletion({ (result, error) -> Void in
            
            if ((error) != nil)
            {
                //print ("error with the query while checkPendingRequestsFor")
                
            }
            else
            {
                if (result.totalCount < 0)
                {
                    //print ("This is user has no pending request")
                    
                    self.currentUserNumber++
                    
                    if (self.currentUserNumber>=user.count)
                    {
                        //print ("No User Online and Available, Creating room...")
                        self.createRoomAndWaitForUser()
                    }
                    else
                    {
                        //print ("checking next user's availability...")
                        self.forUser(user)
                        
                    }
                }
                else
                {
                    //print ("This is free user. Checking block list")
                    self.checkBlock("\(id)", u2: "\(self.userId)", user: user)
                }
            }
            
        })
        
    }
    
    func checkAvailability(b:[AnyObject], uID:String)
    {
        //print ("total rooms are: \(b.count) . Current Room number is: \(currentRoomNumber)")
        if (b[self.currentRoomNumber].valueForKey("isfull") as! Bool)
        {
            //print ("Room Full")
            currentRoomNumber++
            if (self.currentRoomNumber < b.count)
            {
                //print ("Attempting Next")
                self.checkAvailability(b, uID: uID)
            }
            else
            {
                //print ("No room avaiable")
                self.createRoomAndWaitForUser()
            }
            
        }
        else
        {
            //print ("Found place Joinig Room")
            self.joinRoom(uID, r: b[self.currentRoomNumber].valueForKey("id") as! String)
        }
    }
    
    func joinRoom(u:String, r:String)
    {
        startCreatingDialogs(u)
        //deleteRequestsFor()
        
        
        updateRoomInfo(r, u: u)
        
        //var item = ["person1":"\(self.userId)","person2":uID, "isfull":"true"]
        
        //        itemTable.insert(item)     {
        //            (insertedItem, error) in
        //            //print ("RoomCreated")
        //        }
    }
    
    func updateRoomInfo(r:String, u:String)
    {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("ChatRoom")
        
        // itemTable.update(["id":r], parameters: ["person1": self.filteredUsers[currentUserNumber], "person2":u, "isfull":"true"], completion: nil)
        
        //print ("updateing room information...")
        
        //print ("total: \(self.filteredUsers.count)")
        //print ("current: \(currentUserNumber)")
        
        
        
        itemTable.update(["id":r, "person1": "\(u)", "person2":"\(self.userId)", "isfull":"true"]) { (obj, error) -> Void in
            
            
            //print ("Room Updated.")
        }
    }
    
    func createRoomWithUser(uID:String)
    {
        //print ("Creating Room...")
        startCreatingDialogs(uID)
        deleteRequestsFor()
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("ChatRoom")
        
        var item = ["person1":"\(self.userId)","person2":uID, "isfull":"true"]
        
        itemTable.insert(item)     {
            (insertedItem, error) in
            //print ("RoomCreated")
        }
    }
    
    
    
    func deleteChatRoomFor()
    {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("ChatRoom")
        
        //print("deleting room: \(currentConnectedRoomId)")
        itemTable.deleteWithId(currentConnectedRoomId) { (object, error) -> Void in
            if (error != nil)
            {
                //print ("error deleting the chat room: \(self.currentConnectedRoomId). Error : \(error.localizedDescription)")
            }
            else
            {
                
                //print ("Deleted ChatRoom with Iself.D: \(self.currentConnectedRoomId)")
            }
        }
        //        itemTable.deleteWithId(requestId, completion: )
        //itemTable.delete(["id": requestId], completion: nil)
        //itemTable.deleteWithId(requestId, completion: nil)
        
    }
    
    func deleteRequestsFor()
    {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("Request")
        
        //print("deleting request: \(requestId)")
        itemTable.deleteWithId(requestId) { (object, error) -> Void in
            if (error != nil)
            {
                //print ("error deleting the request: \(self.requestId). Error : \(error.localizedDescription)")
            }
            else
            {
                
                //print ("Deleted Request with Iself.D: \(self.requestId)")
            }
        }
        //        itemTable.deleteWithId(requestId, completion: )
        //itemTable.delete(["id": requestId], completion: nil)
        //itemTable.deleteWithId(requestId, completion: nil)
        
    }
    
    func checkPendingRequestsForUserWithId(str:String)
    {
        
        if (str != "\(userId)")
        {
            
            let params = [  "UserId": str ,
                "request_type":"video",
                "request_by":"\(userId)"]
            
            //print (params);
            Alamofire.request(.POST, "\(self.url)pendingRequests.php", parameters: params).responseJSON {
                response in
                
                //print(response)
                
                let json  = response.result.value as? NSDictionary
                
                if (json?.valueForKey("response") as! String == "go")
                {
                    self.startCreatingDialogs()
                }
                else
                {
                    
                    self.currentUserNumber++;
                    if (self.currentUserNumber < self.filteredUsers.count)
                    {
                        self.checkPendingRequestsForUserWithId(self.filteredUsers[self.currentUserNumber])
                    }
                    
                }
                
            }
            
        }
        else
        {
            self.currentUserNumber++;
            if (self.currentUserNumber < self.filteredUsers.count)
            {
                self.checkPendingRequestsForUserWithId(self.filteredUsers[self.currentUserNumber])
            }
        }
        
        
        
        
    }
    
    @IBOutlet weak var vipGifIV: UIImageView!
    override func viewWillDisappear(animated: Bool) {
        
        deleteRequestsFor()
        deleteChatRoomFor()
        
    }
    
    func addOneToTime()
    {
        self.timeInSeconds += 1
        
        if (self.timeInSeconds == 60)
        {
            self.addPoint("\(self.userId)")
        }
        else
        {
            
        }
        
    }
    
    func dismissUserinfo()
    {
        
        self.userInfoView.fadeOut()
        self.proInfo.fadeOut()
        
//        self.userInfoView.hidden = true
//        self.proInfo.hidden = true
        //self.blurBG!.hidden = true
    }
    @IBOutlet weak var proInfo: UIView!
    @IBOutlet weak var proInfoImage: PASImageView!
    
    @IBOutlet weak var infoName: UILabel!
    func makeConnecttion()
    {
        alert = UIAlertView()
        alert.title = "Please wait"
        alert.message = "Connecting you to someone..."
        
        //alert.show()
        
        let user = QBUUser()
        user.ID = self.userId
        user.password = self.userPassword
        
        QBChat.instance().connectWithUser(user, completion: { (error) -> Void in
            
            if (error == nil){
                
                self.newloadingView.hidden = true
                
                self.tenSeconds = false
                self.personName.text = "You are now connected with \(self.personNameString)"
                
                self.peopleDone += "\(user.ID)"
                self.connectionTime.text = self.getCurrentTime()
                
                //print ("Connected!")
                
                self.timeInSeconds = 0
                // self.blurB!G.hidden = false
                
                //self.alert.dismissWithClickedButtonIndex(0, animated: true)
                
                self.connectionStatus.text = "Connected"
                //self.alert.dismissWithClickedButtonIndex(0, animated: true)
                
                self.deleteRequestsFor()
                self.deleteChatRoomFor()
                self.connected = true
                
                //print ("****GETTING DETAILS FOR : \(self.currentConnectedUser)")
                
                
                self.getConnectedUserDetails(self.currentConnectedUser)
                
                self.getFriendRequest()
                
                NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "tenSecondsPlus", userInfo: nil, repeats: false)
                
                NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "addOneToTime", userInfo: nil, repeats: true)
                
            }
            else
            {
                
                //print ("*Error: \(error?.localizedDescription)")
                self.personName.text = "Mayday situation. Retreat ASAP. Over."
                self.connectionTime.text = ""
                //print ("NOT Connected!")
                //self.connectionStatus.text = "NOT Connected"
            }
            
        })
        
        
    }
    
    
    func OneMinutepast()
    {
        addPoint("\(self.userId)")
    }
    
    
    
    
    
    func addPoint(id:String)
    {
        var params = ["id":id]
        
        //print("params:  \(params)")
        
        var apiCall = "https://exchangeappreview.azurewebsites.net/Spotlight/point_plus_plus.php"
        
        Alamofire.request(.POST, apiCall).responseJSON {
            response in
            
            self.alert.dismissWithClickedButtonIndex(0, animated: true)
            var json  = response.result.value as? NSDictionary
            let status =  json?.valueForKey("status") as! Int
            
        }
    }
    
    
    
    
    
    @IBAction func sendReport(sender: UIButton) {
    
        
        sender.enabled = false
        var id = "\(sender.tag)"
        
        reportuser(id, s: "\(self.userId)")
        
    }
    
    @IBAction func cancelReport(sender: UIButton) {
        
        self.reportView.hidden = true
       
    }
    
    
    @IBAction func report(sender: UIButton) {
        //reportuser(self.currentConnectedUser)
        //sender.enabled = false
        
        self.reportView.hidden = false
        self.reportDialogButton.tag = Int(self.currentConnectedUser)!
        
        
        
    }
    
    @IBAction func sendM(sender: UIButton) {
        
        self.sendMessage(sender)
        messageTextField.endEditing(true)
        
    }
    
    
    
    
    
    func getConnectedUserDetails(recept:String){
        
        var u:String = ""
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("user-\(recept)") {
            
            u = user as! String
            
            //print ("object retreived as: \(u as! String)")
            var a = (user as! String).componentsSeparatedByString(",")
            connectedUserDetails = a
            
            //print ("connected: \(a)")
            
            self.personName.text = "You are now connected with \(self.connectedUserDetails[1] as! String) \(self.connectedUserDetails[2] as! String)"
            
            self.peopleDone += self.connectedUserDetails[0] as! String
            
            
            
            self.genderInfo.text = self.connectedUserDetails[3] as! String
            
            
            self.ageInfo.text = self.connectedUserDetails[6] as! String
            
            
            
            self.imageInfo.imageURL(NSURL(string: self.connectedUserDetails[7] as! String)!)
            self.proInfoImage.imageURL(NSURL(string: self.connectedUserDetails[7] as! String)!)
            self.vipGifIV.image = UIImage.gifWithName("VIP-logo")
            
            if (self.connectedUserDetails.count>10)
            {
                var b = self.connectedUserDetails[11] as? String
                
                if (b == "true")
                {
                    //                    self.proInfo.hidden = false
                    //                    self.userInfoView.hidden = false
                    //
                    self.proInfo.fadeIn()
                    self.userInfoView.fadeIn()
                    
                }
                else
                {
                    self.proInfo.fadeOut()
                    self.userInfoView.fadeIn()
                    //                    self.proInfo.hidden = true
                    //                    self.userInfoView.hidden = false
                }
            }
            else
            {
                // self.proInfo.hidden = true
                self.proInfo.fadeOut()
            }

            
            self.infoName.text = "\(self.connectedUserDetails[1] as! String) \(self.connectedUserDetails[2] as! String)"
            
            //            if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("name") {
            //                
            //                self.infoName.text = user as! String
            //            }
            //            
            
            
            
            NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "dismissUserinfo", userInfo: nil, repeats: true)
            
            self.requestVideoButtonPressed(UIButton())
            
            
        }
        else{
            //print ("***Details for this user not found: user-\(recept)")
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        self.makeRound.layer.cornerRadius = 10.0
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.makeRound.layer.cornerRadius = 10.0
        
        self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        
        let request = GADRequest()
        // Requests test ads on test devices.
        request.testDevices = ["2077ef9a63d2b398840261c8221a0c9b"]
        self.interstitial.loadRequest(request)
        
        
//        let jeremyGif = UIImage.gifWithName("Spinner (1)")
//        
//        loadingGif.image = jeremyGif

        
        imagePicker.delegate = self
        
        
        
        
        self.messageTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        getUserDetails()
        
        //makeRequest()
        
        //getAllOnlineUsers()
        
        
        
        
    }
    
    func deleteRequestsForThis(id: String)
    {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("Request")
        
        //print("deleting request: \(id)")
        itemTable.deleteWithId(id) { (object, error) -> Void in
            if (error != nil)
            {
                //print ("error deleting the request: \(self.requestId). Error : \(error.localizedDescription)")
                
            }
            else
            {
                
                //print ("Deleted Request with Iself.D: \(self.requestId)")
            }
            
            self.getUserDetails()
            
            
        }
        //        itemTable.deleteWithId(requestId, completion: )
        //itemTable.delete(["id": requestId], completion: nil)
        //itemTable.deleteWithId(requestId, completion: nil)
        
    }
    
    func blockForOneHour(BlockUserId:String, myId:String)
    {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("Block")
        
        var item = ["blocktype":"1","blocker":myId,"blocky":BlockUserId, "both":"\(myId)\(BlockUserId)"]
        
//        itemTable.insert(item) { (user, error) in
//            
//            if (error == nil)
//            {
//                //self.nextPressed(UIBarButtonItem())
//            }
//            else
//            {
//                //print ("ERROR BLOCKING USER: \(error.localizedDescription)")
//            }
//            
//        }
    }
    
    
    func blockPerm(BlockUserId:String, myId:String)
    {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("Block")
        
        var item = ["blocktype":"0","blocker":myId,"blocky":BlockUserId, "both":"\(myId)\(BlockUserId)"]
        
        itemTable.insert(item) { (user, error) in
            
            if (error == nil)
            {
                self.nextPersonButtonPressed(UIButton())
                //                self.nextPressed(UIBarButtonItem())
            }
            else
            {
                //print ("ERROR BLOCKING USER: \(error.localizedDescription)")
            }
            
        }
    }

    
    func makeRequest()
    {
        var params = ["UserId": "\(userId)", "request_type": "video"]
        
        Alamofire.request(.POST, "\(url)makeRequest.php", parameters: params)
        
        getAllOnlineUsers()
    }
    
    
    
    func startMakingConnection()
    {
        
        QBRTCClient.initializeRTC()
        
        QBRTCClient.instance().addDelegate(self)
        
        self.capture = QBRTCVideoCapture()
        
       // getUserDetails()
        
        ////print (chatDialog.name)
        //print (self.title)
        self.title = chatDialog.name
        self.personNameString = chatDialog.name!
        //self.personName.text = self.personNameString
        self.personName.text = "Connecting to \(self.personNameString)"
        
        let occup = self.chatDialog.occupantIDs
        
        for x in occup!{
            members.text! += "\(x), "
        }
        
        if (chatDialog.isJoined())
        {
            connectionStatus.text = "Connected"
        }else
        {
            connectionStatus.text = "NOT Connected"
        }
        
        QBChat.instance().addDelegate(self)
        
        
        
        makeConnecttion()
        
        //getNumberOfMessages()
        
    }
    
    @IBAction func connectToDialog(sender: UIButton) {
        
        
        
        if (sender.titleLabel?.text == "Connect To Dialog")
        {
            let user = QBUUser()
            user.ID = self.userId
            user.password = self.userPassword
            
            QBChat.instance().connectWithUser(user, completion: { (error) -> Void in
                
                if (error == nil){
                    
                    self.personName.text = "You are now connected with \(self.personNameString)"
                    self.connectionTime.text = self.getCurrentTime()
                    
                    //print ("Connected!")
                    
                    self.connectionStatus.text = "Connected"
                    
                    self.requestVideoButtonPressed(UIButton())
                    
                    self.alert.dismissWithClickedButtonIndex(0, animated: true)
                }
                else
                {
                    
                    self.personName.text = "We hit an error :("
                    self.connectionTime.text = ""
                    //print ("NOT Connected!")
                    //self.connectionStatus.text = "NOT Connected"
                }
                
            })
        }
        else
        {
            QBChat.instance().disconnectWithCompletionBlock({ (error) -> Void in
                if (error == nil)
                {
                    
                }
                else
                {
                    //print ("***Error discronnecting: \(error?.localizedDescription)")
                }
                
            })
        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.sendMessage(UIButton())
        textField.endEditing(true)
        return true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
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
    
    func keyboardWillHide(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.bottomConstraint.constant = 0
        })
    }
    
    
    func getCurrentTime()->String{
        
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .FullStyle, timeStyle: .ShortStyle)
        
        return timestamp
        //        let date = NSDate()
        //        let formatter = NSDateFormatter()
        //        formatter.timeStyle = .FullStyle
        //        return formatter.stringFromDate(date)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func startCreatingDialogs()
    {
        if (UInt(self.filteredUsers[currentUserNumber])! != userId)
        {
            createDialogForUserAuto(UInt(self.filteredUsers[currentUserNumber])!)
        }
        else
        {
            currentUserNumber++;
            if (currentUserNumber < filteredUsers.count)
            {
                startCreatingDialogs()
            }
            else
            {
                alert.message = "No User Found"
                //alert.dismissWithClickedButtonIndex(0, animated: true)
            }
        }
        
    }
    
    
    func startCreatingDialogs(str:String)
    {
        self.currentConnectedUser = "\(str)"
        createDialogForUserAuto(UInt(str)!)
    }
    
    
    
    func createDialogForUserAuto(uid:UInt){
        
        //print ("userId: \(uid)")
        
        let chatDialog = QBChatDialog(dialogID: nil, type: QBChatDialogType.Private)
        chatDialog.name = "Chat Dialog"
        chatDialog.occupantIDs = [uid]
        
        QBRequest.createDialog(chatDialog, successBlock: { (response: QBResponse?, createdDialog : QBChatDialog?) -> Void in
            
            //print("***Response: \(createdDialog?.ID)")
            
            self.chatDialog = createdDialog!
            
            self.alert.dismissWithClickedButtonIndex(0, animated: true)
            
            self.startMakingConnection()
            
            
            }) { (responce : QBResponse!) -> Void in
                //print("***Error: \(responce)")
                
        }
        
    }
    
    @IBAction func addFriend(sender: UIBarButtonItem) {
        
        
        if (Int(userId) > Int(currentConnectedUser))
        {
            var params = ["id": "\(currentRequest)","sentby":"\(userId)" , "sendername":self.name, "receivername":self.personNameString, "friend":"\(currentConnectedUser)\(userId)", "responded":"false"]
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let client = delegate.client
            let itemTable = client.tableWithName("friends")
            
            itemTable.insert(params, completion: { (obj, error) -> Void in
                if (error == nil)
                {
                    
                    GTToast.create("   Request Sent.   ").show()
                    
                    self.addBarButton.enabled = false
                }
                else
                {
                    GTToast.create("   Request already sent.   ").show()
                    
                }
                
            });
            
            
        }
        else
        {
            var params = ["id": "\(currentRequest)", "friends":"\(userId)\(currentConnectedUser)", "sendername":self.name,"responded":"false", "receivername":self.personNameString]
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let client = delegate.client
            let itemTable = client.tableWithName("friend")
            
            itemTable.insert(params, completion: { (obj, error) -> Void in
                if (error == nil)
                {
                    
                    GTToast.create("   Request Sent.   ").show()
                    
                    self.addBarButton.enabled = false
                }
                else
                {
                    GTToast.create("   Request already sent.   ").show()
                    
                }
                
            });
        }
        
        
        
        
        
        
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