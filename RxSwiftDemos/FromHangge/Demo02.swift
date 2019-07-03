//
//  Demo02.swift
//  RxSwiftDemos
//
//  Created by ChildhoodAndy on 2019/7/3.
//  Copyright © 2019 ChildhoodAndy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//歌曲结构体
struct Music {
    let name: String //歌名
    let singer: String //演唱者
    
    init(name: String, singer: String) {
        self.name = name
        self.singer = singer
    }
}

//实现 CustomStringConvertible 协议，方便输出调试
extension Music: CustomStringConvertible {
    var description: String {
        return "name：\(name) singer：\(singer)"
    }
}

//歌曲列表数据源
struct MusicListViewModel {
    let data = [
        Music(name: "无条件", singer: "陈奕迅"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "从前的我", singer: "陈洁仪"),
        Music(name: "在木星", singer: "朴树"),
    ]
}

class Demo02 : BaseDemo {
    
    var tableView:UITableView!
    
    //歌曲列表数据源
    let musicListViewModel = MusicListViewModel()
    
    //负责对象销毁
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建表格视图
        self.tableView = UITableView(frame: self.view.frame, style:.plain)
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "musicCell")
        self.mainView.addSubview(self.tableView!)

        Observable.just(musicListViewModel.data)
            .bind(to: tableView.rx.items(cellIdentifier: "musicCell")) { _, music, cell in
                cell.textLabel?.text = music.name
                cell.detailTextLabel?.text = music.singer
            }.disposed(by: disposeBag)
        
        //tableView点击响应
        tableView.rx.modelSelected(Music.self).subscribe(onNext: { [weak self] music in
            self?.printMessage("你选中的歌曲信息【\(music)】")
        }).disposed(by: disposeBag)
    }
}
