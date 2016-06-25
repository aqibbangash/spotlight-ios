//
//  CellController.swift
//  Spotlight
//
//  Created by Aqib on 25/02/2016.
//  Copyright © 2016 Sofit. All rights reserved.
//

import UIKit

class CellController: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
