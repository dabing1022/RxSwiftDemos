//
//  Demo09.swift
//  RxSwiftDemos
//
//  Created by ChildhoodAndy on 2019/7/5.
//  Copyright © 2019 ChildhoodAndy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class Demo09 : BaseDemo {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        example("filter") {
            Observable.of(2, 30, 22, 5, 60, 3, 40 ,9)
                .filter {
                    $0 > 10
                }
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        }
        
        example("distinctUntilChanged") {
            Observable.of(1, 2, 3, 1, 1, 4)
                .distinctUntilChanged()
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        }
        
        /*
         * 限制只发送一次事件，或者满足条件的第一个事件。
         * 如果存在有多个事件或者没有事件都会发出一个 error 事件。
         * 如果只有一个事件，则不会发出 error 事件。
         */
        example("single") {
            Observable.of(1, 2, 3, 4)
                .single{ $0 == 2 }
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
            
            Observable.of("A", "B", "C", "D")
                .single()
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        }
        
        example("elementAt") {
            Observable.of(1, 2, 3, 4)
                .elementAt(2)
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        }
        
        example("ignoreElements") {
            Observable.of(1, 2, 3, 4)
                .ignoreElements()
                .subscribe{
                    print($0)
                }
                .disposed(by: disposeBag)
        }
        
        example("take") {
            Observable.of(1, 2, 3, 4)
                .take(2)
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        }
        
        example("takeLast") {
            Observable.of(1, 2, 3, 4)
                .takeLast(1)
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        }
        
        example("skip") {
            Observable.of(1, 2, 3, 4)
                .skip(2)
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        }
        
        example("sample") {
            let source = PublishSubject<Int>()
            let notifier = PublishSubject<String>()
            
            source
                .sample(notifier)
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
            
            source.onNext(1)
            
            //让源序列接收接收消息
            notifier.onNext("A")
            
            source.onNext(2)
            
            //让源序列接收接收消息
            notifier.onNext("B")
            notifier.onNext("C")
            
            source.onNext(3)
            source.onNext(4)
            
            //让源序列接收接收消息
            notifier.onNext("D")
            
            source.onNext(5)
            
            //让源序列接收接收消息
            notifier.onCompleted()
        }
        
        example("debounce") {
            //定义好每个事件里的值以及发送的时间
            let times = [
                [ "value": 1, "time": 1 ],
                [ "value": 2, "time": 2 ],
                [ "value": 3, "time": 4 ],
                [ "value": 4, "time": 9 ],
                [ "value": 5, "time": 10 ],
                [ "value": 6, "time": 16 ]
            ]
            
            //生成对应的 Observable 序列并订阅
            Observable.from(times)
                .flatMap { item in
                    return Observable.of(Int(item["value"]!))
                        .delaySubscription(.seconds(Int(item["time"]!)),
                                           scheduler: MainScheduler.instance)
                }
                .debounce(.seconds(4), scheduler: MainScheduler.instance) //只发出与下一个间隔超过 4 秒的元素
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        }
    }
}
