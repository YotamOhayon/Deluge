//
//  MainViewController.swift
//  Deluge
//
//  Created by Yotam Ohayon on 06/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Delugion

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var filterStatusLabel: UILabel!
    
    var themeManager: ThemeManaging!
    var textManager: TextManaging!
    var viewModel: MainViewModeling!
    var errorMessage: UILabel!
    var noInternetView: NotReachableView!
    let disposeBag = DisposeBag()
    
    fileprivate var dataSource = [TorrentProtocol]() {
        didSet {
            let contentOffset = self.tableView.contentOffset;
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
            self.tableView.setContentOffset(contentOffset, animated: false)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        self.filterButton
            .rx
            .tap
            .bind(to: viewModel.filterButtonTapped)
            .disposed(by: self.disposeBag)
        
        self.sortButton
            .rx
            .tap
            .bind(to: viewModel.sortButtonTapped)
            .disposed(by: disposeBag)
        
        self.viewModel
            .filterStatus
            .asObservable()
            .bind(to: self.filterStatusLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel
            .showFilterAlertController
            .asObservable()
            .subscribe(onNext: {
                
                guard let message = $0,
                    let actions = $1,
                    let block = $2,
                    let allBlock = $3,
                    let allTitle = $4,
                    let cancelTitle = $5 else {
                        return
                }
                
                let alert = UIAlertController(title: nil,
                                              message: message,
                                              preferredStyle: .actionSheet)
                
                actions.forEach { action in
                    let filterAction = UIAlertAction(title: action.rawValue,
                                                     style: .default) { _ in
                                                        block(action)
                    }
                    alert.addAction(filterAction)
                }
                
                let allAction = UIAlertAction(title: allTitle,
                                              style: .default)
                { _ in
                    allBlock()
                }
                alert.addAction(allAction)
                
                let cancelAction = UIAlertAction(title: cancelTitle,
                                                 style: .cancel,
                                                 handler: nil)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }).disposed(by: disposeBag)
        
        viewModel.showSortAlertController.asObservable().subscribe(onNext: {
            
            guard let message = $0,
                let actions = $1,
                let block = $2 else {
                    return
            }
            
            let alert = UIAlertController(title: nil,
                                          message: message,
                                          preferredStyle: .actionSheet)
            
            actions.forEach { action in
                let filterAction = UIAlertAction(title: action.description,
                                                 style: .default)
                { _ in
                    block(action)
                }
                alert.addAction(filterAction)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel,
                                             handler: nil)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }).disposed(by: disposeBag)
        
        self.noInternetView = { [unowned self] in
            
            let view = NotReachableView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.isHidden = true
            self.view.addSubview(view)
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            view.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: 30).isActive = true
            return view
            
        }()
        
        self.errorMessage = { [unowned self] in
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isHidden = true
            label.text = nil
            self.view.addSubview(label)
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            return label
            }()
        
        viewModel.isReachable.subscribe(onNext: { [weak self] in
            self?.noInternetView.isHidden = $0
        }).disposed(by: disposeBag)
        
        viewModel.showError.drive(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.tableView.isHidden = $0 != nil
            self.errorMessage.text = $0
            self.errorMessage.isHidden = $0 == nil
        }).disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.isHidden = true
        self.viewModel.torrents.drive(onNext: { [unowned self] in
            guard let torrents = $0 else {
                self.dataSource = [TorrentProtocol]()
                self.tableView.isHidden = true
                return
            }
            self.dataSource = torrents
            self.tableView.isHidden = false
        }).disposed(by: self.disposeBag)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowTorrentSegue" {
            let torrent = sender as! Torrent
            let vc = segue.destination as! TorrentViewController
            vc.viewModel = self.viewModel.viewModel(forTorrent: torrent)
        }
        
    }
    
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {
        
        guard let s = Segue(segue: segue) else {
            return
        }
        
        switch s {
        case .settingsCancel:
            print("cancel")
        case .settingsDone:
            print("done")
        }
        
    }
    
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let torrent = self.dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TorrentCell") as! TorrentTableViewCell
        cell.textManager = self.textManager
        cell.viewModel = TorrentCellViewModel(torrent: torrent, themeManager: self.themeManager)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowTorrentSegue",
                          sender: self.dataSource[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89.0
    }
    
}
