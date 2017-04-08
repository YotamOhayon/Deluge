//
//  DownloadingTableViewCell.swift
//  Deluge
//
//  Created by Yotam Ohayon on 08/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit

class DownloadingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    var viewModel: DownloadingCellViewModeling! {
        didSet {
            self.title.text = viewModel.text
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
