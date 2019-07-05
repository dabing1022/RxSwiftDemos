//
//  Demo10.swift
//  RxSwiftDemos
//
//  Created by ChildhoodAndy on 2019/7/5.
//  Copyright © 2019 ChildhoodAndy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class Demo10 : BaseDemo {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         当传入多个 Observables 到 amb 操作符时，它将取第一个发出元素或产生事件的 Observable，然后只发出它的元素。并忽略掉其他的 Observables。
         */
        example("amb") {
            let subject1 = PublishSubject<Int>()
            let subject2 = PublishSubject<Int>()
            let subject3 = PublishSubject<Int>()
            
            subject1
                .amb(subject2)
                .amb(subject3)
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
            
            subject2.onNext(1)
            subject1.onNext(20)
            subject2.onNext(2)
            subject1.onNext(40)
            subject3.onNext(0)
            subject2.onNext(3)
            subject1.onNext(60)
            subject3.onNext(0)
            subject3.onNext(0)
        }
        
        example("takeWhile") {
            Observable.of(2, 3, 4, 5, 6)
                .takeWhile { $0 < 4 }
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        }
        
        example("takeUntil") {
            let source = PublishSubject<String>()
            let notifier = PublishSubject<String>()
            
            source
                .takeUntil(notifier)
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
            
            source.onNext("a")
            source.onNext("b")
            source.onNext("c")
            source.onNext("d")
            
            //停止接收消息
            notifier.onNext("z")
            
            source.onNext("e")
            source.onNext("f")
            source.onNext("g")
        }
        
        example("skipWhile") {
            Observable.of(2, 3, 4, 5, 6)
                .skipWhile { $0 < 4 }
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        }
        
        example("skipUntil") {
            let source = PublishSubject<Int>()
            let notifier = PublishSubject<Int>()
            
            source
                .skipUntil(notifier)
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
            
            source.onNext(1)
            source.onNext(2)
            source.onNext(3)
            source.onNext(4)
            source.onNext(5)
            
            //开始接收消息
            notifier.onNext(0)
            
            source.onNext(6)
            source.onNext(7)
            source.onNext(8)
            
            //仍然接收消息
            notifier.onNext(0)
            
            source.onNext(9)
        }
    }

}
