//: Playground - noun: a place where people can play

import UIKit
import Delugion
import RxSwift
import PlaygroundSupport
@testable import DelugePlayground

PlaygroundPage.current.needsIndefiniteExecution = true

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello, World!"
        label.textColor = .black
        
        let button = UIButton()
        button.frame = CGRect(x: 150, y: 230, width: 200, height: 20)
        button.setTitle("Click Me", for: .normal)
        
        view.addSubview(label)
        self.view = view
    }
    
}

PlaygroundPage.current.liveView = MyViewController()

