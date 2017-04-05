//
//  AddTorrentViewController.swift
//  Deluge
//
//  Created by Yotam Ohayon on 14/05/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AddTorrentViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var torrentNameLabel: UILabel!
    
    var viewModel: AddTorrentViewModeling!
    private let disposeBag = DisposeBag()
    
    private lazy var spinnerView: UIActivityIndicatorView = { [unowned self] in
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        spinner.activityIndicatorViewStyle = .gray
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel
            .title
            .drive(self.torrentNameLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel
            .spinnerActivity
            .drive(self.spinnerView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        self.addButton
            .rx
            .tap
            .bind(to: viewModel.addTapped)
            .disposed(by: self.disposeBag)
        
        cancelButton
            .rx
            .tap
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        
        viewModel.torrentAdded.drive(onNext: { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
        
        viewModel.failedAddingTorrent.drive(onNext: { [unowned self] in
            print("FAILED!!!")
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
        
    }

}
