//
//  ContactTableViewCell.swift
//  myContacts
//
//  Created by paciffic on 2015. 7. 1..
//  Copyright (c) 2015년 paciffic. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imvContact: UIImageView!
    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var swtAdd: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
