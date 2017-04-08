//
//  PausedTableViewCell.swift
//  Deluge
//
//  Created by Yotam Ohayon on 08/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit

class PausedTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    var viewModel: PausedCellViewModeling! {
        didSet {
            self.label.text = viewModel.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
