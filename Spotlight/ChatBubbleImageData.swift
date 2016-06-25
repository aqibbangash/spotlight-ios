//
//  ChatBubbleData.swift
//  Spark
//
//  Created by Aqib on 05/02/2016.
//  Copyright © 2016 Root-Dev. All rights reserved.
//

import Foundation

enum BubbleDataImageType: Int{
    case Mine = 0
    case Opponent
}

/// DataModel for maintaining the message data for a single chat bubble
class ChatBubbleImageData {
    
    // 2.Properties
    var text: String?
    var img:UIImage?
    var image: UIImage?
    var date: NSDate?
    var type: BubbleDataImageType
    
    // 3. Initialization
    init(img: UIImage?,image: UIImage?,date: NSDate? , type:BubbleDataImageType = .Mine) {
        // Default type is Mine
        self.img = img
        self.image = image
        self.date = date
        self.type = type
    }
}