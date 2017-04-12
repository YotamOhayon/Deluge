//
//  TorrentViewController.swift
//  Deluge
//
//  Created by Yotam Ohayon on 09/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import KDCircularProgress
import RxCocoa
import RxSwift

class TorrentViewController: UIViewController {
    
    var progressView: UIView?
    var progressLabel: UILabel?
    var viewModel: TorrentModeling!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.progress.drive(onNext: { [unowned self] in
            if let progressView = self.progressView {
                progressView.removeFromSuperview()
            }
            self.addProgressView($0)
        }).disposed(by: disposeBag)
        
        viewModel.progressLabel.drive(onNext: { [unowned self] in
            if let progressLabel = self.progressLabel {
                progressLabel.removeFromSuperview()
            }
            self.addProgressLabel($0)
        }).disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
}

fileprivate extension TorrentViewController {
    
    func addProgressView(_ progressView: UIView) {
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(progressView)
        progressView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        progressView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        progressView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.progressView = progressView
        
    }
    
    func addProgressLabel(_ label: UILabel) {
        
        guard let progressView = self.progressView else {
            return
        }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: progressView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: progressView.centerYAnchor).isActive = true
        self.progressLabel = label
        
    }
    
}
