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
        
        self.hostnameTextField
            .rx
            .text
            .bindTo(viewModel.hostname)
            .disposed(by: disposeBag)
        
        self.portTextField
            .rx
            .text
            .bindTo(viewModel.port)
            .disposed(by: disposeBag)
        
        self.passwordTextField
            .rx
            .text
            .bindTo(viewModel.password)
            .disposed(by: disposeBag)
        
        viewModel.connectionLabel
            .bindTo(self.connectionStatusLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.connectionLabel.subscribe(onNext: { [unowned self] text in
            self.connectionStatusLabel.attributedText = text
        }).disposed(by: disposeBag)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
