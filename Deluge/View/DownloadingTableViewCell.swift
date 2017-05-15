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
    
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var downloadSpeedLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    
    var viewModel: DownloadingCellViewModeling! {
        didSet {
            self.title.text = viewModel.title
            self.progressView.angle = viewModel.progress
            self.progressView.progress = viewModel.progressNumeric
            self.downloadSpeedLabel.text = viewModel.downloadSpeed
            self.etaLabel.text = viewModel.eta
        }
    }

}
