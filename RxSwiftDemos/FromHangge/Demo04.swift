//
//  Demo04.swift
//  RxSwiftDemos
//
//  Created by ChildhoodAndy on 2019/7/3.
//  Copyright © 2019 ChildhoodAndy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class Demo04 : BaseDemo {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //第1个Observable，及其订阅
        let observable1 = Observable.of("A", "B", "C")
        observable1.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
        
        //第2个Observable，及其订阅
        let observable2 = Observable.of(1, 2, 3)
        observable2.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
    }
}
