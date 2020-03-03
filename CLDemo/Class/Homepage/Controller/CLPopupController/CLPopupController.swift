//
//  CLPopupController.swift
//  CLDemo
//
//  Created by JmoVxia on 2019/12/28.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit

class CLPopupController: CLBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton()
        view.addSubview(button)
        button.backgroundColor = UIColor.randomColor
        button.setTitle("点我翻牌", for: .normal)
        button.addTarget(self, action: #selector(showFlop), for: .touchUpInside)
        button.snp.makeConstraints { (make) in
            make.size.equalTo(120)
            make.centerX.equalToSuperview()
            make.top.equalTo(130)
        }
        
        let button1 = UIButton()
        view.addSubview(button1)
        button1.backgroundColor = UIColor.randomColor
        button1.setTitle("一个按钮", for: .normal)
        button1.addTarget(self, action: #selector(showOne), for: .touchUpInside)
        button1.snp.makeConstraints { (make) in
            make.size.equalTo(120)
            make.centerX.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(20)
        }
        
        let button2 = UIButton()
        view.addSubview(button2)
        button2.backgroundColor = UIColor.randomColor
        button2.setTitle("两个按钮", for: .normal)
        button2.addTarget(self, action: #selector(showTwo), for: .touchUpInside)
        button2.snp.makeConstraints { (make) in
            make.size.equalTo(120)
            make.centerX.equalToSuperview()
            make.top.equalTo(button1.snp.bottom).offset(20)
        }
        
        let button3 = UIButton()
        view.addSubview(button3)
        button3.backgroundColor = UIColor.randomColor
        button3.setTitle("成功", for: .normal)
        button3.addTarget(self, action: #selector(showSuccess), for: .touchUpInside)
        button3.snp.makeConstraints { (make) in
            make.size.equalTo(120)
            make.centerX.equalToSuperview()
            make.top.equalTo(button1.snp.bottom).offset(20)
        }
    }
}
extension CLPopupController {
    @objc func showFlop() {
        CLPopupManager.showFlop()
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
        //            CLPopupManager.showFlop(statusBarHidden: true)
        //        }
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
        //            CLPopupManager.showFlop(statusBarStyle: .default, statusBarHidden: false)
        //        }
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6) {
        //            CLPopupManager.showFlop(statusBarStyle: .default)
        //        }
    }
    @objc func showOne() {
        CLPopupManager.showOneAlert(statusBarStyle: .default, autorotate: true, title: "我是一个按钮", message: "我有一个按钮")
    }
    @objc func showTwo() {
        CLPopupManager.showTwoAlert(statusBarStyle: .default, autorotate: true, title: "我是两个按钮", message: "我有两个按钮")
    }
    @objc func showSuccess() {
        CLPopupManager.showTwoAlert(statusBarStyle: .default, autorotate: true, title: "我是两个按钮", message: "我有两个按钮")
    }
}
