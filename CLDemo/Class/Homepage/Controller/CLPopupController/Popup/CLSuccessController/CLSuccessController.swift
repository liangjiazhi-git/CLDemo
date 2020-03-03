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
        shapeLayer.fillColor = UIColor.clear.cgColor;
        shapeLayer.strokeColor = UIColor.red.cgColor;
        return shapeLayer
    }()
    
}
extension CLSuccessController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        let size = CGSize(width: 110, height: 110)
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(size)
        }
        
        shapeLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        contentView.layer.addSublayer(shapeLayer)
        
        let STROKE_WIDTH: CGFloat = 3.0

        // 绘制外部透明的圆形
        let circlePath = UIBezierPath()
        circlePath.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2), radius: size.width / 2 - STROKE_WIDTH, startAngle: 0 * .pi / 180, endAngle: 360 * .pi / 180, clockwise: false)
        // 创建外部透明圆形的图层
        let alphaLineLayer = CAShapeLayer()
        alphaLineLayer.path = circlePath.cgPath // 设置透明圆形的绘图路径
        alphaLineLayer.strokeColor = UIColor(cgColor: UIColor.white.cgColor).withAlphaComponent(0.1).cgColor // 设置图层的透明圆形的颜色
        alphaLineLayer.lineWidth = STROKE_WIDTH // 设置圆形的线宽
        alphaLineLayer.fillColor = UIColor.clear.cgColor // 填充颜色透明

        shapeLayer.addSublayer(alphaLineLayer) // 把外部半透明圆形的图层加到当前图层上

        // 设置当前图层的绘制属性
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round // 圆角画笔
        shapeLayer.lineWidth = STROKE_WIDTH
        
        // 半圆+动画的绘制路径初始化
        let path = UIBezierPath()
        // 绘制大半圆
        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2), radius: size.width / 2 - STROKE_WIDTH, startAngle: 67 * .pi / 180, endAngle: -158 * .pi / 180, clockwise: false)
        // 绘制对号第一笔
        path.addLine(to: CGPoint(x: size.width * 0.42, y: size.width * 0.68))
        // 绘制对号第二笔
        path.addLine(to: CGPoint(x: size.width * 0.75, y: size.width * 0.35))
        // 把路径设置为当前图层的路径
        shapeLayer.path = path.cgPath
        
        let timing = CAMediaTimingFunction(controlPoints: 0.3, 0.6, 0.8, 1.1)
        // 创建路径顺序绘制的动画
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.5 // 动画使用时间
        animation.fromValue = NSNumber(value: Int32(0.0)) // 从头
        animation.toValue = NSNumber(value: Int32(1.0)) // 画到尾
        // 创建路径顺序从结尾开始消失的动画
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.duration = 0.4 // 动画使用时间
        strokeStartAnimation.beginTime = CACurrentMediaTime() + 0.2 // 延迟0.2秒执行动画
        strokeStartAnimation.fromValue = NSNumber(value: 0.0) // 从开始消失
        strokeStartAnimation.toValue = NSNumber(value: 0.74) // 一直消失到整个绘制路径的74%，这个数没有啥技巧，一点点调试看效果，希望看此代码的人不要被这个数值怎么来的困惑
        strokeStartAnimation.timingFunction = timing
        
        shapeLayer.strokeStart = 0.74 // 设置最终效果，防止动画结束之后效果改变
        shapeLayer.strokeEnd = 1.0

        shapeLayer.add(animation, forKey: "strokeEnd") // 添加俩动画
        shapeLayer.add(strokeStartAnimation, forKey: "strokeStart")
    }
}
