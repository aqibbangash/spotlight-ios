//
//  ChatBubble.swift
//  ChatBubbleScratch
//
//  Created by Sauvik Dolui on 02/09/15.
//  Copyright (c) 2015 Innofied Solution Pvt. Ltd. All rights reserved.
//

import UIKit

class ChatBubbleImage: UIView {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    // Properties
    var imageViewChat: UIImageView?
    var imageViewBG: UIImageView?
    var text: String?
    var labelChatText: UILabel?
    var imageUI:UIImageView?
    var ScreenSize: CGRect!
    
    /**
     Initializes a chat bubble view
     
     :param: data   ChatBubble Data
     :param: startY origin.y of the chat bubble frame in parent view
     
     :returns: Chat Bubble
     */
    init(data: ChatBubbleImageData, startX:CGFloat , startY: CGFloat){
        
         ScreenSize = UIScreen.mainScreen().bounds
        

        
        // 1. Initializing parent view with calculated frame
        super.init(frame: ChatBubbleImage.framePrimary(data.type, startY:startY, screenSize: ScreenSize))
        
        // Making Background transparent
        self.backgroundColor = UIColor.clearColor()
        
        let padding: CGFloat = 10.0
        
        // 2. Drawing image if any
        if let chatImage = data.image {
            
            let width: CGFloat = min(chatImage.size.width, CGRectGetWidth(self.frame) - 2 * padding)
            let height: CGFloat = chatImage.size.height * (width / chatImage.size.width)
            imageViewChat = UIImageView(frame: CGRectMake(padding, padding, width, height))
            imageViewChat?.image = chatImage
            imageViewChat?.layer.cornerRadius = 5.0
            imageViewChat?.layer.masksToBounds = true
            self.addSubview(imageViewChat!)
        }
        
        // 3. Going to add Text if any
        if let chatText = data.text {
            // frame calculation
            var startX = padding
            var startY:CGFloat = 5.0
            if let imageView = imageViewChat {
                startY += CGRectGetMaxY(imageViewChat!.frame)
            }
//            labelChatText = UILabel(frame: CGRectMake(startX, startY, CGRectGetWidth(self.frame) - 2 * startX , 5))
//            labelChatText?.textAlignment = data.type == .Mine ? .Right : .Left
//            labelChatText?.font = UIFont.systemFontOfSize(14)
//            labelChatText?.numberOfLines = 0 // Making it multiline
//            labelChatText?.text = data.text
//            labelChatText?.sizeToFit() // Getting fullsize of it
            
            imageUI?.image = data.img
            
            imageUI = UIImageView(frame: CGRectMake(startX, startY, 300, 300))
            
            self.addSubview(imageUI!)
            
           // self.addSubview(labelChatText!)
        }
        // 4. Calculation of new width and height of the chat bubble view
        var viewHeight: CGFloat = 0.0
        var viewWidth: CGFloat = 0.0
        if let imageView = imageViewChat {
            // Height calculation of the parent view depending upon the image view and text label
            viewWidth = max(CGRectGetMaxX(imageViewChat!.frame), CGRectGetMaxX(imageUI!.frame)) + padding
            viewHeight = max(CGRectGetMaxY(imageViewChat!.frame), CGRectGetMaxY(imageUI!.frame)) + padding
            
        } else {
            viewHeight = CGRectGetMaxY(imageUI!.frame) + padding/2
            viewWidth = CGRectGetWidth(imageUI!.frame) + CGRectGetMinX(imageUI!.frame) + padding
        }
        
        // 5. Adding new width and height of the chat bubble frame
        self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), viewWidth, viewHeight)
        
        // 6. Adding the resizable image view to give it bubble like shape
        let bubbleImageFileName = data.type == .Mine ? "bubbleMine" : "bubbleSomeone"
        imageViewBG = UIImageView(frame: CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)))
        if data.type == .Mine {
           // labelChatText?.textColor = UIColor.whiteColor()
            imageViewBG?.image = UIImage(named: bubbleImageFileName)?.resizableImageWithCapInsets(UIEdgeInsetsMake(14, 22, 17, 20))
        } else {
            //labelChatText?.textColor = UIColor.blackColor()
            imageViewBG?.image = UIImage(named: bubbleImageFileName)?.resizableImageWithCapInsets(UIEdgeInsetsMake(14, 22, 17, 20))
        }
        
        
        self.addSubview(imageViewBG!)
        self.sendSubviewToBack(imageViewBG!)
        
        // Frame recalculation for filling up the bubble with background bubble image
        var repsotionXFactor:CGFloat = data.type == .Mine ? 0.0 : -8.0
        var bgImageNewX = CGRectGetMinX(imageViewBG!.frame) + repsotionXFactor
        var bgImageNewWidth =  CGRectGetWidth(imageViewBG!.frame) + CGFloat(12.0)
        var bgImageNewHeight =  CGRectGetHeight(imageViewBG!.frame) + CGFloat(6.0)
        imageViewBG?.frame = CGRectMake(bgImageNewX, 0.0, bgImageNewWidth, bgImageNewHeight)
        
        
        // Keepping a minimum distance from the edge of the screen
        var newStartX:CGFloat = 0.0
        if data.type == .Mine {
            // Need to maintain the minimum right side padding from the right edge of the screen
            var extraWidthToConsider = CGRectGetWidth(imageViewBG!.frame)
            newStartX = ScreenSize.width - extraWidthToConsider - 50
        } else {
            // Need to maintain the minimum left side padding from the left edge of the screen
            newStartX = -CGRectGetMinX(imageViewBG!.frame) + 3.0 + 50
        }
        
        self.frame = CGRectMake(newStartX, CGRectGetMinY(self.frame), CGRectGetWidth(frame), CGRectGetHeight(frame))
        
    }
    
    // 6. View persistance support
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FRAME CALCULATION
    class func framePrimary(type:BubbleDataImageType, startY: CGFloat, screenSize: CGRect) -> CGRect{
        let paddingFactor: CGFloat = 0.02
        let sidePadding = screenSize.width * paddingFactor
        let maxWidth = screenSize.width * 0.65 // We are cosidering 65% of the screen width as the Maximum with of a single bubble
        let startX: CGFloat = type == .Mine ? screenSize.width * (CGFloat(1.0) - paddingFactor) - maxWidth : (sidePadding)
        
        return CGRectMake(startX, startY, maxWidth, 5) // 5 is the primary height before drawing starts
    }
    
}
