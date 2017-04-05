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

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var hostnameTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let disposeBag = DisposeBag()
    var viewModel: SettingsViewModeling!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        
        self.tableView.backgroundView = UIView()
        let tap = UITapGestureRecognizer()
        self.tableView.backgroundView?.addGestureRecognizer(tap)
        
        tap.rx
            .event
            .filter { $0.state == .ended }
            .map { _ in true }.asDriver(onErrorJustReturn: true)
            .drive(self.view.rx.endEditing)
            .disposed(by: disposeBag)
        
        self.viewModel
            .initialHostname
            .drive(self.hostnameTextField.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel
            .initialPort
            .drive(self.portTextField.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel
            .initialPassword
            .drive(self.passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
        let hostNextButton = UIButton(frame: frame)
        hostNextButton.setTitle("Next", for: .normal)
        
        hostNextButton
            .rx
            .tap
            .asDriver()
            .drive(portTextField.rx.becomeFirstResponder)
            .disposed(by: disposeBag)
        hostNextButton.backgroundColor = UIColor.blue
        self.hostnameTextField.inputAccessoryView = hostNextButton
        
        self.hostnameTextField
            .rx
            .controlEvent(.editingDidEnd)
            .map {
                [weak self] in self?.hostnameTextField.text
            }
            .bind(to: viewModel.hostname)
            .disposed(by: disposeBag)
        
        let portNextButton = UIButton(frame: frame)
        portNextButton.setTitle("Next", for: .normal)
        portNextButton
            .rx
            .tap
            .asDriver()
            .drive(passwordTextField.rx.becomeFirstResponder)
            .disposed(by: disposeBag)
        portNextButton.backgroundColor = UIColor.blue
        self.portTextField.inputAccessoryView = portNextButton
        
        self.portTextField
            .rx
            .controlEvent(.editingDidEnd)
            .map {
                [weak self] in self?.portTextField.text
            }
            .bind(to: viewModel.port)
            .disposed(by: disposeBag)
        
        let passwordDoneButton = UIButton(frame: frame)
        passwordDoneButton.setTitle("Done", for: .normal)
        passwordDoneButton
            .rx
            .tap
            .asDriver()
            .drive(passwordTextField.rx.resignFirstResponder)
            .disposed(by: disposeBag)
        passwordDoneButton.backgroundColor = UIColor.blue
        self.passwordTextField.inputAccessoryView = passwordDoneButton
        
        self.passwordTextField
            .rx
            .controlEvent(.editingDidEnd)
            .map {
                [weak self] in self?.passwordTextField.text
            }
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)

    }

}
