//
//  TorrentViewController.swift
//  Deluge
//
//  Created by Yotam Ohayon on 09/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TorrentViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var progressView: CircularProgressBar!
    
    private var topButton: UIButton!
    private let bag = DisposeBag()
    
    var viewModel: TorrentViewModeling!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = viewModel.title
        
        viewModel
            .torrent
            .drive(self.progressView.rx.torrent)
            .disposed(by: self.bag)
        
         viewModel
            .subtitle
            .drive(self.subtitleLabel.rx.text)
            .disposed(by: bag)
        
        viewModel
            .subtitleColor
            .drive(self.subtitleLabel.rx.color)
            .disposed(by: bag)
        
        viewModel
            .topButton
            .drive(onNext: { [weak self] button in
                guard let strongSelf = self else { return }
                strongSelf.topButton?.removeFromSuperview()
                strongSelf.view.addSubview(button)
                NSLayoutConstraint.activate([
                    button.topAnchor.constraint(equalTo: strongSelf.subtitleLabel.bottomAnchor, constant: 32),
                    button.leadingAnchor.constraint(equalTo: strongSelf.view.leadingAnchor),
                    button.trailingAnchor.constraint(equalTo: strongSelf.view.trailingAnchor),
                    button.heightAnchor.constraint(equalToConstant: 44)
                    ])
            })
            .disposed(by: bag)
        
        viewModel
            .removeTorrentButton
            .filterNil()
            .withLatestFrom(viewModel.topButton) { ($0, $1) }
            .drive(onNext: { [weak self] delButton, topButton in
                guard let strongSelf = self else { return }
                strongSelf.view.addSubview(delButton)
                NSLayoutConstraint.activate([
                    delButton.topAnchor.constraint(equalTo: topButton.bottomAnchor, constant: 28),
                    delButton.leadingAnchor.constraint(equalTo: strongSelf.view.leadingAnchor),
                    delButton.trailingAnchor.constraint(equalTo: strongSelf.view.trailingAnchor),
                    delButton.heightAnchor.constraint(equalToConstant: 44)
                    ])
            })
            .disposed(by: bag)
        
        viewModel
            .didRemoveTorrent
            .drive(onNext: { [weak self] in
                if $0 {
                    _ = self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: bag)

        
    }
    
}

//class TorrentViewController: UIViewController {
//    
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var filesContainerView: UIView!
//    @IBOutlet weak var detailsContainerView: UIView!
//    @IBOutlet weak var progressView: CircularProgressBar!
//    
//    var subtitle: UIView?
//    var progressSubview: UIView?
//    var viewModel: TorrentViewModeling!
//    let disposeBag = DisposeBag()
//    
//    var resumeButton: UIBarButtonItem!
//    var pauseButton: UIBarButtonItem!
//    var deleteButton: UIBarButtonItem!
//    
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        
//        self.titleLabel.text = viewModel.title
//        
//        viewModel.subtitle.drive(onNext: { [unowned self] container in
//            if let subtitle = self.subtitle {
//                subtitle.removeFromSuperview()
//            }
//            self.view.addSubview(container)
//            self.subtitle = container
//            container.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor).isActive = true
//            container.bottomAnchor.constraint(equalTo: self.progressView.bottomAnchor).isActive = true
//            container.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor).isActive = true
//        }).disposed(by: self.disposeBag)
//        
//        viewModel
//            .progressColor
//            .drive(self.progressView.rx.color)
//            .disposed(by: self.disposeBag)
//        
//        viewModel
//            .progress
//            .drive(self.progressView.rx.progress)
//            .disposed(by: self.disposeBag)
//        
//        self.deleteButton = {
//            let trash = UIBarButtonItem(barButtonSystemItem: .trash,
//                                        target: nil,
//                                        action: nil)
//            trash.rx
//                .tap
//                .bind(to: self.viewModel.removeTorrentTapped)
//                .disposed(by: self.disposeBag)
//            return trash
//        }()
//        
//        self.resumeButton = {
//            let resume = UIBarButtonItem(barButtonSystemItem: .play,
//                                         target: nil,
//                                         action: nil)
//            resume.rx
//                .tap
//                .bind(to: self.viewModel.didResumeTorrentTapped)
//                .disposed(by: self.disposeBag)
//            return resume
//        }()
//        
//        self.pauseButton = {
//            let pause = UIBarButtonItem(barButtonSystemItem: .pause,
//                                        target: nil,
//                                        action: nil)
//            pause.rx
//                .tap
//                .bind(to: self.viewModel.didPauseTorrentTapped)
//                .disposed(by: self.disposeBag)
//            return pause
//        }()
//        
//        viewModel.didRemoveTorrent
//            .drive(onNext: { [weak self] in
//                if $0 {
//                    _ = self?.navigationController?.popViewController(animated: true)
//                }
//            }).disposed(by: disposeBag)
//        
//        viewModel.barButtonItems
//            .drive(onNext: { [unowned self] item in
//                switch item {
//                case UIBarButtonSystemItem.play:
//                    self.navigationItem.setRightBarButtonItems([self.deleteButton, self.resumeButton], animated: true)
//                case UIBarButtonSystemItem.pause:
//                    self.navigationItem.setRightBarButtonItems([self.deleteButton, self.pauseButton], animated: true)
//                default:
//                    self.navigationItem.setRightBarButtonItems([self.deleteButton], animated: true)
//                }
//            })
//            .disposed(by: disposeBag)
//        
//        viewModel.showDeleteConfirmation.subscribe(onNext:
//            { [unowned self] message, withData, withoutData, no in
//                
//                let alert = UIAlertController(title: nil,
//                                              message: message,
//                                              preferredStyle: .actionSheet)
//                
//                let withData = UIAlertAction(title: withData, style: .default) { _ in
//                    self.viewModel.removeTorrent.onNext(true)
//                }
//                
//                let withoutData = UIAlertAction(title: withoutData, style: .default) { _ in
//                    self.viewModel.removeTorrent.onNext(false)
//                }
//                
//                let no = UIAlertAction(title: no, style: .cancel, handler: nil)
//                
//                alert.addAction(withData)
//                alert.addAction(withoutData)
//                alert.addAction(no)
//                self.present(alert, animated: true, completion: nil)
//        }).disposed(by: disposeBag)
//        
//    }
//
//    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
//        
//        switch sender.selectedSegmentIndex {
//        case 0:
//            self.filesContainerView.alpha = 1
//            self.detailsContainerView.alpha = 0
//        default:
//            self.filesContainerView.alpha = 0
//            self.detailsContainerView.alpha = 1
//        }
//        
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "TorrentFilesSegue" {
//            let vc = segue.destination as! TorrentFilesTableViewController
//            vc.viewModel = viewModel.torrentFilesViewModel
//        }
//    }
//    
//}

