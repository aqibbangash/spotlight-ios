//
//  friendCell.swift
//  Spotlight
//
//  Created by Aqib on 09/03/2016.
//  Copyright © 2016 Sofit. All rights reserved.
//

import UIKit

class friendCell: UITableViewCell {

    @IBOutlet weak var imageUser: PASImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var statusColor: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
