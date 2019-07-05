//
//  Demo08.swift
//  RxSwiftDemos
//
//  Created by ChildhoodAndy on 2019/7/5.
//  Copyright © 2019 ChildhoodAndy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class Demo08 : BaseDemo {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        _example_buffer()
//        _example_window()
//        _example_map()
//        _example_flatMap()
//        _example_flatMapLatest()
//        _example_flatMapFirst()
//        _example_concatMap()
//        _example_scan()
        _example_groupBy()
    }
    
    /**
     buffer 方法作用是缓冲组合，第一个参数是缓冲时间，第二个参数是缓冲个数，第三个参数是线程。
     该方法简单来说就是缓存 Observable 中发出的新元素，当元素达到某个数量，或者经过了特定的时间，它就会将这个元素集合发送出来。
     */
    private func _example_buffer() {
        example("buffer") {
            let subject = PublishSubject<String>()
            //每缓存3个元素则组合起来一起发出。
            //如果1秒钟内不够3个也会发出（有几个发几个，一个都没有发空数组 []）
            subject
                .buffer(timeSpan: .seconds(1), count: 3, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] element in
                    self?.printMessage(element)
                })
                .disposed(by: disposeBag)
            
            subject.onNext("a")
            subject.onNext("b")
            subject.onNext("c")
            subject.onNext("d")
            subject.onNext("e")
            
            subject.onNext("1")
            subject.onNext("2")
            subject.onNext("3")
        }
    }
    
    /**
     window 操作符和 buffer 十分相似。不过 buffer 是周期性的将缓存的元素集合发送出来，而 window 周期性的将元素集合以 Observable 的形态发送出来。
     同时 buffer 要等到元素搜集完毕后，才会发出元素序列。而 window 可以实时发出元素序列。
     */
    private func _example_window() {
        example("window") {
            let subject = PublishSubject<String>()
            
            //每3个元素作为一个子Observable发出。
            subject
                .window(timeSpan: .seconds(1), count: 3, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] element in
                    self?.printMessage("subscribe: \(element)")
                    element.asObservable()
                        .subscribe(onNext: { [weak self] element2 in
                            self?.printMessage("++++ \(element2)")
                        })
                        .disposed(by: self!.disposeBag)
                })
                .disposed(by: disposeBag)
            
            subject.onNext("a")
            subject.onNext("b")
            subject.onNext("c")
            
            subject.onNext("1")
            subject.onNext("2")
            subject.onNext("3")
        }
    }
    
    private func _example_map() {
        example("map") {
            Observable.of(1, 2, 3)
                .map { $0 * 10}
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        }
    }
    
    private func _example_flatMap() {
        example("flatMap") {
            let subject1 = BehaviorSubject(value: "A")
            let subject2 = BehaviorSubject(value: "1")
            
            let variable = BehaviorRelay(value: subject1)
            
            variable.asObservable()
                .flatMap { $0 }
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
            
            subject1.onNext("B")
            variable.accept(subject2)
            subject2.onNext("2")
            subject1.onNext("C")
        }
    }
    
    private func _example_flatMapLatest() {
        example("flatMapLatest") {
            let subject1 = BehaviorSubject(value: "A")
            let subject2 = BehaviorSubject(value: "1")
            
            let variable = BehaviorRelay(value: subject1)
            
            variable.asObservable()
                .flatMapLatest { $0 }
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
            
            subject1.onNext("B")
            variable.accept(subject2)
            subject2.onNext("2")
            subject1.onNext("C")
        }
    }
    
    private func _example_flatMapFirst() {
        example("flatMapFirst") {
            let subject1 = BehaviorSubject(value: "A")
            let subject2 = BehaviorSubject(value: "1")
            
            let variable = BehaviorRelay(value: subject1)
            
            variable.asObservable()
                .flatMapFirst { $0 }
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
            
            subject1.onNext("B")
            variable.accept(subject2)
            subject2.onNext("2")
            subject1.onNext("C")
        }
    }
    
    private func _example_concatMap() {
        example("concatMap") {
            let subject1 = BehaviorSubject(value: "A")
            let subject2 = BehaviorSubject(value: "1")
            
            let variable = BehaviorRelay(value: subject1)
            
            variable.asObservable()
                .concatMap { $0 }
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
            
            subject1.onNext("B")
            variable.accept(subject2)
            subject2.onNext("2")
            subject1.onNext("C")
            subject1.onCompleted() //只有前一个序列结束后，才能接收下一个序列
        }
    }
    
    private func _example_scan() {
        example("scan") {
            Observable.of(1, 2, 3, 4, 5)
                .scan(0) { acum, elem in
                    acum + elem
                }
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        }
    }
    
    private func _example_groupBy() {
        example("groupBy") {
            //将奇数偶数分成两组
            Observable<Int>.of(0, 1, 2, 3, 4, 5)
                .groupBy(keySelector: { (element) -> String in
                    print("element -- \(element)")
                    return element % 2 == 0 ? "偶数" : "基数"
                })
                .subscribe(onNext: { (group) in
                    group.asObservable().subscribe({ (event) in
                        print("key：\(group.key) event:\(event) element：\(event.element ?? 9999)")
                    })
                    .disposed(by: self.disposeBag)
                })
                .disposed(by: disposeBag)
        }
    }
}
