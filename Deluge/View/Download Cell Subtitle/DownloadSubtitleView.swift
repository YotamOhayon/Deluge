//
//  DownloadSubtitleView.swift
//  Deluge
//
//  Created by Yotam Ohayon on 15/05/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import Delugion

@IBDesignable
class DownloadSubtitleView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var totalDownloadedLabel: UILabel!
    @IBOutlet weak var downloadSpeedLabel: UILabel!
    
    @IBInspectable var eta: String? {
        get { return self.etaLabel.text }
        set { self.etaLabel.text = newValue }
    }
    
    @IBInspectable var totalDownloaded: String? {
        get { return self.totalDownloadedLabel.text }
        set { self.totalDownloadedLabel.text = newValue }
    }
    
    @IBInspectable var downloadSpeed: String? {
        get { return self.downloadSpeedLabel.text }
        set { self.downloadSpeedLabel.text = newValue }
    }
    
    var torrent: TorrentProtocol? {
        didSet {
            
            guard let torrent = self.torrent else {
                self.eta = nil
                self.totalDownloaded = nil
                self.downloadSpeed = nil
                return
            }
            
            self.eta = (torrent.eta > 0) ? torrent.eta.asHMS : nil
            
            let (download, downloadUnit) = torrent.totalDone.inUnits(withPrecision: 1)
            let (total, totalUnit) = torrent.totalSize.inUnits(withPrecision: 1)
            self.totalDownloaded = "\(download) \(downloadUnit.stringified) / \(total) \(totalUnit.stringified)"
            
            let (speed, unit) = torrent.downloadPayloadrate.inUnits(withPrecision: 1)
            self.downloadSpeed = "\(speed) \(unit.stringifiedAsSpeed)"
            
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
        
        let nib = UINib(nibName: "DownloadSubtitleView",
                        bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
    }

}
