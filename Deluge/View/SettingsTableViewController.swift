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

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var hostnameTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var connectionStatusLabel: UILabel!
    
    var viewModel: SettingsViewModeling!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
