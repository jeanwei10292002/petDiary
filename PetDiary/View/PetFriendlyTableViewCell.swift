//
//  PetFriendlyTableViewCell.swift
//  PetDiary
//
//  Created by jeanwei on 2022/6/7.
//

import UIKit

class PetFriendlyTableViewCell: UITableViewCell {

    @IBOutlet weak var friAddressLabel: UILabel!
    @IBOutlet weak var friNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
