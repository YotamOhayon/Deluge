//
//  PausedTableViewCell.swift
//  Deluge
//
//  Created by Yotam Ohayon on 08/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import KDCircularProgress

class PausedTableViewCell: UITableViewCell {

    
    @IBOutlet weak var progressView: KDCircularProgress!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var size: UILabel!
    
    var viewModel: PausedCellViewModeling! {
        didSet {
            self.title.text = viewModel.title
            let progress = viewModel.progress ?? 0
            self.progressView.angle = Double(360 * (progress / 100))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
