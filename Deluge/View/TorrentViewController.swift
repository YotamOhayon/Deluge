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
    
    var viewModel: TorrentModeling!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.progress.drive(onNext: { [unowned self] in
            self.addProgressView($0)
        }).disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

}

fileprivate extension TorrentViewController {
    
    func addProgressView(_ progress: ProgressType) {
        
        let addConstraints: (UIView) -> Swift.Void = { [unowned self] progressView in
            progressView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(progressView)
            progressView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            progressView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            progressView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            progressView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        }
        
        switch progress {
        case .numeric(let view):
            addConstraints(view)
        case .other(let image):
            let imageView = UIImageView(image: image)
            addConstraints(imageView)
        }
    
    }
    
}
