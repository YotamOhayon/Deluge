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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressNumericLabel: UILabel!
    @IBOutlet weak var circularProgressView: KDCircularProgress!
    
    var viewModel: TorrentModeling!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = viewModel.title
        viewModel.progressNumeric.drive(progressNumericLabel.rx.text).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

}
