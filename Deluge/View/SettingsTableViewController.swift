//
//  SettingsTableViewController.swift
//  Deluge
//
//  Created by Yotam Ohayon on 26/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum Segue: String {
    
    case settingsCancel = "SettingsCancelSegue"
    case settingsDone = "SettingsDoneSegue"
    
    init?(segue: UIStoryboardSegue) {
        
        guard let identifier = segue.identifier else {
            return nil
        }
        self.init(rawValue: identifier)
        
    }
    
}

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var hostnameTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var connectionStatusLabel: UILabel!
    
    let disposeBag = DisposeBag()
    var viewModel: SettingsViewModeling!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        
        self.viewModel
            .hostnameObservable
            .bind(to: self.hostnameTextField.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel
            .portObservable
            .bind(to: self.portTextField.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel
            .passwordObservable
            .bind(to: self.passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        self.hostnameTextField
            .rx
            .text
            .bind(to: viewModel.hostname)
            .disposed(by: disposeBag)
        
        self.portTextField
            .rx
            .text
            .bind(to: viewModel.port)
            .disposed(by: disposeBag)
        
        self.passwordTextField
            .rx
            .text
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        viewModel.connectionLabel
            .bind(to: self.connectionStatusLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.connectionLabel.subscribe(onNext: { [unowned self] text in
            self.connectionStatusLabel.attributedText = text
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(self.hostnameTextField.rx.text,
                                 self.portTextField.rx.text,
                                 self.passwordTextField.rx.text)
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _, _, _ in
                self?.viewModel.done()
        }).disposed(by: disposeBag)

    }

}
