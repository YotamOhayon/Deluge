//
//  TorrentTableViewCell.swift
//  Deluge
//
//  Created by Yotam Ohayon on 08/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import Delugion
import SwipeCellKit

class TorrentTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var progressView: CircularProgressBar!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    var textManager: TextManaging!
    
    var viewModel: TorrentCellViewModeling! {
        didSet {
            self.title.text = viewModel.title
            self.progressView.setTorrent(viewModel.torrent)
            self.subtitle.text = viewModel.subtitle
            self.subtitle.textColor = viewModel.subtitleColor
        }
    }

}
