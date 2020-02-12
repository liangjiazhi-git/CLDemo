//
//  CLChatPhotoAlbumCell.swift
//  CLDemo
//
//  Created by Emma on 2020/2/11.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

enum CLChatPhotoMoveDirection {
    case none
    case up
    case down
    case right
    case left
}
class CLChatPhotoAlbumCell: UICollectionViewCell {
    var lockScollViewCallBack: ((Bool) -> ())?
    private var direction: CLChatPhotoMoveDirection = .none
    private var isOnWindow: Bool = false
    private var gestureMinimumTranslation: CGFloat = 20.0
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
        addPanGestureRecognizer()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLChatPhotoAlbumCell {
    private func initUI() {
        contentView.addSubview(imageView)
    }
    private func makeConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    private func addPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handGesture(recognizer:)))
        panGestureRecognizer.delegate = self
        imageView.addGestureRecognizer(panGestureRecognizer)
    }
}
extension CLChatPhotoAlbumCell: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    if (gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) ) {
           return true
       }
       return false
    }
}
extension CLChatPhotoAlbumCell {
    @objc func handGesture(recognizer: UIPanGestureRecognizer) {
        let lastWindow = UIApplication.shared.windows.last
        let translation = recognizer.translation(in: contentView)
        if recognizer.state == .began {
            direction = .none
        } else if recognizer.state == .changed && direction == .none {
            direction = determinePictureDirectionIfNeeded(translation)
        }
        if direction == .up || direction == .down {
            verticalAction(with: recognizer)
            lockScollViewCallBack?(!isOnWindow)
        }
        if recognizer.state == .ended {
            if direction == .up || direction == .down {
                let endPoint = contentView.convert(recognizer.view?.center ?? .zero, from: lastWindow)
                if endPoint.y < 0 && isOnWindow {
//                    sendImageRecognizer(recognizer)
                } else {
//                    backImageRecognizer(recognizer)
                }
            }
            isOnWindow = false
            lockScollViewCallBack?(!isOnWindow)
        }
    }
}
extension CLChatPhotoAlbumCell {
    func determinePictureDirectionIfNeeded(_ translation: CGPoint) -> CLChatPhotoMoveDirection {
        if direction != .none {
            return direction
        }
        if abs(CGFloat(translation.x)) > gestureMinimumTranslation {
            var gestureHorizontal = false
            if translation.y == 0.0 {
                gestureHorizontal = true
            } else {
                gestureHorizontal = abs(Float(translation.x / translation.y)) > 5.0
            }
            if gestureHorizontal {
                if translation.x > 0.0 {
                    return .right
                } else {
                    return .left
                }
            }
        } else if abs(CGFloat(translation.y)) > gestureMinimumTranslation {
            var gestureVertical = false
            if translation.x == 0.0 {
                gestureVertical = true
            } else {
                gestureVertical = abs(Float(translation.y / translation.x)) > 5.0
            }
            if gestureVertical {
                if translation.y > 0.0 {
                    return .down
                } else {
                    return .up
                }
            }
        }
        return direction
    }
    func verticalAction(with recognizer: UIPanGestureRecognizer) {
        var cellCenterPoint = CGPoint.zero
        var worldCenterPoint = CGPoint.zero
        let translation = recognizer.translation(in: contentView)
        let lastWindow = UIApplication.shared.keyWindow //[[UIApplication sharedApplication].windows lastObject];
        cellCenterPoint = CGPoint(x: recognizer.view?.center.x ?? 0.0, y: (translation.y) + (recognizer.view?.center.y ?? 0.0))
        if isOnWindow {
            cellCenterPoint = contentView.convert(cellCenterPoint, from: lastWindow)
        }
        if let view = recognizer.view {
            lastWindow?.addSubview(view)
        }
        //判断距离
        let endPoint = contentView.convert(recognizer.view?.center ?? CGPoint.zero, from: lastWindow)
//        self.endPoint = endPoint
        if endPoint.y < 0 && isOnWindow {
            //发送出去
//            tipsLabel.hidden = false
        } else {
            //返回cell上
//            tipsLabel.hidden = true
        }
        //转换为世界坐标
        worldCenterPoint = contentView.convert(cellCenterPoint, to: lastWindow)
        recognizer.view?.center = worldCenterPoint
        isOnWindow = true
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: contentView)
    }
}
