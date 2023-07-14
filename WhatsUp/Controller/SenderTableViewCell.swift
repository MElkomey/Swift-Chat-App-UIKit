//
//  SenderTableViewCell.swift
//  WhatsUp
//
//  Created by Mohamed Elkomey on 10/07/2023.
//

import UIKit

class SenderTableViewCell: UITableViewCell {

    @IBOutlet weak var senderMessgaeLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
