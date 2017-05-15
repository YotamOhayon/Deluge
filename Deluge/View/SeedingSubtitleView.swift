//
//  SeedingSubtitleView.swift
//  Deluge
//
//  Created by Yotam Ohayon on 15/05/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import Delugion

@IBDesignable
class SeedingSubtitleView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var totalDownloadedLabel: UILabel!
    
    @IBInspectable var totalDownloaded: String? {
        get { return self.totalDownloadedLabel.text }
        set { self.totalDownloadedLabel.text = newValue }
    }
    
    var torrent: TorrentProtocol? {
        didSet {
            
            guard let torrent = self.torrent else {
                self.totalDownloaded = nil
                return
            }
            
            let (download, downloadUnit) = torrent.totalDone.inUnits(withPrecision: 1)
            let (total, totalUnit) = torrent.totalSize.inUnits(withPrecision: 1)
            self.totalDownloaded = "\(download) \(downloadUnit.stringified) / \(total) \(totalUnit.stringified)"
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        
        let nib = UINib(nibName: "SeedingSubtitleView",
                        bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
    }

}
