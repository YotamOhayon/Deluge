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
    
    @IBOutlet weak var progressView: KDCircularProgress!
    var progressSubview: UIView?
    var viewModel: TorrentModeling!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.progress.drive(onNext: { [unowned self] in
            
            guard let progressInfo = $0 else {
                return
            }
            self.progressView.angle = progressInfo.angle
            self.progressView.progressColors = [progressInfo.progressColor]
            
            if let progressSubview = self.progressSubview {
                progressSubview.removeFromSuperview()
            }
            
            let view = progressInfo.view
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            self.progressSubview = view
            view.centerXAnchor.constraint(equalTo: self.progressView.centerXAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: self.progressView.centerYAnchor).isActive = true
            
        }).disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
}
