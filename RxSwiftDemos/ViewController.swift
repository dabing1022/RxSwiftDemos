//
//  ViewController.swift
//  RxSwiftDemos
//
//  Created by ChildhoodAndy on 2019/7/2.
//  Copyright © 2019 ChildhoodAndy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UITableViewController {
    
    let CellIdentifier = "CellIdentifier"
    let dataSource = [
        ("使用详解1（基本介绍、安装配置）", "http://www.hangge.com/blog/cache/detail_1917.html", "Demo01"),
        ("使用详解2（响应式编程与传统式编程的比较样例）", "http://www.hangge.com/blog/cache/detail_1918.html", "Demo02"),
        ("使用详解3（Observable介绍、创建可观察序列）", "http://www.hangge.com/blog/cache/detail_1922.html", "Demo03"),
        ("使用详解4（Observable订阅、事件监听、订阅销毁）", "http://www.hangge.com/blog/cache/detail_1924.html", "Demo04"),
        ("使用详解5（观察者1： AnyObserver、Binder）", "http://www.hangge.com/blog/cache/detail_1941.html", "Demo05"),
        ("使用详解6（观察者2： 自定义可绑定属性）", "http://www.hangge.com/blog/cache/detail_1946.html", "Demo06"),
        ("使用详解13（连接操作符：connect、publish、replay、multicast）", "http://www.hangge.com/blog/cache/detail_1935.html", "Demo13"),
        ("使用详解14（其他操作符：delay、materialize、timeout等）", "http://www.hangge.com/blog/cache/detail_1950.html", "Demo14"),
        ("使用详解15（错误处理）", "http://www.hangge.com/blog/cache/detail_1936.html", "Demo15"),
        ("使用详解16（调试操作）", "http://www.hangge.com/blog/cache/detail_1937.html", "Demo16"),
        ("使用详解18（特征序列2：Driver）", "http://www.hangge.com/blog/cache/detail_1942.html", "Demo18"),
        ("使用详解30（UITableView的使用1：基本用法）", "http://www.hangge.com/blog/cache/detail_1976.html", "Demo30"),
        ("使用详解31（UITableView的使用2：RxDataSources）", "http://www.hangge.com/blog/cache/detail_1982.html", "Demo31")
    ]
    let disposeBag = DisposeBag()
    
    typealias DataModel = (String, String, String)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        
        let items = Observable.just(dataSource)
        items.bind(to: tableView.rx.items(cellIdentifier: CellIdentifier)) { (row, element, cell) in
            cell.textLabel?.text = element.0
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
            cell.detailTextLabel?.text = element.1
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12, weight: .light)
        }
        .disposed(by: disposeBag)
        
        
        // MARK: itemSelected
        tableView.rx.itemSelected.subscribe { [weak self] (eventIndexPath: Event<IndexPath>) in
            if let indexPath = eventIndexPath.element {
                self?.jump(to: self?.dataSource[indexPath.row].2 ?? "Demo30")
            }
        }
        .disposed(by: disposeBag)
        
        
        // MARK: modelSelected
//        tableView.rx.modelSelected(DataModel.self).subscribe(onNext: { [weak self] (model) in
//            self?.jump(to: model.2)
//        }).disposed(by: disposeBag)
    }
    
    
    private func jump(to demoVcClassName: String) {
        let moduleName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        let classFullName = "\(moduleName).\(demoVcClassName)"
        if let DemoClass = NSClassFromString(classFullName) as? UIViewController.Type {
            let demoVc = DemoClass.init()
            demoVc.navigationItem.title = demoVcClassName
            self.navigationController?.pushViewController(demoVc, animated: true)
        }
    }


}

