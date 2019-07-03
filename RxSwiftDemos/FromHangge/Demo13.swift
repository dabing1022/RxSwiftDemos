//
//  Demo13.swift
//  RxSwiftDemos
//
//  Created by ChildhoodAndy on 2019/7/3.
//  Copyright © 2019 ChildhoodAndy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class Demo13 : BaseDemo {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        _example_normal()
//        _example_publish()
//        _example_replay()
//        _example_multicast()
//        _example_refCount()
        _example_shareReplay()
    }
    
    private func _example_normal() {
        example("normal") {
            //每隔1秒钟发送1个事件
            let interval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            
            //第一个订阅者（立刻开始订阅）
            _ = interval
                .subscribe(onNext: { [weak self] element in
                    self?.printMessage("订阅1: \(element)")
                })
            
            //第二个订阅者（延迟5秒开始订阅）
            delay(5) {
                _ = interval
                    .subscribe(onNext: { [weak self] element in
                        self?.printMessage("订阅2: \(element)")
                    })
            }
        }
    }
    
    private func _example_publish() {
        // publish 方法会将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始。
        // 原文出自：www.hangge.com  转载请保留原文链接：http://www.hangge.com/blog/cache/detail_1935.html
        example("publish") {
            //每隔1秒钟发送1个事件
            let interval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                .publish()
            
            //第一个订阅者（立刻开始订阅）
            _ = interval
                .subscribe(onNext: { [weak self] element in
                    self?.printMessage("订阅3: \(element)")
                })
            
            //相当于把事件消息推迟了两秒
            delay(2) {
                _ = interval.connect()
            }

            //第二个订阅者（延迟5秒开始订阅）
            delay(5) {
                _ = interval
                    .subscribe(onNext: { [weak self] element in
                        self?.printMessage("订阅4: \(element)")
                    })
            }
        }
    }
    
    private func _example_replay() {
        // replay 同上面的 publish 方法相同之处在于：会将将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始。
        // replay 与 publish 不同在于：新的订阅者还能接收到订阅之前的事件消息（数量由设置的 bufferSize 决定）。
        
        // 原文出自：www.hangge.com  转载请保留原文链接：http://www.hangge.com/blog/cache/detail_1935.html
        example("replay") {
            //每隔1秒钟发送1个事件
            let interval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                .replay(5)
            
            //第一个订阅者（立刻开始订阅）
            _ = interval
                .subscribe(onNext: { [weak self] element in
                    self?.printMessage("订阅5: \(element)")
                })
            
            //相当于把事件消息推迟了两秒
            delay(2) {
                _ = interval.connect()
            }
            
            //第二个订阅者（延迟5秒开始订阅）
            delay(5) {
                _ = interval
                    .subscribe(onNext: { [weak self] element in
                        self?.printMessage("订阅6: \(element)")
                    })
            }
        }
    }
    
    private func _example_multicast() {
        // multicast 方法同样是将一个正常的序列转换成一个可连接的序列。
        // 同时 multicast 方法还可以传入一个 Subject，每当序列发送事件时都会触发这个 Subject 的发送。
        example("multicast") {
            //创建一个Subject（后面的multicast()方法中传入）
            let subject = PublishSubject<Int>()
            
            //这个Subject的订阅
            _ = subject
                .subscribe(onNext: { [weak self] element in
                    self?.printMessage("订阅7: \(element)")
                })
            
            //每隔1秒钟发送1个事件
            let interval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                .multicast(subject)
            
            //第一个订阅者（立刻开始订阅）
            _ = interval
                .subscribe(onNext: { [weak self] element in
                    self?.printMessage("订阅8: \(element)")
                })
            
            //相当于把事件消息推迟了两秒
            delay(2) {
                _ = interval.connect()
            }
            
            //第二个订阅者（延迟5秒开始订阅）
            delay(5) {
                _ = interval
                    .subscribe(onNext: { [weak self] element in
                        self?.printMessage("订阅9: \(element)")
                    })
            }
        }
    }
    
    private func _example_refCount() {
        // refCount 操作符可以将可被连接的 Observable 转换为普通 Observable
        // 即该操作符可以自动连接和断开可连接的 Observable。当第一个观察者对可连接的 Observable 订阅时，那么底层的 Observable 将被自动连接。当最后一个观察者离开时，那么底层的 Observable 将被自动断开连接。
        example("refCount") {
            //每隔1秒钟发送1个事件
            let interval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                .publish()
                .refCount()

            //第一个订阅者（立刻开始订阅）
            _ = interval
                .subscribe(onNext: { [weak self] element in
                    self?.printMessage("订阅10: \(element)")
                })
            
            //第二个订阅者（延迟5秒开始订阅）
            delay(5) {
                _ = interval
                    .subscribe(onNext: { [weak self] element in
                        self?.printMessage("订阅11: \(element)")
                    })
            }
        }
    }
    
    private func _example_shareReplay() {
        // 该操作符将使得观察者共享源 Observable，并且缓存最新的 n 个元素，将这些元素直接发送给新的观察者。
        example("shareReplay") {
            //每隔1秒钟发送1个事件
            let interval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                .share(replay: 5)
            
            //第一个订阅者（立刻开始订阅）
            _ = interval
                .subscribe(onNext: { [weak self] element in
                    self?.printMessage("订阅12: \(element)")
                })
            
            //第二个订阅者（延迟5秒开始订阅）
            delay(5) {
                _ = interval
                    .subscribe(onNext: { [weak self] element in
                        self?.printMessage("订阅13: \(element)")
                    })
            }
        }
    }
}


