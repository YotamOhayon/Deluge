//
//  FileNameTableViewCell.swift
//  Deluge
//
//  Created by Yotam Ohayon on 19/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit

class FileNameTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
