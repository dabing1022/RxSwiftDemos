//
//  Demo20.swift
//  RxSwiftDemos
//
//  Created by ChildhoodAndy on 2019/7/5.
//  Copyright © 2019 ChildhoodAndy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class Demo20 : BaseDemo {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        example("GCD") {
//            //现在后台获取数据
//            DispatchQueue.global(qos: .userInitiated).async {
//                if let htmlContent = try? String(contentsOf: URL(string: "http://www.hangge.com/blog/cache/detail_1940.html")!) {
//                    //再到主线程显示结果
//                    DispatchQueue.main.async {
//                        print("\(htmlContent)")
//                    }
//                }
//
//            }
//        }
        
        /*
         CurrentThreadScheduler：表示当前线程 Scheduler。（默认使用这个）
         MainScheduler：表示主线程。如果我们需要执行一些和 UI 相关的任务，就需要切换到该 Scheduler 运行。
         SerialDispatchQueueScheduler：封装了 GCD 的串行队列。如果我们需要执行一些串行任务，可以切换到这个 Scheduler 运行。
         ConcurrentDispatchQueueScheduler：封装了 GCD 的并行队列。如果我们需要执行一些并发任务，可以切换到这个 Scheduler 运行。
         OperationQueueScheduler：封装了 NSOperationQueue。
         */
        example("subscribeOn & observeOn") {
            let rxData: Observable<String> = Observable<String>.create { (observer) -> Disposable in
                if let htmlContent = try? String(contentsOf: URL(string: "http://www.hangge.com/blog/cache/detail_1940.html")!) {
                    observer.onNext(htmlContent)
                }
                
                return Disposables.create()
            }
                
            rxData
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated)) //后台构建序列
                .observeOn(MainScheduler.instance)  //主线程监听并处理序列结果
                .subscribe(onNext: { data in
                    print("data: \n \(data)")
                })
                .disposed(by: disposeBag)
        }
    }
}
