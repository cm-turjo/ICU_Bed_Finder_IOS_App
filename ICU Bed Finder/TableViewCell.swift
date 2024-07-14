//
//  TableViewCell.swift
//  ICU Bed Finder
//
//  Created by Abdulla Rahman on 26/11/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    

    @IBOutlet weak var district: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var AvailableBeds: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
