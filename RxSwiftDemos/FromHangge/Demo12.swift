//
//  Demo12.swift
//  RxSwiftDemos
//
//  Created by ChildhoodAndy on 2019/7/5.
//  Copyright © 2019 ChildhoodAndy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class Demo12 : BaseDemo {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        example("toArray") {
            Observable.of(1, 2, 3)
                .toArray()
                .asObservable()
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        }
        
        example("reduce") {
            Observable.of(1, 2, 3, 4, 5)
                .reduce(2, accumulator: *)
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        }
        
        example("concat") {
            let subject1 = BehaviorSubject(value: 1)
            let subject2 = BehaviorSubject(value: 2)
            
            let variable = BehaviorRelay(value: subject1)
            variable.asObservable()
                .concat()
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
            
            subject2.onNext(2)
            subject1.onNext(1)
            subject1.onNext(1)
            subject1.onCompleted()
            
            variable.accept(subject2)
            subject2.onNext(2)

        }
    }

}
