//
//  DownloadingTableViewCell.swift
//  Deluge
//
//  Created by Yotam Ohayon on 08/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import KDCircularProgress

class DownloadingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var progressView: KDCircularProgress!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var downloadSpeedLabel: UILabel!
    
    var viewModel: DownloadingCellViewModeling! {
        didSet {
            self.title.text = viewModel.title
            self.progressView.angle = viewModel.progress
            self.downloadSpeedLabel.text = viewModel.downloadSpeed
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
