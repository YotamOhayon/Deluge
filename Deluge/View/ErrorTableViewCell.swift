//
//  ErrorTableViewCell.swift
//  Deluge
//
//  Created by Yotam Ohayon on 08/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit

class ErrorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    var viewModel: ErrorCellViewModeling! {
        didSet {
            self.title.text = viewModel.title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
