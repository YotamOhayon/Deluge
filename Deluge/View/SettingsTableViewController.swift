//
//  SettingsTableViewController.swift
//  Deluge
//
//  Created by Yotam Ohayon on 26/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import Delugion
import RxCocoa

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
    
    var viewModel: SettingsViewModeling!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()

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
