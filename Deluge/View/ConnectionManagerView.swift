//
//  ConnectionManagerView.swift
//  Deluge
//
//  Created by Yotam Ohayon on 17/10/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import Delugion
import RxSwift
import RxCocoa

class ConnectionManagerView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    let buttonTapped = PublishSubject<String>()
    let bag = DisposeBag()
    
    var model: [Host]? {
        didSet {
            self.model?.forEach { [weak self] host in
                guard let `self` = self else {
                    return
                }
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                let title = "\(host.hostname):\(host.port)"
                button.setTitle(title, for: .normal)
                button.setTitleColor(.blue, for: .normal)
                button.rx
                    .tap
                    .map { host.hash }
                    .bind(to: self.buttonTapped)
                    .disposed(by: bag)
                self.stackView.addArrangedSubview(button)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        
        let nib = UINib(nibName: "ConnectionManagerView",
                        bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.red
        
    }

}

extension Reactive where Base == ConnectionManagerView {
    
    var model: Binder<[Host]?> {
        return Binder(self.base) { view, model in
            view.model = model
        }
    }
    
}
