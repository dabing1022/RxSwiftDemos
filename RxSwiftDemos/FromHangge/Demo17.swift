//
//  Demo17.swift
//  RxSwiftDemos
//
//  Created by ChildhoodAndy on 2019/7/5.
//  Copyright © 2019 ChildhoodAndy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//获取豆瓣某频道下的歌曲信息
func getPlaylist(_ channel: String) -> Single<[String: Any]> {
    return Single<[String: Any]>.create { single in
        let url = "https://douban.fm/j/mine/playlist?"
            + "type=n&channel=\(channel)&from=mainsite"
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
            if let error = error {
                single(.error(error))
                return
            }
            
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data,
                                                             options: .mutableLeaves),
                let result = json as? [String: Any] else {
                    single(.error(DataError.cantParseJSON))
                    return
            }
            
            single(.success(result))
        }
        
        task.resume()
        
        return Disposables.create { task.cancel() }
    }
}

//与数据相关的错误类型
enum DataError: Error {
    case cantParseJSON
}

class Demo17 : BaseDemo {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        example("single") {
            //获取第0个频道的歌曲信息
            getPlaylist("0")
                .subscribe { event in
                    switch event {
                    case .success(let json):
                        print("JSON结果: ", json)
                    case .error(let error):
                        print("发生错误: ", error)
                    }
                }
                .disposed(by: disposeBag)
        }
    }
}
