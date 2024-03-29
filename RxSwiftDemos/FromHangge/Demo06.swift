//
//  Demo06.swift
//  RxSwiftDemos
//
//  Created by ChildhoodAndy on 2019/7/3.
//  Copyright © 2019 ChildhoodAndy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class Demo06 : BaseDemo {
    
    var label: UILabel!
    
    let disposeBag = DisposeBag()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        printMessage("UILabel自定义可绑定属性fontSize")
        
        let startFontSize: CGFloat = 10.0
        
        label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: startFontSize)
        label.text = "Hello RxSwift!"
        self.mainView.addSubview(label)
        label.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        //Observable序列（每隔1秒钟发出一个索引数）
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        observable
            .map { startFontSize + CGFloat($0) }
//            .bind(to: label.fontSize) // bind way 1
            .bind(to: label.rx.fontSize) // bind way 2
            .disposed(by: disposeBag)
    }
}



// MARK: bind way 1

//extension UILabel {
//    public var fontSize: Binder<CGFloat> {
//        return Binder(self) { label, fontSize in
//            label.font = UIFont.systemFont(ofSize: fontSize)
//        }
//    }
//}

// MARK: bind way 2

extension Reactive where Base: UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self.base) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}
