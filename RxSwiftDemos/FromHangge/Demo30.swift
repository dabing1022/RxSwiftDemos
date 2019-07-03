//
//  Demo30.swift
//  RxSwiftDemos
//
//  Created by ChildhoodAndy on 2019/7/2.
//  Copyright © 2019 ChildhoodAndy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class Demo30 : BaseDemo {
    
    var tableView:UITableView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建表格视图
        self.tableView = UITableView(frame: self.view.frame, style:.plain)
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.mainView.addSubview(self.tableView!)
        
        //初始化数据
        let items = Observable.just([
            "文本输入框的用法",
            "开关按钮的用法",
            "进度条的用法",
            "文本标签的用法",
        ])
        
        //设置单元格数据（其实就是对 cellForRowAt 的封装）
        items
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(row)：\(element)"
                return cell
            }
            .disposed(by: disposeBag)
        
        self.tableView!.isEditing = true
        
        self.tableView!.rx.setDelegate(self).disposed(by: disposeBag)
        
        // MARK: 单元格选中事件响应
        _configSelectEvent()
        
        // MARK: 单元格取消选中事件响应
        _configCancelSelectedEvent()
        
        // MARK: 单元格删除事件响应
        _configDeleteEvent()
        
        // MARK: 单元格移动事件响应
        _configMoveEvent()
        
        // MARK: 单元格插入事件响应
        _configInsertEvent()

    }
    
    private func _configSelectEvent() {
        //获取选中项的索引
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            print("选中项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //获取选中项的内容
        //        tableView.rx.modelSelected(String.self).subscribe(onNext: { item in
        //            print("选中项的标题为：\(item)")
        //        }).disposed(by: disposeBag)
        
        // 同时获取选中项的索引及内容
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .bind { [weak self] indexPath, item in
                self?.showMessage("选中项的indexPath为：\(indexPath)")
                self?.showMessage("选中项的标题为：\(item)")
            }
            .disposed(by: disposeBag)
    }
    
    private func _configCancelSelectedEvent() {
        //获取被取消选中项的索引
        tableView.rx.itemDeselected.subscribe(onNext: { [weak self] indexPath in
            self?.showMessage("被取消选中项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //获取被取消选中项的内容
        tableView.rx.modelDeselected(String.self).subscribe(onNext: {[weak self] item in
            self?.showMessage("被取消选中项的的标题为：\(item)")
        }).disposed(by: disposeBag)
        
        
        Observable.zip(tableView.rx.itemDeselected, tableView.rx.modelDeselected(String.self))
            .bind { [weak self] indexPath, item in
                self?.showMessage("被取消选中项的indexPath为：\(indexPath)")
                self?.showMessage("被取消选中项的的标题为：\(item)")
            }
            .disposed(by: disposeBag)
    }
    
    private func _configDeleteEvent() {
        //获取删除项的索引
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            self?.showMessage("删除项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //获取删除项的内容
        tableView.rx.modelDeleted(String.self).subscribe(onNext: {[weak self] item in
            self?.showMessage("删除项的的标题为：\(item)")
        }).disposed(by: disposeBag)
    }
    
    private func _configMoveEvent() {
        //获取移动项的索引
        tableView.rx.itemMoved.subscribe(onNext: { [weak self]
            sourceIndexPath, destinationIndexPath in
            self?.showMessage("移动项原来的indexPath为：\(sourceIndexPath)")
            self?.showMessage("移动项现在的indexPath为：\(destinationIndexPath)")
        }).disposed(by: disposeBag)
    }
    
    private func _configInsertEvent() {
        //获取插入项的索引
        tableView.rx.itemInserted.subscribe(onNext: { [weak self] indexPath in
            self?.showMessage("插入项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
    }
}

extension Demo30 : UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .insert
        return .delete
    }
}
