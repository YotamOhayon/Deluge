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
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel
            .title
            .bind(to: self.torrentNameLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        self.addButton
            .rx
            .tap
            .bind(to: viewModel.addTapped)
            .disposed(by: self.disposeBag)
        
        viewModel.addTapped.subscribe(onNext: { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
        
    }

}
