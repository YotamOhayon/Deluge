//
//  CompletedTableViewCell.swift
//  Deluge
//
//  Created by Yotam Ohayon on 08/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit

class CompletedTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var size: UILabel!
    
    var viewModel: CompletedCellViewModeling! {
        didSet {
            self.title.text = viewModel.title
            self.size.text = viewModel.size
        }
    }

}
