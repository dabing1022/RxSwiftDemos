//
//  Demo11.swift
//  RxSwiftDemos
//
//  Created by ChildhoodAndy on 2019/7/5.
//  Copyright © 2019 ChildhoodAndy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class Demo11 : BaseDemo {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        example("startWith") {
            Observable.of("2", "3")
                .startWith("1")
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
            
            Observable.of("2", "3")
                .startWith("a")
                .startWith("b")
                .startWith("c")
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        }
        
        example("merge") {
            let subject1 = PublishSubject<Int>()
            let subject2 = PublishSubject<Int>()
            
            Observable.of(subject1, subject2)
                .merge()
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
            
            subject1.onNext(20)
            subject1.onNext(40)
            subject1.onNext(60)
            subject2.onNext(1)
            subject1.onNext(80)
            subject1.onNext(100)
            subject2.onNext(1)
        }
        
        example("zip1") {
            let subject1 = PublishSubject<Int>()
            let subject2 = PublishSubject<String>()
            
            Observable.zip(subject1, subject2) {
                "\($0)\($1)"
                }
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
            
            subject1.onNext(1)
            subject2.onNext("A")
            subject1.onNext(2)
            subject2.onNext("B")
            subject2.onNext("C")
            subject2.onNext("D")
            subject1.onNext(3)
            subject1.onNext(4)
            subject1.onNext(5)
        }
        
        example("zip2") {
            //第一个请求
            let userRequest: Observable<String> = Observable<String>.create { [weak self] (observer) -> Disposable in
                // 模拟网络请求
                self?.delay(1) {
                    observer.onNext("user 200")
                }
                return Disposables.create()
            }
            
            //第二个请求
            let friendsRequest: Observable<String> = Observable<String>.create { [weak self] (observer) -> Disposable in
                // 模拟网络请求
                self?.delay(3) {
                    observer.onNext("friend 100")
                }
                return Disposables.create()
            }
            
            //将两个请求合并处理
            Observable.zip(userRequest, friendsRequest) { user, friends in
                    //将两个信号合并成一个信号，并压缩成一个元组返回（两个信号均成功）
                    return (user, friends)
                }
                .observeOn(MainScheduler.instance) //加这个是应为请求在后台线程，下面的绑定在前台线程。
                .subscribe(onNext: { (user, friends) in
                    // 3s 后输出
                    print("user: \(user), friends: \(friends)")
                })
                .disposed(by: disposeBag)
        }
        
        example("combineLatest") {
            let subject1 = PublishSubject<Int>()
            let subject2 = PublishSubject<String>()
            
            Observable.combineLatest(subject1, subject2) {
                "\($0)\($1)"
                }
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
            
            subject1.onNext(1)
            subject2.onNext("A")
            subject1.onNext(2)
            subject2.onNext("B")
            subject2.onNext("C")
            subject2.onNext("D")
            subject1.onNext(3)
            subject1.onNext(4)
            subject1.onNext(5)
        }
        
        // 该方法将两个 Observable 序列合并为一个。每当 self 队列发射一个元素时，便从第二个序列中取出最新的一个值。
        example("withLatestFrom") {
            let subject1 = PublishSubject<String>()
            let subject2 = PublishSubject<String>()
            
            subject1.withLatestFrom(subject2)
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
            
            subject1.onNext("A")
            subject2.onNext("1")
            subject1.onNext("B")
            subject1.onNext("C")
            subject2.onNext("2")
            subject1.onNext("D")
        }
        
        example("switchLatest") {
            let subject1 = BehaviorSubject(value: "A")
            let subject2 = BehaviorSubject(value: "1")
            
            let variable = BehaviorRelay(value: subject1)
            
            variable.asObservable()
                .switchLatest()
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
            
            subject1.onNext("B")
            subject1.onNext("C")
            
            //改变事件源
            variable.accept(subject2)
            subject1.onNext("D")
            subject2.onNext("2")
            
            //改变事件源
            variable.accept(subject1)
            subject2.onNext("3")
            subject1.onNext("E")
        }
    }
}
