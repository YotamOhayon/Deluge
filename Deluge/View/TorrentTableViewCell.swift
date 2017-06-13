//
//  TorrentTableViewCell.swift
//  Deluge
//
//  Created by Yotam Ohayon on 08/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import Delugion

class TorrentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var title: UILabel!
    var subtitle: UIView?
    var textManager: TextManaging!
    
    var viewModel: TorrentCellViewModeling! {
        didSet {
            self.title.text = viewModel.title
            self.progressView.angle = viewModel.progress
            self.progressView.trackColor = viewModel.trackColor
            self.progressView.progressColor = viewModel.progressColor
            self.progressView.progressNumeric = viewModel.progressNumeric
            self.progressView.insideColor = viewModel.progressBackgroundColor
            self.addSubtitle(fromTorrent: viewModel.torrent)
        }
    }
    
    func addSubtitle(fromTorrent torrent: TorrentProtocol) {
        
        let addConstraints: (UIView) -> Void = { [unowned self] view in
            self.subtitle?.removeFromSuperview()
            self.addSubview(view)
            self.subtitle = view
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leadingAnchor
                .constraint(equalTo: self.title.leadingAnchor)
                .isActive = true
            view.bottomAnchor
                .constraint(equalTo: self.progressView.bottomAnchor)
                .isActive = true
        }
        
        switch torrent.state {
        case .downloading:
            let subtitle = DownloadSubtitleView()
            subtitle.torrent = torrent
            addConstraints(subtitle)
        case .paused:
            let subtitle = PausedSubtitleView()
            subtitle.torrent = torrent
            addConstraints(subtitle)
        case .error:
            let subtitle = UILabel()
            subtitle.text = textManager.error
            subtitle.font = UIFont(name: "Helvetica Neue", size: 12)
            subtitle.textColor = .lightGray
            addConstraints(subtitle)
        case .seeding:
            let subtitle = SeedingSubtitleView()
            subtitle.torrent = torrent
            addConstraints(subtitle)
        default:
            return
        }
        
    }
    
}
