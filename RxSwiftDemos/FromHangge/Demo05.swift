//
//  Demo05.swift
//  RxSwiftDemos
//
//  Created by ChildhoodAndy on 2019/7/3.
//  Copyright © 2019 ChildhoodAndy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit

class Demo05 : BaseDemo {
    
    var label: UILabel!
    var button: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label = UILabel()
        label.textColor = .red
        self.mainView.addSubview(label)
        label.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        button = UIButton.init(type: .custom)
        button.setTitle("Button Enabled", for: .normal)
        button.setTitle("Button Disabled", for: .disabled)
        button.setTitleColor(.red, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        self.mainView.addSubview(button)
        button.snp_makeConstraints { (make) in
            make.top.equalTo(self.label.snp_bottom).offset(10)
            make.centerX.equalTo(self.label)
        }

//        _example_bind()
        _example_binder()
    }
    
    private func _example_bind() {
        //Observable序列（每隔1秒钟发出一个索引数）
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        observable
            .map { "当前索引数：\($0 )"}
            .bind { [weak self] (text) in
                //收到发出的索引数后显示到label上
                self?.label.text = text
            }
            .disposed(by: disposeBag)
    }
    
    // （1）相较于 AnyObserver 的大而全，Binder 更专注于特定的场景。Binder 主要有以下两个特征：
    // 不会处理错误事件
    // 确保绑定都是在给定 Scheduler 上执行（默认 MainScheduler）
    // （2）一旦产生错误事件，在调试环境下将执行 fatalError，在发布环境下将打印错误信息。
    private func _example_binder() {
        //观察者
        let observer: Binder<String> = Binder(label) { (view, text) in
            //收到发出的索引数后显示到label上
            view.text = text
        }
        
        //Observable序列（每隔1秒钟发出一个索引数）
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        observable
            .map { "当前索引数：\($0 )"}
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        observable
            .map { $0 % 2 == 0 }
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
