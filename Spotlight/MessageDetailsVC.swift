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
import Parse
import GoogleMobileAds

class MessageDetailsVC: UIViewController, QBChatDelegate, QBRTCClientDelegate, UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, GADInterstitialDelegate {
    
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    var accpt = false
    @IBOutlet weak var btnViewInfo: UIButton!
    var showAdd = true
    var hisImage = ""
    var myImage:String!
    @IBOutlet weak var personNameTop: UILabel!
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
    var url = "https://exchangeappreview.azurewebsites.net/"
    var requestId:String!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var loadingMessage: UILabel!
    var currentUserNumber  = 0;
    var currentRoomNumber  = 0;
    @IBOutlet weak var imageViewImage: UIImageView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var callByName: UILabel!
    @IBOutlet weak var loadingView: UIView!
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
    var json:NSDictionary!
    var isFriend:Bool = false
    var connected:Bool = false
    var recipientID:Int!
    var gender:String!
    var prefs:String!
    var allUsers:String = ""
    var moreFilteredUsers:[AnyObject]!
    var name:String = ""
    var allImgs:[String] = []
    @IBOutlet weak var topSpaceScroller: NSLayoutConstraint!
    var connectionFrom:String!
    
    @IBOutlet weak var btnVideoBtn: UIButton!
    var startingY:CGFloat = 50
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
    
    func printALL()
    {
        //print("*Contacts:  \(QBChat.instance().contactList!.contacts)")
        
        //print("*Pending:  \(QBChat.instance().contactList!.pendingApproval)")
        
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
    
    @IBOutlet weak var ad: GADBannerView!
    
    override func viewDidAppear(animated: Bool) {
        
        
        
    }
    
    @IBAction func pictureCancelPressed(sender: UIButton) {
        
    }
    @IBAction func pictureSavePressed(sender: UIButton) {
        
    }
    
    @IBAction func viewInformation(sender: UIButton) {
        
        showConnectedUserDetails(true)
    }
    func getUserInfo()
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
            else
            {
                self.requestId =  "somthing"
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
            
        }
        else
        {
            //print ("false alarm")
        }
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
    
    @IBAction func rejectCall(sender: UIButton) {
        
        session.rejectCall(nil)
        callReceivedDialog.hidden = true
        
    }
    
    
    @IBAction func closeBtnPressed(sender: UIButton) {
        
        self.imageZoom.fadeOut()
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Image has been saved to PHOTOS", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func saveImageToGallery(sender: UIButton) {
        
        UIImageWriteToSavedPhotosAlbum(imageViewZoom.image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    
    func getImage(v:UIView) -> UIImage?
    {
        
        var im = UIImage()
        for x in v.subviews{
            
            if (x.tag == 123)
            {
                return (x as! UIImageView).image!
                
            }
            else
            {
                //print ("*skipped")
            }
        }
        
        return nil
    }
    
    func handleTap(sender: UITapGestureRecognizer)
    {
        var v = sender.view
        ////print ("Found: \(getImage(v!))")
        
        var img = getImage(v!)
        if (img != nil)
        {
            
            self.imageViewZoom.image = img
            self.imageZoom.fadeIn()
            
        }
    }
    
    func nextPersonAttempt()
    {
        
        //print ("Next person attempt.")
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(true, forKey: "nextSearch")
        userDefaults.synchronize()
        
        self.showAdds()
        //self.backButtonPressed(UIButton())
        
    }
    
    @IBAction func answerCall(sender: UIButton) {
        
        QBRTCSoundRouter.instance().initialize()
        
        QBRTCSoundRouter.instance().currentSoundRoute = QBRTCSoundRoute.Speaker
        // QBRTCSoundRouter.instance().setCurrentSoundRoute(QBRTCSoundRoute.Speaker)
        
        self.videoFormat = QBRTCVideoFormat.init(width: 640, height: 480, frameRate: 30, pixelFormat: QBRTCPixelFormat.Format420f)
        
        self.videoCapture = QBRTCCameraCapture.init(videoFormat: videoFormat, position: AVCaptureDevicePosition.Front)
        
        self.videoCapture.previewLayer.frame = self.localVideo.bounds
        
        self.videoCapture.startSession()
        
        
        self.localVideo.layer.insertSublayer(self.videoCapture.previewLayer, atIndex: 0)
        
        session.acceptCall(nil)
        
        videoView.hidden = false
        
        callReceivedDialog.hidden = true
        
    }
    @IBAction func nextPersonButtonPressed(sender: UIButton) {
        
        
        
        if (sender.titleLabel?.text?.lowercaseString == "next")
        {
            
            self.nextPersonView.hidden = false
            
            self.nextpersonname.text = "Are you sure you want to next \(self.thisUserName)?"
            sender.setTitle("SURE?", forState: .Normal)
            
            if (self.timet < 10)
            {
                self.reportView.hidden = false
            }
            
        }
        else
        {
            
            self.userLeftImage.hidden = true
            self.userHasLeft.hidden = true
            sender.setTitle("NEXT", forState: .Normal)
            if (self.session != nil)
            {
                self.session.hangUp(nil)
                //print ("Call hanged up.")
                
            }
            
            self.videoView.hidden = true
            
            if QBChat.instance().isConnected() {
                QBChat.instance().disconnectWithCompletionBlock { (error: NSError?) -> Void in
                    
                    
                    
                }
            }
            
            self.continueState = false
            self.nextPersonAttempt()
        }
        
        
        
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
    
    func session(session: QBRTCSession!, connectionClosedForUser userID: NSNumber!) {
        
        //print ("Connection closed for user: \(userID)")
        
    }
    
    func sessionDidClose(session: QBRTCSession!) {
        
        QBRTCClient.deinitializeRTC()
        
        QBRTCSoundRouter.instance().deinitialize()
        
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        
        
        
        
        if (self.session != nil)
        {
            self.session.hangUp(["":""])
            
            
        }
        if QBChat.instance().isConnected() {
            QBChat.instance().disconnectWithCompletionBlock { (error: NSError?) -> Void in
                self.deleteRequestsFor()
                
                self.connected = false
                QBRTCClient.deinitializeRTC()
                
                QBRTCSoundRouter.instance().deinitialize()
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }
            
        }
        else
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
    }
    
    @IBAction func addFriendButtonPressed(sender: UIButton) {
        
        //print ("ThisUserName: \(self.thisUserName)")
        //print ("currentConnectedUserName: \(self.name)")
        
        
        if (self.name.contains("Anonymous"))
        {
            GTToast.create("You need to update your information first").show()
        }
        else if (self.thisUserName.contains("Anonymous"))
        {
            GTToast.create("You cannot add a Anonymous user").show()
        }
        else
        {
            
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
        
        
        
        
        
        
        //        if (Int(userId) > Int(currentConnectedUser))
        //        {
        //            var params = ["id": "\(currentRequest)","sentby":"\(userId)" , "sendername":self.name, "receivername":self.personNameString, "friend":"\(currentConnectedUser)\(userId)", "responded":"false"]
        //            
        //            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //            let client = delegate.client
        //            let itemTable = client.tableWithName("friends")
        //            
        //            itemTable.insert(params, completion: { (obj, error) -> Void in
        //                if (error == nil)
        //                {
        //                    
        //                    GTToast.create("   Request Sent.   ").show()
        //                    
        //                    sender.enabled = false
        //                    sender.hidden = true
        //                }
        //                else
        //                {
        //                    GTToast.create("   Request already sent.   ").show()
        //                    
        //                }
        //                
        //            });
        //            
        //            
        //        }
        //        else
        //        {
        //            var params = ["id": "\(currentRequest)", "friends":"\(userId)\(currentConnectedUser)", "sendername":self.name,"responded":"false", "receivername":self.personNameString]
        //            
        //            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //            let client = delegate.client
        //            let itemTable = client.tableWithName("friend")
        //            
        //            itemTable.insert(params, completion: { (obj, error) -> Void in
        //                if (error == nil)
        //                {
        //                    
        //                    GTToast.create("   Request Sent.   ").show()
        //                    
        //                    sender.enabled = false
        //                    sender.hidden = true
        //                }
        //                else
        //                {
        //                    GTToast.create("   Request already sent.   ").show()
        //                    
        //                }
        //                
        //            });
        //        }
        
    }
    
    @IBAction func requestVideoButtonPressed(sender: UIButton) {
        
        if (self.connectionStatus.text != "connecting")
        {
            startVideoSession()
        }
        else
        {
            GTToast.create("Please wait for the connection.").show()
        }
        
    }
    
    
    var videoFormat:QBRTCVideoFormat!
    
    
    
    func chatDidConnect() {
        
        //print ("Chat Did Connect")
        
        
        self.chatDialog.onUserIsTyping = {
            
            
            [weak self] (userID)-> Void in
            
            self!.connectionStatus.text = "\(self!.thisUserName) is typing..."
            
            
        }
        
        self.chatDialog.onUserStoppedTyping = {
            
            
            [weak self] (userID)-> Void in
            
            self!.connectionStatus.text = "Connected"
            
            
            
            
        }
        
        self.connectionStatus.text = "Connected"
        
        btnVideoBtn.enabled = true
        
        connectButton.titleLabel?.text = "Disconnect from Dialog"
        
        
    }
    @IBAction func nextPressed(sender: UIBarButtonItem) {
        
        
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
        
        if (QBChat.instance().isConnected())
        {
            startVideoSession()
        }
        else{
            GTToast.create("Connection not establisted yet...")
        }
    }
    
    @IBAction func requestVideo(sender: UIButton) {
        
        if (QBChat.instance().isConnected())
        {
            GTToast.create("Video Request Sent. Please wait").show()
            startVideoSession()
        }
        else{
            GTToast.create("Connection not establisted yet...")
        }
        
    }
    
    
    func session(session: QBRTCSession!, initializedLocalMediaStream mediaStream: QBRTCMediaStream!) {
        
        if (mediaStream != nil){
            mediaStream.videoTrack.videoCapture = capture
        } else{
            GTToast.create("Problem with your video").show()
        }
        
    }
    
    
    
    func chatDidAccidentallyDisconnect() {
        
        connectButton.titleLabel?.text = "Connect To Dialog"
        
        
    }
    
    @IBAction func backFromVideo(sender: UIBarButtonItem) {
        
        
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
        
        if (chatDialog != nil)
        {
            chatDialog.sendUserIsTyping()
        }
        
        
    }
    
    
    func session(session: QBRTCSession!, acceptedByUser userID: NSNumber!, userInfo: [NSObject : AnyObject]!) {
        //print ("***accepted by user")
        
        loadingMessage.text = "Accepted by user..."
        
        GTToast.create("Video Request Accepted by \(self.thisUserName)").show()
        
        
        
    }
    
    func session(session: QBRTCSession!, rejectedByUser userID: NSNumber!, userInfo: [NSObject : AnyObject]!) {
        
        loadingMessage.text = "Rejected by user..."
        GTToast.create("Video Request Rejected by \(self.thisUserName)")
        videoView.hidden = true
        
    }
    
    func session(session: QBRTCSession!, startedConnectingToUser userID: NSNumber!) {
        //print ("***started connecting to user")
        loadingMessage.text = "Attempting to connect..."
        loadingView.hidden = false
    }
    
    
    func session(session: QBRTCSession!, connectedToUser userID: NSNumber!) {
        //print ("***connected to user")
        loadingMessage.text = "Connected to User"
        loadingView.hidden = true
        
        self.connectionStatus.text = "Connected"
        
        videoView.hidden = false
        
        self.session = session
        
        if (self.session.localMediaStream != nil)
        {
            
            self.session.localMediaStream.videoTrack.enabled = true
            self.session.localMediaStream.videoTrack.videoCapture = self.videoCapture
        }
    }
    
    @IBOutlet weak var dash1: UIImageView!
    @IBOutlet weak var dash2: UIImageView!
    @IBOutlet weak var dash3: UIImageView!
    @IBOutlet weak var dash4: UIImageView!
    @IBOutlet weak var dash5: UIImageView!
    
    
    @IBOutlet weak var callReceivedImage: PASImageView!
    
    func session(session: QBRTCSession!, userDidNotRespond userID: NSNumber!) {
        //print ("***user didn't respond")
        loadingMessage.text = "User didn't respond"
        
        GTToast.create("\(self.thisUserName) didn't respond.")
    }
    
    
    
    func session(session: QBRTCSession!, receivedRemoteVideoTrack videoTrack: QBRTCVideoTrack!, fromUser userID: NSNumber!) {
        
        loadingView.hidden = true
        
        if (videoTrack != nil)
        {
            
        }
        else
        {
            GTToast.create("Blank video received.")
            //print ("*********************BLANK received Video Track")
        }
        
        //print ("*********************received Video Track")
        self.otherVideo.setVideoTrack(videoTrack)
        self.loadingMessage.text = "Received Video Track..."
        
        //session.acceptCall(nil)
    }
    
    func session(session: QBRTCSession!, hungUpByUser userID: NSNumber!, userInfo: [NSObject : AnyObject]!) {
        //print ("***hangup by user")
        
        videoView.hidden = true
        loadingMessage.text = "User Hanged Up."
        
    }
    
    
    func didReceiveNewSession(session: QBRTCSession!, userInfo: [NSObject : AnyObject]!) {
        
        //print ("***Call Received.")
        
        
        
        self.session = session
        
        
        self.callReceivedImage.backgroundColor = UIColor.clearColor()
        
        self.callReceivedImage.progressColor = UIColor.clearColor()
        
        self.callReceivedImage.imageURL(NSURL(string: "\(self.hisImage)")!)
        
        self.callByName.text = self.thisUserName
        
        self.callReceivedDialog.hidden = false
        
        if (self.connectionFrom == "Video")
        {
            self.answerCall(UIButton())
        }
        
    }
    
    
    @IBOutlet weak var userHasLeft: UILabel!
    
    
    func sendImage(img:UIImage)
    {
        
        self.loadingMessage.text = "Uploading Image"
        
        self.loadingView.hidden = false
        
        var imageData = UIImageJPEGRepresentation(img, 5)
        
        
        QBRequest.TUploadFile(imageData!, fileName: "\(userId)-\(NSDate(timeIntervalSinceNow: 0))", contentType: "image/jpg", isPublic: false, successBlock: { (response:QBResponse, block:QBCBlob) -> Void in
            
            self.loadingMessage.text = "****Done Uploading..."
            
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
                self.loadingMessage.text = "Uploading: \(Int(block.1!.percentOfCompletion*100))/100%"
                
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
        
        
        GTToast.create("Video Requested. Please wait!").show()
        
        
        loadingMessage.text = "Initializing..."
        
        //loadingView.hidden = false
        let session = QBRTCClient.instance().createNewSessionWithOpponents(self.chatDialog.occupantIDs, withConferenceType: QBRTCConferenceType.Video)
        
        
        QBRTCSoundRouter.instance().initialize()
        
        QBRTCSoundRouter.instance().currentSoundRoute = QBRTCSoundRoute.Speaker
        // QBRTCSoundRouter.instance().setCurrentSoundRoute(QBRTCSoundRoute.Speaker)
        
        
        
        
        self.videoFormat = QBRTCVideoFormat.init(width: 1600    , height: 900, frameRate: 30, pixelFormat: QBRTCPixelFormat.Format420f)
        
        self.videoCapture = QBRTCCameraCapture.init(videoFormat: videoFormat, position: AVCaptureDevicePosition.Front)
        
        self.videoCapture.previewLayer.frame = self.localVideo.bounds
        
        self.videoCapture.startSession()
        
        self.localVideo.layer.insertSublayer(self.videoCapture.previewLayer, atIndex: 0)
        
        
        //GTToast.create("Call Request Sent. Please wait").show()
        
        QBRTCSoundRouter.instance().initialize()
        
        QBRTCSoundRouter.instance().currentSoundRoute = QBRTCSoundRoute.Speaker
        // QBRTCSoundRouter.instance().setCurrentSoundRoute(QBRTCSoundRoute.Speaker)
        
        session.startCall(nil)
        
        //loadingView.hidden = true
        
        
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        pass = 0
        sendImage(image)
        
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    var pass = 0;
    @IBAction func selectPicture(sender: UIButton) {
        
        pass = 1
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func getAllBlocks(id:String)
    {
        //print ("Checking blocks for: \(id)")
        
        var rS = ""
        
        Alamofire.request(.POST, "https://exchangeappreview.azurewebsites.net/Spotlight/blocked_by_user.php", parameters: ["id":id]).responseJSON { response in
            
            if (response.result.error == nil)
            {
                //print("BLOCKERS:  \(response)")
                
                let json  = response.result.value as? NSDictionary
                
                rS = json?.valueForKey("returning") as! String
                
                if (rS.rangeOfString("\(self.userId)") != nil)
                {
                    
                    //print("Contains")
                }
                else{
                    //print("Not Contains")
                }
                
                
            }
            
            
            
        }
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
                
                //pic.imageURL(NSURL(string: self.myImage)!)
                if (self.myImage == "image")
                {
                    if (self.thisUserGender == "M")
                    {
                        pic.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png")!)
                    }
                    else
                    {
                        pic.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png")!)
                    }
                }
                else{
                    pic.imageURL(NSURL(string: self.myImage)!)
                }
                
                
                self.startingY += chatBubble.layer.frame.height + 30
                
                if (self.chatScrollView.contentSize.height < (self.startingY))
                {
                    self.chatScrollView.contentSize = CGSizeMake(self.view.frame.width, self.startingY)
                }
                
                
                
                chatBubble.tag = self.allImagesUrls.count
                
                
                let imageTap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
                
                chatBubble.addGestureRecognizer(imageTap)
                
                self.allImagesUrls.append(privateUrl)
                
                self.chatScrollView.addSubview(chatBubble)
                
                self.chatScrollView.addSubview(pic)
                
                self.scrollToBottom()
                
                
                
                
                
                if (self.connectionFrom == "Messages")
                {
                    let push = PFPush()
                    push.setChannel("P-\(self.currentConnectedUser)")
                    
                    push.setMessage("\(self.name) sent you a message.")
                    push.sendPushInBackground()
                    
                    //                {
                    //                    
                    //                    //print ("Self.name: \(self.name)");
                    //                    QBRequest.sendPushWithText("\(self.name) sent you a message.", toUsers: "\(self.currentConnectedUser)", successBlock: { (response, event) in
                    //                        
                    //                        //print ("push sent to \(self.currentConnectedUser)")
                    //                        
                    //                        
                    //                        
                    //                        }, errorBlock: { (error) in
                    //                            
                    //                            //print ("Error sending  to \(self.currentConnectedUser)")
                    //                            
                    //                    })
                    
                    
                }
                
                
                
                
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
                
                //pic.imageURL(NSURL(string: self.myImage)!)
                
                if (self.myImage == "image")
                {
                    if (self.thisUserGender == "M")
                    {
                        pic.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png")!)
                    }
                    else
                    {
                        pic.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png")!)
                    }
                }
                else{
                    pic.imageURL(NSURL(string: self.myImage)!)
                }
                
                
                
                self.startingY += chatBubble.layer.frame.height + 30
                
                if (self.chatScrollView.contentSize.height < (self.startingY))
                {
                    self.chatScrollView.contentSize = CGSizeMake(self.view.frame.width, self.startingY)
                }
                
                self.chatScrollView.addSubview(chatBubble)
                
                self.chatScrollView.addSubview(pic)
                
                self.scrollToBottom()
                
                let push = PFPush()
                push.setChannel("P-\(self.currentConnectedUser)")
                push.setMessage("\(self.name) sent you a message.")
                push.sendPushInBackground()
                
                
                
                if (self.connectionFrom == "Messages")
                {
                    
                    //print ("Self.name: \(self.name)");
                    QBRequest.sendPushWithText("\(self.name) sent you a message.", toUsers: "\(self.currentConnectedUser)", successBlock: { (response, event) in
                        
                        //print ("push sent to \(self.currentConnectedUser)")
                        
                        
                        
                        }, errorBlock: { (error) in
                            
                            //print ("Error sending  to \(self.currentConnectedUser)")
                            
                    })
                    
                    
                }
                
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
        //print ("Getting Prev msgs")
        var n = UInt(0)
        QBRequest.countOfMessagesForDialogID(chatDialog.ID!, extendedRequest: nil, successBlock: { (rp:QBResponse, number:UInt) -> Void in
            
            //print ("\(number) of messages received")
            n = number
            
            self.getPreviousMessages(n, startingFrom: 0)
            
            }, errorBlock:  {
                (errorResponse) -> Void in
                
                //print ("Error while Receiving number of messages:\(errorResponse.debugDescription)")
                
        })
        
        
    }
    
    
    func getPreviousMessages(total:UInt, startingFrom:UInt)
    {
        
        ////print ("YYY: \(self.startingY)")
        
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
                        
                        //pic.imageURL(NSURL(string: self.myImage)!)
                        
                        if (self.myImage == "image")
                        {
                            if (self.thisUserGender == "M")
                            {
                                pic.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png")!)
                            }
                            else
                            {
                                pic.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png")!)
                            }
                        }
                        else{
                            pic.imageURL(NSURL(string: self.myImage)!)
                        }
                        
                        
                        self.chatScrollView.addSubview(pic)
                        
                        self.startingY += chatBubble.layer.frame.height + 30
                        
                        if (self.chatScrollView.contentSize.height < (self.startingY))
                        {
                            self.chatScrollView.contentSize = CGSizeMake(self.view.frame.width, self.startingY)
                        }
                        
                        
                        
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
                        
                        if (self.hisImage == "image")
                        {
                            if (self.thisUserGender == "M")
                            {
                                pic.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png")!)
                            }
                            else
                            {
                                pic.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png")!)
                            }
                        }
                        else{
                            pic.imageURL(NSURL(string: self.hisImage)!)
                        }
                        
                        
                        self.chatScrollView.addSubview(pic)
                        
                        self.startingY += chatBubble.layer.frame.height + 30
                        
                        if (self.chatScrollView.contentSize.height < (self.startingY))
                        {
                            self.chatScrollView.contentSize = CGSizeMake(self.view.frame.width, self.startingY)
                        }
                        
                        
                        
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
                        
                        
                        if (self.myImage == "image")
                        {
                            if (self.thisUserGender == "M")
                            {
                                pic.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png")!)
                            }
                            else
                            {
                                pic.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png")!)
                            }
                        }
                        else{
                            pic.imageURL(NSURL(string: self.myImage)!)
                        }
                        
                        
                        //pic.imageURL(NSURL(string: self.myImage)!)
                        
                        chatBubble.tag = self.allImagesUrls.count
                        
                        
                        
                        let imageTap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
                        
                        chatBubble.addGestureRecognizer(imageTap)
                        
                        self.allImagesUrls.append(privateUrl)
                        
                        self.chatScrollView.addSubview(pic)
                        
                        self.startingY += chatBubble.layer.frame.height + 30
                        
                        if (self.chatScrollView.contentSize.height < (self.startingY))
                        {
                            self.chatScrollView.contentSize = CGSizeMake(self.view.frame.width, self.startingY)
                        }
                        
                        
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
                        
                        // pic.imageURL(NSURL(string: self.hisImage)!)
                        
                        if (self.hisImage == "image")
                        {
                            if (self.thisUserGender == "M")
                            {
                                pic.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png")!)
                            }
                            else
                            {
                                pic.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png")!)
                            }
                        }
                        else{
                            pic.imageURL(NSURL(string: self.hisImage)!)
                        }
                        
                        
                        chatBubble.tag = self.allImagesUrls.count
                        
                        
                        let imageTap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
                        
                        chatBubble.addGestureRecognizer(imageTap)
                        
                        self.allImagesUrls.append(privateUrl)
                        
                        self.chatScrollView.addSubview(pic)
                        
                        self.startingY += chatBubble.layer.frame.height + 30
                        
                        if (self.chatScrollView.contentSize.height < (self.startingY))
                        {
                            self.chatScrollView.contentSize = CGSizeMake(self.view.frame.width, self.startingY)
                        }
                        
                        self.chatScrollView.addSubview(chatBubble)
                        self.scrollToBottom()
                        
                        
                        self.view.bringSubviewToFront(self.btnViewInfo)
                        
                    }
                }
                
                
                
            }
            
            
        }) { (errorResponse) -> Void in
            
            //print ("Error while Receiving the messages:\(errorResponse.debugDescription)")
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if (self.showAdd)
        {
            if (!self.thisUserPro)
            {
                //print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
                
                ad.adUnitID = "ca-app-pub-2891096036722966/5826607539"
                ad.rootViewController = self
                ad.loadRequest(GADRequest())
                
                self.showAdds()
            }
        }
        
        if (!back)
        {
            
        }
        else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    @IBAction func cancelReport(sender: UIButton) {
        
        self.reportView.hidden = true
        
    }
    @IBAction func report(sender: UIButton) {
        self.reportView.hidden = false
        
    }
    
    
    
    func reportuser(id:String, s:String)
    {
        self.reportView.hidden = true
        alert = UIAlertView()
        alert.title = "Please wait"
        alert.message = "Submitting Report"
        alert.show()
        
        var params = ["userId":id, "points": "-10", "reporter":s]
        
        //print("reporting ** params:  \(params)")
        
        var apiCall = "https://exchangeappreview.azurewebsites.net/Spotlight/report_user.php"
        
        Alamofire.request(.POST, apiCall, parameters: params).responseJSON {
            response in
            
            
            self.alert.dismissWithClickedButtonIndex(0, animated: true)
            
            //            self.alert.dismissWithClickedButtonIndex(0, animated: true)
            //            var json  = response.result.value as? NSDictionary
            //            let status =  json?.valueForKey("status") as! Int
            //            
            //            if (status == 1)
            //            {
            //                //                self.alert = UIAlertView()
            //                //                self.alert.title = "Report"
            //                //                self.alert.message = "Report has been submitted"
            //                //                self.alert.addButtonWithTitle("Ok")
            //                //self.alert.show()
            //                
            //                GTToast.create("Report has been submitted")
            //                
            //                //self.blockPerm("\(id)", myId: "\(s)")
            //                
            //            }
            //            else
            //            {
            //                //                self.alert = UIAlertView()
            //                //                self.alert.title = "Report"
            //                //                self.alert.message = "You have already reported this user."
            //                //                self.alert.addButtonWithTitle("Ok")
            //                //                self.blockPerm("\(id)", myId: "\(s)")
            //                //                self.alert.show()
            //                
            //                GTToast.create("You have already reported this user.")
            //            }
            //            
            
            //nextBtnP
            self.userLeftImage.hidden = true
            self.userHasLeft.hidden = true
            //sender.setTitle("NEXT", forState: .Normal)
            if (self.session != nil)
            {
                self.session.hangUp(nil)
                //print ("Call hanged up.")
                
            }
            
            self.videoView.hidden = true
            
            if QBChat.instance().isConnected() {
                QBChat.instance().disconnectWithCompletionBlock { (error: NSError?) -> Void in
                    
                    
                    
                }
            }
            
            self.continueState = false
            self.nextPersonAttempt()
            
        }
    }
    
    @IBAction func reportConfirm(sender: UIButton) {
        
        reportuser("\(self.currentConnectedUser)", s: "\(self.userId)")
        self.reportView.hidden = true
        
    }
    
    var interstitial: GADInterstitial!
    
    func addShadow(vi:UIView)
    {
        vi.layer.shadowOffset = CGSizeMake(0, 0)
        vi.layer.shadowRadius = 8.0
        vi.layer.shadowOpacity = 0.8
        vi.layer.borderWidth = 1
        vi.layer.borderColor = UIColor(netHex:0x08142a).CGColor
    }
    
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var closeReport: UIButton!
    func showAdds()
    {
        
        if (self.interstitial.isReady && self.showAdd && !self.thisUserPro)
        {
            self.interstitial.presentFromRootViewController(self)
        }
        else
        {
            self.backButtonPressed(UIButton())
        }
    }
    
    func chatDidReceiveContactItemActivity(userID: UInt, isOnline: Bool, status: String?) {
        
        //print ("*Contact Actrivity: \(userID) isOnline: \(isOnline) status: \(status)")
        
        if (isOnline){
            //            //print ("\(self.thisUserName) has joined.")
            //            self.connectionStatus.text = "\(self.thisUserName) has joined."
        }
        else{
            if ("\(userID)" == self.currentConnectedUser)
            {
                //print ("\(self.thisUserName) has left.")
                self.connectionStatus.text = "\(self.thisUserName) has left."
                
                self.userHasLeft.text = "\(self.thisUserName) has left."
                self.userHasLeft.hidden = false
                self.userLeftImage.hidden = false
                self.left = true
                
                self.getAllBlocks("\(self.userId)")
            }
            
            
            
            
        }
        
        
    }
    
    
    @IBOutlet weak var imageInfo: PASImageView!
    
    
    func chatDidReceiveSystemMessage(message: QBChatMessage) {
        
        //print ("message: \(message.text)")
        connectionStatus.text = message.text!
    }
    
    
    func chatDidReceiveMessage(message: QBChatMessage) {
        
        QBRequest.markMessagesAsRead([message.ID!], dialogID: self.chatDialog.ID! , successBlock: { (response) in
            
            
            
            
        }) { (errorresponse) in
            
            
        }
        
        
        if (message.attachments == nil)
        {
            addMessageReceivedWithoutAttachment(message)
        }
        else
        {
            addMessageReceivedWithAttachment(message)
        }
        
    }
    
    func makeDashInvisible()
    {
        self.topSpace.constant = -10
        
        self.btnViewInfo.hidden = false
        self.connectionTime.hidden = true
        self.personName.hidden = true
        self.dash1.hidden = true
        self.dash2.hidden = true
        self.dash3.hidden = true
        self.dash4.hidden = true
        self.dash5.hidden = true
        
        self.nextBtn1.hidden = true
        self.nextBtn2.hidden = true
        self.addFriend1.hidden = true
        self.addFriend2.hidden = true
    }
    
    func makeDashVisible()
    {
        
        self.dash1.hidden = false
        self.dash2.hidden = false
        self.dash3.hidden = false
        self.dash4.hidden = false
        self.dash5.hidden = false
        
        self.nextBtn1.hidden = false
        self.nextBtn2.hidden = false
        self.addFriend1.hidden = false
        self.addFriend2.hidden = false
    }
    
    
    
    func addMessageReceivedWithoutAttachment(message:QBChatMessage)
    {
        //print ("Message Received: \(message.text)")
        
        
        var chatBubbleData = ChatBubbleData(text: message.text, image: nil, date: NSDate(), type: BubbleDataType.Opponent)
        
        var chatBubble = ChatBubble(data: chatBubbleData, startX:oppStartingX, startY: self.startingY)
        
        
        var pic = PASImageView(frame: CGRect(x: 10 , y: Int(self.startingY)-10, width: 40, height: 40))
        
        pic.backgroundColor = UIColor.clearColor()
        
        pic.progressColor = UIColor.clearColor()
        
        //pic.imageURL(NSURL(string: self.hisImage)!)
        
        if (self.hisImage == "image")
        {
            if (self.thisUserGender == "M")
            {
                pic.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png")!)
            }
            else
            {
                pic.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png")!)
            }
        }
        else{
            pic.imageURL(NSURL(string: self.hisImage)!)
        }
        
        
        self.startingY += chatBubble.layer.frame.height + 30
        
        if (self.chatScrollView.contentSize.height < (self.startingY))
        {
            self.chatScrollView.contentSize = CGSizeMake(self.view.frame.width, self.startingY)
        }
        
        self.chatScrollView.addSubview(chatBubble)
        
        self.chatScrollView.addSubview(pic)
        
        scrollToBottom()
    }
    
    func addMessageReceivedWithAttachment(message:QBChatMessage)
    {
        
        self.loadingView.hidden = true
        
        self.loadingMessage.text = "Downloading Image..."
        
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
        
        //pic.imageURL(NSURL(string: self.hisImage)!)
        
        if (self.hisImage == "image")
        {
            if (self.thisUserGender == "M")
            {
                pic.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png")!)
            }
            else
            {
                pic.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png")!)
            }
        }
        else{
            pic.imageURL(NSURL(string: self.hisImage)!)
        }
        
        
        
        self.startingY += chatBubble.layer.frame.height + 30
        
        if (self.chatScrollView.contentSize.height < (self.startingY))
        {
            self.chatScrollView.contentSize = CGSizeMake(self.view.frame.width, self.startingY)
        }
        
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
        
        if (self.startingY > 300)
        {
            var bottomOffset = CGPointMake(0, self.chatScrollView.contentSize.height - self.chatScrollView.bounds.size.height);
            
            self.chatScrollView.setContentOffset(bottomOffset, animated: true)
            
        }
        else
        {
            self.scrollToTop()
        }
        
    }
    
    var thisUserName:String = ""
    var thisUserAge:String = ""
    var thisUserCity:String = ""
    var thisUserCountry:String = ""
    var thisUserPic:String = ""
    var thisUserGender:String = ""
    
    
    
    
    
    var thisUserPro = false
    
    
    //    func allInfo()
    //    {
    //    
    //        //print ("GET BABY RETURNED TRUE")
    //        
    //        
    //        if  (json?.valueForKey("id") as? String != nil)
    //        {
    //            self.currentConnectedUser = json?.valueForKey("id") as! String
    //            
    //            if ((json?.valueForKey("full_name") as? String != nil))
    //            {
    //                self.thisUserName =  json?.valueForKey("full_name") as! String
    //            }
    //            
    //            if ((json?.valueForKey("vip") as? Bool != nil))
    //            {
    //                self.thisUserPro =  json?.valueForKey("vip") as! Bool
    //            }
    //            
    //            
    //            
    //            
    //            if ( json?.valueForKey("requestId") as? String != nil){
    //                self.requestId =  json?.valueForKey("requestId") as! String
    //            }
    //            else
    //            {
    //                self.requestId =  "somthing"
    //            }
    //            
    //            if ( json?.valueForKey("age") as? String != nil){
    //                self.thisUserAge =  json?.valueForKey("age") as! String
    //            }
    //            
    //            if ( json?.valueForKey("city") as? String != nil)
    //            {
    //                self.thisUserCity =  json?.valueForKey("city") as! String
    //            }
    //            
    //            if (json?.valueForKey("country") as? String != nil)
    //            {
    //                self.thisUserCountry =  json?.valueForKey("country") as! String
    //            }
    //            
    //            if (json?.valueForKey("profile_pic") as? String != nil)
    //            {
    //                self.thisUserPic =  json?.valueForKey("profile_pic") as! String
    //            }
    //            
    //            if (json?.valueForKey("gender") as? String != nil)
    //            {
    //                self.thisUserGender =  json?.valueForKey("gender") as! String
    //            }
    //            
    //        }
    //    }
    
    @IBOutlet weak var infoLocation: UILabel!
    @IBOutlet weak var imgGender: UIImageView!
    func showConnectedUserDetails(btnPressed:Bool){
        
        //print ("*CONNECTED*")
        
        
        getUserInfo()
        
        self.personName.text = "You are now connected with \(self.thisUserName)"
        
        if (self.thisUserGender == "M")
        {
            self.genderInfo.text = "Male"
            self.imgGender.image = UIImage(named: "btn-male")
        }
        else
        {
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
        
        if (self.myImage == "image")
        {
            if (self.thisUserGender == "M")
            {
                
                self.myImage = "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png"
                
            }else
            {
                
                self.myImage = "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png"
                
            }
            
            
        }
        
        
        if (self.thisUserPic == "image")
        {
            if (self.thisUserGender == "M")
            {
                
                self.imageInfo.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png")!)
                self.proInfoImage.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png")!)
                
                self.hisImage = "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-male.png"
                
            }else
            {
                
                self.imageInfo.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png")!)
                self.proInfoImage.imageURL(NSURL(string: "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png")!)
                
                self.hisImage = "https://exchangeappreview.azurewebsites.net/Spotlight/profilePictures/default-female.png"
                
            }
            
            
            
            
        }else
        {
            ////print ("* * * *\(self.connectedUserDetails[7] as! String)")
            self.imageInfo.imageURL(NSURL(string: self.thisUserPic)!)
            self.proInfoImage.imageURL(NSURL(string: self.thisUserPic)!)
            
            self.hisImage = self.thisUserPic
            
        }
        
        //print ("My Image: \(self.myImage)")
        
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
        
        if (self.connectionFrom != "Messages" || btnPressed)
        {
            userInfoView.hidden = false
        }
        
        
        if (self.thisUserName.contains("Anonymous"))
        {
            self.genderInfo.text = "-"
            self.ageInfo.text = "-"
            self.infoLocation.text = "-"
            self.imgGender.hidden = true
        }
        else
        {
            self.imgGender.hidden = false
        }
        
        
        
        NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "dismissUserinfo", userInfo: nil, repeats: false)
        
        var u:String = ""
        
        
        
    }
    func dismissUserinfo()
    {
        
        self.userInfoView.fadeOut()
    }
    
    @IBAction func nextPersonYes(sender: UIButton) {
        
        self.nextPersonView.hidden = true
        self.userLeftImage.hidden = true
        self.userHasLeft.hidden = true
        sender.setTitle("NEXT", forState: .Normal)
        if (self.session != nil)
        {
            self.session.hangUp(nil)
            //print ("Call hanged up.")
            
        }
        
        self.videoView.hidden = true
        
        if QBChat.instance().isConnected() {
            QBChat.instance().disconnectWithCompletionBlock { (error: NSError?) -> Void in
                
                
                
            }
        }
        
        self.continueState = false
        self.nextPersonAttempt()
        
    }
    @IBAction func nextPersonNo(sender: UIButton) {
        
        self.nextPersonView.hidden = true
    }
    @IBOutlet weak var nextPersonView: UIView!
    @IBOutlet weak var nextpersonname: UILabel!
    func getUserDetails()
    {
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
        alert.show()
        
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
                
                if (!self.peopleDone.containsString("\(u.ID)"))
                {
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
            self.alert.show()
            
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
                            //self.getFriendRequest()
                        }
                        
                    }
                }
            })
            
        }
        
        
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
    
    
    func addFriendAzure()
    {
        
        if (self.thisUserName.contains("Anonymous"))
        {
            GTToast.create("You need to update your information first").show()
        }
        else if (self.currentConnectedUserName.contains("Anonymous"))
        {
            GTToast.create("You cannot add a Anonymous user").show()
        }
        else
        {
            
            var params = [  "sentby"        :   self.currentConnectedUser,
                            "friend"        :   "\(self.currentConnectedUser)\(userId)",
                            "sendername"    :   self.thisUserName,
                            "receivername"  :   self.name ,
                            "responded"     :   "true",
                            "accepted"      :   "true"      ]
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let client = delegate.client
            let itemTable = client.tableWithName("friends")
            
            itemTable.insert(params, completion: { (obj, error) -> Void in
                if (error == nil)
                {
                    
                    GTToast.create("Request Accepted.").show()
                    self.friendRequestDialog.hidden = true
                }
                else{
                    GTToast.create("Couldn't be accepted.").show()
                }
                
            });
            
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
    
    func chatDidReceiveAcceptContactRequestFromUser(userID: UInt) {
        
        //print ("Request Accepted")
        
        //print ("Checking \(userID) == \(self.userId)")
        if ("\(userID)" != "\(self.userId)" )
        {
            if (!accpt)
            {
                GTToast.create("\(self.thisUserName) accepted your request").show()
            }
            else{
                accpt = false
            }
            
        }
        
    }
    
    func chatDidReceiveRejectContactRequestFromUser(userID: UInt)
    {
        
        //print ("Request Rejected")
        if (userID != self.userId )
        {
            GTToast.create("\(self.thisUserName) rejected your request").show()
        }
    }
    
    func chatDidReceiveContactAddRequestFromUser(userID: UInt) {
        
        self.requestyName.text = self.thisUserName
        self.friendRequestDialog.hidden = false
    }
    
    var currentRequest:String = ""
    var currentRequestyId:String = ""
    
    
    
    @IBAction func acceptRequest(sender: UIButton) {
        // respondRequestAccept()
        
        acceptFriendRequestButtonPressed(UIButton())
    }
    
    @IBAction func rejectRequest(sender: UIButton) {
        //  respondRequestReject()
        
        rejectFriendRequestButtonPressed(UIButton())
    }
    
    @IBOutlet weak var requestyName: UILabel!
    
    func matchSpecifications(allUsers:String)
    {
        
        self.filteredUsers = [];
        self.alert = UIAlertView()
        self.alert.title = "Please wait"
        self.alert.message = "while we look for a perfect match..."
        self.alert.show()
        
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
                self.alert.show()
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
        currentSeconds = 60
        //print ("Creating Room...")
        self.alert.dismissWithClickedButtonIndex(0, animated: true)
        self.alert = UIAlertView()
        self.alert.title = "Please wait"
        self.alert.message = "Creating room"
        self.alert.show()
        
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
                self.waitingDialog.hidden = false
                self.updateTimeByOne()
                
            }
            else
            {
                //print ("Error Creating room.")
                self.alert = UIAlertView()
                self.alert.title = "Error"
                self.alert.message = "We hit an error."
                self.alert.addButtonWithTitle("OK")
                self.alert.show()
            }
        }
    }
    
    
    func session(session: QBRTCSession!, updatedStatsReport report: QBRTCStatsReport!, forUserID userID: NSNumber!) {
        
        
        var result = ""
        var systemStatsFormat = "(cpu)%ld%%\n"
        
        
        //result.append(NSString.localizedStringWithFormat(systemStatsFormat,  ))
        
        var connStatsFormat = "CN %@ms | %@->%@/%@ | (s)%@ | (r)%@\n"
        
        var s = NSString(format: connStatsFormat, report.connectionRoundTripTime,
                         report.localCandidateType, report.remoteCandidateType, report.transportType,
                         report.connectionSendBitrate, report.connectionReceivedBitrate)
        
        result = "\(result)\(s)"
        
        
        if (session.conferenceType == QBRTCConferenceType.Video) {
            
            
            // Video send stats.
            var videoSendFormat = "VS (input) %@x%@@%@fps | (sent) %@x%@@%@fps\n"
            videoSendFormat = "\(videoSendFormat)VS (enc) %@/%@ | (sent) %@/%@ | %@ms | %@\n"
            
            var s1 =  NSString(format: videoSendFormat,report.videoSendInputWidth, report.videoSendInputHeight, report.videoSendInputFps,
                               report.videoSendWidth, report.videoSendHeight, report.videoSendFps,
                               report.actualEncodingBitrate, report.targetEncodingBitrate,
                               report.videoSendBitrate, report.availableSendBandwidth,
                               report.videoSendEncodeMs,
                               report.videoSendCodec)
            
            result = "\(result)\(s1)"
            
            // Video receive stats.
            var videoReceiveFormat = "VR (recv) %@x%@@%@fps | (decoded)%@ | (output)%@fps | %@/%@ | %@ms\n"
            
            var s2 =  NSString(format: videoReceiveFormat, report.videoReceivedWidth, report.videoReceivedHeight, report.videoReceivedFps,
                               report.videoReceivedDecodedFps,
                               report.videoReceivedOutputFps,
                               report.videoReceivedBitrate, report.availableReceiveBandwidth,
                               report.videoReceivedDecodeMs)
            
            result = "\(result)\(s2)"
            
            
        }
        
        // Audio send stats.
        var audioSendFormat = "AS %@ | %@\n"
        
        var s3 =  NSString(format: audioSendFormat,report.audioSendBitrate, report.audioSendCodec)
        
        result = "\(result)\(s3)"
        
        // Audio receive stats.
        var audioReceiveFormat = "AR %@ | %@ | %@ms | (expandrate)%@"
        
        var s4 =  NSString(format: audioReceiveFormat ,report.audioReceivedBitrate, report.audioReceivedCodec, report.audioReceivedCurrentDelay,
                           report.audioReceivedExpandRate)
        
        result = "\(result)\(s4)"
        
        print ("*QBLogs: \(result)")
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
        
        viewDidLoad()
    }
    
    
    
    
    var currentSeconds = 60
    
    
    var timet = 0
    
    var left = false
    
    
    func addPoint(id:String)
    {
        var params = ["id":id]
        
        //print("params:  \(params)")
        
        var apiCall = "https://exchangeappreview.azurewebsites.net/Spotlight/point_plus_plus.php"
        
        Alamofire.request(.POST, apiCall).responseJSON {
            response in
            
            //self.alert.dismissWithClickedButtonIndex(0, animated: true)
            //var json  = response.result.value as? NSDictionary
            //let status =  json?.valueForKey("status") as! Int
            
        }
    }
    
    func updateOneSec()
    {
        if (!self.left)
        {
            timet += 1
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateOneSec", userInfo: nil, repeats: false)
        }
        
        if (self.timet == 60 && !self.left)
        {
            self.addPoint("\(self.userId)")
        }
    }
    
    func updateTimeByOne()
    {
        self.waitingTime.text = "\(self.currentSeconds) seconds"
        self.currentSeconds--
        
        if (continueState && currentSeconds<=0)
        {
            self.waitingTime.text = "No body available."
            //self.cancelButtonWaiting.setTitle("Retry", forState: .Normal)
            retryButtonWaiting.enabled = true
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
        
        alert = UIAlertView()
        alert.title = "Please wait"
        alert.message = "Connecting..."
        alert.show()
        
        query.predicate = NSPredicate(format: "person1=='\(uIDs[self.currentUserNumber].valueForKey("id") as! String)' OR person2=='\(uIDs[self.currentUserNumber].valueForKey("id") as! String)'")
        
        //print ("Predicate: \(query.predicate)")
        
        query.readWithCompletion({ (result, error) -> Void in
            
            self.alert.dismissWithClickedButtonIndex(0, animated: true)
            
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
        var type:String  = "text"
        
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client
        let itemTable = client.tableWithName("Request")
        
        
        alert = UIAlertView()
        alert.title = "Please wait"
        alert.message = "Connecting..."
        alert.show()
        
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
                self.alert.dismissWithClickedButtonIndex(0, animated: true)
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
                    //print ("This is free user. Creating Room with him/her")
                    self.createRoomWithUser((user[self.currentUserNumber].valueForKey("id") as! String))
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
    
    @IBAction func rejectFriendRequestButtonPressed(sender: UIButton) {
        
        
        QBChat.instance().rejectAddContactRequest(UInt(self.currentConnectedUser)!, completion: { (error: NSError?) -> Void in
            
            if (error == nil)
            {
                GTToast.create("Friend Request Rejected")
                self.friendRequestDialog.hidden = true
            }
            else{
                GTToast.create("Network error").show()
                self.friendRequestDialog.hidden = false
                //print ("ERROR WITH REQUEST: \(error?.localizedDescription)")
            }
            
        });
        
    }
    
    @IBAction func acceptFriendRequestButtonPressed(sender: UIButton) {
        
        
        self.addFriendAzure()
        QBChat.instance().confirmAddContactRequest(UInt(self.currentConnectedUser)!, completion: { (error: NSError?) -> Void in
            
            
            
            if (error == nil)
            {
                self.accpt = true
                GTToast.create("Friend Request Accepted")
                self.friendRequestDialog.hidden = true
            }
            else{
                GTToast.create("Network error").show()
                self.friendRequestDialog.hidden = false
                //print ("ERROR WITH REQUEST: \(error?.localizedDescription)")
            }
            
        })
        
    }
    
    
    
    func checkPendingRequestsForUserWithId(str:String)
    {
        
        if (str != "\(userId)")
        {
            
            let params = [  "UserId": str ,
                            "request_type":"text",
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
        
        if (pass == 0)
        {
            
            back = true
        }
    }
    
    
    var back = false
    
    
    
    //    func dismissUserinfo()
    //    {
    //        self.userInfoView.hidden = true
    //        self.proInfo.hidden = true
    //        //self.blurBG!.hidden = true
    //    }
    @IBOutlet weak var proInfo: UIView!
    @IBOutlet weak var proInfoImage: PASImageView!
    
    @IBOutlet weak var infoName: UILabel!
    
    func makeConnecttion()
    {
        //        alert = UIAlertView()
        //        alert.title = "Please wait"
        //        alert.message = "Connecting you to someone..."
        //        
        //        alert.show()
        
        let user = QBUUser()
        user.ID = self.userId
        user.password = self.userPassword
        
        if (!QBChat.instance().isConnected())
        {
            
            
            QBChat.instance().connectWithUser(user, completion: { (error) -> Void in
                
                if (error == nil){
                    
                    self.connectionTime.text = self.getCurrentTime()
                    
                    self.connectionStatus.text = "Connected"
                    
                    self.btnVideoBtn.enabled = true
                    
                    self.left = false
                    
                    self.updateOneSec()
                    
                    //                self.personName.text = "You are now connected with \(self.personNameString)"
                    
                    self.peopleDone += "\(user.ID)"
                    self.connectionTime.text = self.getCurrentTime()
                    
                    //print ("Connected!")
                    
                    self.printALL()
                    
                    self.deleteAllShit()
                    
                    // self.blurB!G.hidden = false
                    
                    //              self.alert.dismissWithClickedButtonIndex(0, animated: true)
                    
                    self.connectionStatus.text = "Connected"
                    self.btnVideoBtn.enabled = true
                    //self.alert.dismissWithClickedButtonIndex(0, animated: true)
                    
                    self.deleteRequestsFor()
                    //self.deleteChatRoomFor()
                    self.connected = true
                    
                    if (self.connectionFrom == "Video")
                    {
                        if (self.chatDialog.recipientID>Int(self.userId))
                        {
                            //print ("\(self.chatDialog.recipientID) Greater then \(self.userId)")
                            self.requestVideoButtonPressed(UIButton())
                        }
                        else{
                            //print ("\(self.chatDialog.recipientID) Smaller then \(self.userId)")
                        }
                    }
                    
                    //self.getConnectedUserDetails("\(user.ID)")
                    
                    self.getFriendRequest()
                }
                else
                {
                    
                    //print ("*Error: \(error)")
                    //                self.personName.text = "Mayday situation. Retreat ASAP. Over."
                    //                self.connectionTime.text = ""
                    //                //print ("NOT Connected!")
                    //self.connectionStatus.text = "NOT Connected"
                }
                
            })
        }
        else
        {
            //print ("Already Connected")
            self.connectionStatus.text = "Connected"
            
            self.btnVideoBtn.enabled = true
        }
        
    }
    
    
    func deleteAllShit()
    {
        if (userId != nil)
        {
            var params = [ "user_id": userId ]
            Alamofire.request(.POST, "https://exchangeappreview.azurewebsites.net/Spotlight/delete_request.php", parameters: params)
        }
    }
    
    @IBAction func sendM(sender: UIButton) {
        
        if (messageTextField.text != nil && messageTextField.text != "")
        {
            self.sendMessage(sender)
        }
        messageTextField.endEditing(true)
        
    }
    
    
    func scrollToTop()
    {
        
        var bottomOffset = CGPointMake(0, 0);
        
        self.chatScrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    @IBOutlet weak var userLeftImage: UIImageView!
    
    @IBOutlet weak var nextBtn2: UIButton!
    @IBOutlet weak var nextBtn1: UIButton!
    @IBOutlet weak var addFriend2: UIButton!
    @IBOutlet weak var addFriend1: UIButton!
    
    func interstitialWillDismissScreen(ad: GADInterstitial!) {
        
        print ("About to  Fuckup")
        self.backButtonPressed(UIButton())
    }
    
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        
        print ("Done -_-")
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.addShadow(self.friendRequestDialog)
        self.addShadow(self.callReceivedDialog)
        self.addShadow(self.reportView)
        
        self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-2891096036722966/7303340733")
        
        self.interstitial.delegate = self
        
        let request = GADRequest()
        
        interstitial.loadRequest(request)
        
        imagePicker.delegate = self
        
        userLeftImage.layer.cornerRadius = 15.0
        
        
        QBRTCConfig.setStatsReportTimeInterval(1.0)
        
        if (connectionFrom == "Messages")
        {
            self.topSpaceScroller.constant = 10
            self.makeDashInvisible()
            showConnectedUserDetails(false)
            
            
            self.chatScrollView.contentSize = CGSizeMake(self.dummy.frame.width, self.dummy.frame.height-100)
        }
        
        
        if (connectionFrom == "Text")
        {
            showConnectedUserDetails(true)
            self.topSpaceScroller.constant = 80
            self.makeDashVisible()
            
            
            self.chatScrollView.contentSize = CGSizeMake(self.chatScrollView.frame.width, self.chatScrollView.frame.height)
            
        }
        
        if (connectionFrom == "Video")
        {
            showConnectedUserDetails(true)
            self.topSpaceScroller.constant = 80
            
            
            self.chatScrollView.contentSize = CGSizeMake(self.chatScrollView.frame.width, self.chatScrollView.frame.height)
            
            self.videoView.hidden = false
            
            self.makeDashVisible()
            
        }
        
        
        
        self.messageTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        getUserDetails()
        
        self.recipientID = Int(json.valueForKey("id") as! String)
        self.createDialogForUserAuto(UInt(recipientID))
        
        //makeRequest()
        
        
        //getAllOnlineUsers()
        
        
        if let user: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("profile_pic") {
            
            self.myImage = user as! String
            ////print ("***\(userPassword)")
            
        }
        
        var total = 0
        
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("totalCalls") {
            total = (username as! Int) + 1
        }
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(total, forKey: "totalCalls")
        userDefaults.synchronize()
        
        
    }
    
    @IBOutlet weak var dummy: UIView!
    
    func makeRequest()
    {
        var params = ["UserId": "\(userId)", "request_type": "text"]
        
        Alamofire.request(.POST, "\(url)makeRequest.php", parameters: params)
        
        getAllOnlineUsers()
    }
    
    func startMakingConnection()
    {
        
        QBRTCSoundRouter.instance().initialize()
        
        QBRTCSoundRouter.instance().currentSoundRoute = QBRTCSoundRoute.Speaker
        //QBRTCSoundRouter.instance().setCurrentSoundRoute(QBRTCSoundRoute.Speaker)
        
        QBRTCClient.initializeRTC()
        
        QBRTCClient.instance().addDelegate(self)
        
        
        
        
        self.capture = QBRTCVideoCapture()
        
        getUserDetails()
        
        ////print (chatDialog.name)
        ////print (self.title)
        self.title = chatDialog.name
        self.personNameString = chatDialog.name!
        //self.personName.text = self.personNameString
        //        self.personName.text = "Connecting to \(self.personNameString)"
        
        let occup = self.chatDialog.occupantIDs
        
        for x in occup!{
            members.text! += "\(x), "
        }
        
        if (chatDialog.isJoined())
        {
            connectionStatus.text = "Connected"
        }else
        {
            connectionStatus.text = "Connecting"
        }
        
        QBChat.instance().addDelegate(self)
        
        
        makeConnecttion()
        
        getNumberOfMessages()
        
    }
    
    @IBAction func connectToDialog(sender: UIButton) {
        
        
        
        if (sender.titleLabel?.text == "Connect To Dialog")
        {
            let user = QBUUser()
            user.ID = self.userId
            user.password = self.userPassword
            
            QBChat.instance().connectWithUser(user, completion: { (error) -> Void in
                
                if (error == nil){
                    
                    //                    self.personName.text = "You are now connected with \(self.personNameString)"
                    self.connectionTime.text = self.getCurrentTime()
                    
                    //print ("Connected!")
                    
                    self.printALL()
                    
                    self.deleteAllShit()
                    
                    self.connectionStatus.text = "Connected"
                    
                    self.btnVideoBtn.enabled = true
                    
                    if (self.connectionFrom == "Video")
                    {
                        if (self.chatDialog.recipientID>Int(self.userId))
                        {
                            //print ("\(self.chatDialog.recipientID) Greater then \(self.userId)")
                            self.requestVideoButtonPressed(UIButton())
                        }
                        else{
                            //print ("\(self.chatDialog.recipientID) Smaller then \(self.userId)")
                        }
                    }
                    
                    self.alert.dismissWithClickedButtonIndex(0, animated: true)
                }
                else
                {
                    //print ("Error: \(error)")
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
    
    @IBOutlet weak var imageViewZoom: UIImageView!
    @IBOutlet weak var imageZoom: UIView!
    @IBOutlet weak var frontView: UIView!
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
        
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            
            self.bottomConstraint.constant = keyboardFrame.size.height + 5
            self.frontView.layoutIfNeeded()
            
            }, completion: { (finished: Bool) -> Void in
                
                self.scrollToBottom()
        })
        
        
        
        //        UIView.animateWithDuration(1, animations: { () -> Void in
        //            self.bottomConstraint.constant = keyboardFrame.size.height + 5
        //            self.scrollToBottom()
        //            }, completion: { (v) -> Void in
        //                
        //                self.scrollToBottom()
        //                
        //                
        //        })
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
            
            //self.alert.dismissWithClickedButtonIndex(0, animated: true)
            
            self.startMakingConnection()
            
            
        }) { (responce : QBResponse!) -> Void in
            //print("***Error: \(responce)")
            
        }
        
    }
    
    
    @IBAction func addFriend(sender: UIBarButtonItem) {
        
        
        if (self.thisUserName.contains("Anonymous"))
        {
            GTToast.create("You need to update your information first").show()
        }
        else if (self.currentConnectedUserName.contains("Anonymous"))
        {
            GTToast.create("You cannot add a Anonymous user").show()
        }
        else
        {
            
            
            QBChat.instance().addUserToContactListRequest(UInt(self.currentConnectedUser)!, completion: {(error: NSError?) -> Void in
                
                
                if (error != nil)
                {
                    GTToast.create("Error sending request.").show()
                    //print ("Error with request: \(error?.localizedDescription)")
                }
                else
                {
                    GTToast.create("Friend Request Sent.").show()
                }
            })
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
