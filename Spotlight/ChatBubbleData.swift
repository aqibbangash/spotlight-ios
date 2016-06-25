//
//  ChatBubbleData.swift
//  Spark
//
//  Created by Aqib on 05/02/2016.
//  Copyright © 2016 Root-Dev. All rights reserved.
//

import Foundation

enum BubbleDataType: Int{
    case Mine = 0
    case Opponent
}

/// DataModel for maintaining the message data for a single chat bubble
class ChatBubbleData {
    
    // 2.Properties
    var text: String?
    var image: UIImage?
    var date: NSDate?
    var type: BubbleDataType
    var link:String?
    
    // 3. Initialization
    init(text: String?,image: UIImage?,date: NSDate? , type:BubbleDataType = .Mine) {
        // Default type is Mine
        self.text = text
        self.image = image
        self.date = date
        self.type = type
    }
    
    init(text: String?,link: String?,date: NSDate? , type:BubbleDataType = .Mine) {
        // Default type is Mine
        self.text = text
        self.link = link
        self.date = date
        self.type = type
    }
}