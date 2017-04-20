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
    
    @IBOutlet weak var pausePlayButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filesContainerView: UIView!
    @IBOutlet weak var detailsContainerView: UIView!
    @IBOutlet weak var progressView: KDCircularProgress!
    
    var progressSubview: UIView?
    var viewModel: TorrentModeling!
    var progressDisposable: Disposable!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.titleLabel.text = viewModel.title
        
        viewModel.shouldHidePlayPauseButton.drive(onNext: { [weak self] in
            self?.pausePlayButton.isEnabled = $0
        }).disposed(by: disposeBag)
        
        viewModel.didRemoveTorrent.subscribe(onNext: { [weak self] in
            if $0 {
                _ = self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        self.progressDisposable = viewModel.progress.drive(onNext: { [unowned self] in
            
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
            
        })
        self.progressDisposable.disposed(by: disposeBag)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.progressDisposable.dispose()
    }
    
    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.filesContainerView.alpha = 1
            self.detailsContainerView.alpha = 0
        default:
            self.filesContainerView.alpha = 0
            self.detailsContainerView.alpha = 1
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TorrentFilesSegue" {
            let vc = segue.destination as! TorrentFilesTableViewController
            vc.viewModel = viewModel.torrentFilesViewModel
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.deleteButtonTapped(withData: false)
    }
    
    
}
