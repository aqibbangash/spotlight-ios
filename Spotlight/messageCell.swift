//
//  messageCell.swift
//  Spotlight
//
//  Created by Aqib on 11/03/2016.
//  Copyright © 2016 Sofit. All rights reserved.
//

import UIKit

class messageCell: UITableViewCell {

    @IBOutlet weak var imageUser: PASImageView!
    @IBOutlet weak var lastMessageTime: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
