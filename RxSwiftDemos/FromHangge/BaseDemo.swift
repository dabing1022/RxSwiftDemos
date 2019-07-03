//
//  BaseDemo.swift
//  RxSwiftDemos
//
//  Created by ChildhoodAndy on 2019/7/2.
//  Copyright © 2019 ChildhoodAndy. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class BaseDemo : UIViewController {
    
    var textView: UITextView!
    var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        textView = UITextView()
        textView.isEditable = false
        textView.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        textView.backgroundColor = .black
        textView.textColor = .white
        self.view.addSubview(textView)
        textView.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(self.view.snp_topMargin).offset(10)
            make.height.equalTo(150)
        }
        
        mainView = UIView()
        self.view.addSubview(mainView)
        mainView.snp_makeConstraints { (make) in
            make.left.right.equalTo(textView)
            make.top.equalTo(textView.snp_bottom).offset(10)
            make.bottom.equalTo(self.view.snp_bottomMargin).offset(-10)
        }
    }
    
    deinit {
        print("deinit...")
    }

    func showMessage(_ message: String) {
        printMessage(message)
    }
    
    func printMessage<T>(_ message: T) {
        printMessage("\(message)")
    }
    
    func printMessage(_ message: String) {
        if (self.textView.text.count > 0) {
            self.textView.text.append("\n")
        }
        self.textView.text.append(message)
        _scrollToBottom()

        print(message)
    }
    
    func example(_ description: String, action: () -> Void) {
        printMessage("==========\(description)========")
        action()
    }
    
    func delay(_ delay: Double, closure: @escaping () -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    private func _scrollToBottom() {
        if (self.textView.text.count > 0) {
            self.textView .scrollRangeToVisible(NSRange(location: self.textView.text.count - 1, length: 1))
        }
    }
}
