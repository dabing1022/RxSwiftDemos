//
//  Demo16.swift
//  RxSwiftDemos
//
//  Created by ChildhoodAndy on 2019/7/3.
//  Copyright © 2019 ChildhoodAndy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class Demo16 : BaseDemo {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _printRxResources()
        // 我们可以将 debug 调试操作符添加到一个链式步骤当中，这样系统就能将所有的订阅者、事件、和处理等详细信息打印出来，方便我们开发调试。
        let disposeBag = DisposeBag()
        
        _printRxResources()
        
        Observable.of("2", "3")
            .startWith("1")
//            .debug("test-debug")      // use name
            .debug()                  // not use name
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        _printRxResources()
    }
    
    private func _printRxResources() {
        #if TRACE_RESOURCES
        print("Resources: \(RxSwift.Resources.total)")
        #endif
    }
}
