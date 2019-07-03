//
//  Demo14.swift
//  RxSwiftDemos
//
//  Created by ChildhoodAndy on 2019/7/3.
//  Copyright © 2019 ChildhoodAndy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class Demo14 : BaseDemo {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        example("delay") {
            Observable.of("1", "2", "3")
                .delay(.seconds(2), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] (element) in
                    self?.printMessage(element)
                })
                .disposed(by: disposeBag)
        }
        
        example("delaySubscription") {
            Observable.of("4", "5", "6")
                .delaySubscription(.seconds(3), scheduler: MainScheduler.instance) //延迟3秒才开始订阅
                .subscribe(onNext: { [weak self] (element) in
                    self?.printMessage(element)
                })
                .disposed(by: disposeBag)
        }
        
        
        example("materialize") {
            Observable.of("7", "8", "9")
                .materialize()
                .subscribe(onNext: { [weak self] (element) in
                    self?.printMessage(element)
                })
                .disposed(by: disposeBag)
        }
        
        example("dematerialize") {
            Observable.of("7", "8", "9")
                .materialize()
                .dematerialize()
                .subscribe(onNext: { [weak self] (element) in
                    self?.printMessage(element)
                })
                .disposed(by: disposeBag)
        }
        
        example("timeout") {
            //定义好每个事件里的值以及发送的时间
            let times = [
                [ "value": "100", "time": 0 ],
                [ "value": "200", "time": 1 ],
                [ "value": "300", "time": 2 ],
                [ "value": "400", "time": 6 ],
                [ "value": "500", "time": 7 ]
            ]
            //生成对应的 Observable 序列并订阅
            Observable.from(times)
                .flatMap { item in
                    return Observable.of(item["value"]! as! String)
                        .delaySubscription(.seconds(item["time"]! as! Int),
                                           scheduler: MainScheduler.instance)
                }
                .timeout(.seconds(2), scheduler: MainScheduler.instance) //超过两秒没发出元素，则产生error事件
                .subscribe(onNext: { [weak self] (element) in
                    self?.printMessage(element)
                }, onError: { [weak self] (error) in
                    self?.printMessage(error)
                })
                .disposed(by: disposeBag)
        }

    }
    
}
