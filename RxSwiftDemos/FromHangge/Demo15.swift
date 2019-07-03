//
//  Demo15.swift
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

class Demo15 : BaseDemo {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        example("catchErrorJustReturn") {
            let sequenceThatFails = PublishSubject<String>()
            
            sequenceThatFails
                .catchErrorJustReturn("错误")
                .subscribe(onNext: { [weak self] element in
                    self?.printMessage(element)
                })
                .disposed(by: disposeBag)
            
            sequenceThatFails.onNext("a")
            sequenceThatFails.onNext("b")
            sequenceThatFails.onNext("c")
            sequenceThatFails.onError(MyError.A)
            sequenceThatFails.onNext("d")
        }
        
        example("catchError") {
            let sequenceThatFails = PublishSubject<String>()
            let recoverySequence = Observable.of("1", "2", "3")
            
            sequenceThatFails
                .catchError { [weak self] element in
                    self?.printMessage("Error: \(element)")
                    return recoverySequence
                }
                .subscribe(onNext: { [weak self] element in
                    self?.printMessage(element)
                })
                .disposed(by: disposeBag)
            
            sequenceThatFails.onNext("a")
            sequenceThatFails.onNext("b")
            sequenceThatFails.onNext("c")
            sequenceThatFails.onError(MyError.A)
            sequenceThatFails.onNext("d")
        }
        
        example("retry") {
            var count = 1
            
            let sequenceThatErrors = Observable<String>.create { [weak self] observer in
                observer.onNext("a")
                observer.onNext("b")
                
                //让第一个订阅时发生错误
                if count == 1 {
                    observer.onError(MyError.A)
                    self?.printMessage("Error encoutered")
                    count += 1
                }
                
                observer.onNext("c")
                observer.onNext("d")
                observer.onCompleted()
                
                return Disposables.create()
            }
            
            sequenceThatErrors
                .retry(2)  //重试2次（参数为空则只重试一次）
                .subscribe(onNext: { [weak self] element in
                    self?.printMessage(element)
                })
                .disposed(by: disposeBag)
        }
    }
}
