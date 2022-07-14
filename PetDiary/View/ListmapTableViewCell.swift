//
//  ListmapTableViewCell.swift
//  PetDiary
//
//  Created by jeanwei on 2022/6/4.
//

import UIKit

class ListmapTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCell(item: itemResults?) {
        
        if let item = item {
          nameLabel.text = item.name
            addressLabel.text = item.vicinity
        }else{
            nameLabel.text = ""
            addressLabel.text = ""
        }
        
    }
}
