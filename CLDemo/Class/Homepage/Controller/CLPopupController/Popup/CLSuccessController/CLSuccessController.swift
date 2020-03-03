//
//  CLSuccessController.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/3/3.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLSuccessController: CLPopupManagerBaseController {
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = hexColor("0x000000", alpha: 0.8)
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        return contentView
    }()
    lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        return shapeLayer
    }()
    
}
extension CLSuccessController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.size.equalTo(110)
            make.center.equalToSuperview()
        }
        
        
        
    }
}
