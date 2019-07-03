//
//  Demo03.swift
//  RxSwiftDemos
//
//  Created by ChildhoodAndy on 2019/7/3.
//  Copyright © 2019 ChildhoodAndy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

fileprivate enum MyError: Error {
    case A
    case B
}

class Demo03 : BaseDemo {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        printMessage(Observable<Int>.just(1))
        printMessage(Observable.of(1, 2, 3))
        printMessage(Observable.from(["A", "B", "C"]))
        printMessage(Observable<Int>.empty())
        printMessage(Observable<Int>.never())
        printMessage(Observable<Int>.error(MyError.A))
        printMessage(Observable.range(start: 1, count: 5))
        
        let observable = Observable<String>.create{observer in
            //对订阅者发出了.next事件，且携带了一个数据"hangge.com"
            observer.onNext("hangge.com")
            //对订阅者发出了.completed事件
            observer.onCompleted()
            //因为一个订阅行为会有一个Disposable类型的返回值，所以在结尾一定要returen一个Disposable
            return Disposables.create()
        }
        
        //订阅测试
        observable.subscribe { [weak self] element in
            self?.printMessage(element)
        }.dispose()
    }
}
