//
//  swift
//  FUSHENG
//
//  Created by JmoVxia on 2019/12/24.
//  Copyright © 2019 FuSheng. All rights reserved.
//

import UIKit
//MARK: - 弹窗父类控制器
class CLPopupManagerBaseController: UIViewController {
    ///状态栏颜色
    var statusBarStyle: UIStatusBarStyle = UIApplication.shared.statusBarStyle
    ///是否自动旋转
    var autorotate: Bool = false
    ///支持方向
    var interfaceOrientationMask: UIInterfaceOrientationMask = .portrait
    ///是否隐藏状态栏
    var statusBarHidden: Bool = false
}
extension CLPopupManagerBaseController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    override var shouldAutorotate: Bool {
        return autorotate
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return interfaceOrientationMask
    }
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
}
//MARK: - 弹窗根控制器
class CLPopupManagerRootController: CLPopupManagerBaseController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return children.last?.preferredStatusBarStyle ?? .lightContent
    }
    override var shouldAutorotate: Bool {
        return children.last?.shouldAutorotate ?? true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return children.last?.supportedInterfaceOrientations ?? .all
    }
    override var prefersStatusBarHidden: Bool {
        return children.last?.prefersStatusBarHidden ?? false
    }
}
//MARK: - 弹窗Window
class CLPopupManagerWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == rootViewController?.view {
            return nil
        }
        return view
    }
}
//MARK: - 弹窗管理者
class CLPopupManager: NSObject {
    private static var manager: CLPopupManager?
    private class var share: CLPopupManager {
        get {
            guard let shareManager = manager else {
                manager = CLPopupManager()
                return manager!
            }
            return shareManager
        }
    }
    private var popupManagerWindow: CLPopupManagerWindow?
    private class var window: CLPopupManagerWindow {
        get {
            guard let window = share.popupManagerWindow else {
                share.popupManagerWindow = CLPopupManagerWindow(frame: UIScreen.main.bounds)
                share.popupManagerWindow!.windowLevel = UIWindow.Level.statusBar
                share.popupManagerWindow!.isUserInteractionEnabled = true
                share.popupManagerWindow?.rootViewController = CLPopupManagerRootController()
                return share.popupManagerWindow!
            }
            return window
        }
    }
    private override init() {
        super.init()
    }
    deinit {
        print("============== PopupViewManager deinit ==================")
    }
}
extension CLPopupManager {
    /// 显示弹窗
    /// - Parameters:
    ///   - controller: 弹窗控制器
    ///   - only: 是否唯一弹窗,唯一弹窗会自动销毁之前显示的弹窗
    private class func makeKeyAndVisible(with controller: UIViewController, only: Bool) {
        let rootViewController = window.rootViewController
        if let children = rootViewController?.children, only {
            for childrenController in children {
                childrenController.willMove(toParent: nil)
                childrenController.view.removeFromSuperview()
                childrenController.removeFromParent()
            }
        }
        controller.modalPresentationStyle = .custom
        rootViewController?.addChild(controller)
        rootViewController?.view.addSubview(controller.view)
        controller.didMove(toParent: rootViewController)
        window.makeKeyAndVisible()
        refresh()
    }
    /// 销毁弹窗
    /// - Parameter all: 是否销毁所有弹窗
    private class func destroyAll(_ all: Bool = true) {
        guard let childrenController = window.rootViewController?.children else {
            return
        }
        let controller = childrenController.last
        controller?.willMove(toParent: nil)
        controller?.view.removeFromSuperview()
        controller?.removeFromParent()
        refresh()
        if childrenController.count == 1 || all {
            window.resignKey()
            window.isHidden = true
            share.popupManagerWindow = nil
            manager = nil
        }
    }
    /// 刷新状态栏
    private class func refresh() {
        window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
    }
}
extension CLPopupManager {
    /// 显示自定义弹窗
    /// - Parameters:
    ///   - controller: 自定义弹窗控制器
    ///   - only: 唯一弹窗
    class func showCustom(with controller: UIViewController, only: Bool = false) {
        DispatchQueue.main.async {
            makeKeyAndVisible(with: controller, only: only)
        }
    }
    /// 隐藏弹窗
    /// - Parameter all: 全部弹窗
    class func dismissAll(_ all: Bool = true) {
        DispatchQueue.main.async {
            destroyAll(all)
        }
    }
    /// 显示翻牌弹窗
    /// - Parameters:
    ///   - statusBarStyle: 状态栏类型
    ///   - statusBarHidden: 是否隐藏状态栏
    ///   - autorotate: 是否支持页面旋转
    ///   - interfaceOrientationMask: 页面旋转支持方向
    ///   - only: 是否唯一弹窗(自动顶掉前面所有弹窗)
    class func showFlop(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, only: Bool = false) {
        let controller = CLFlopController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        showCustom(with: controller, only: only)
    }
    ///显示提示弹窗
    class func showTips(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, only: Bool = true, dismissInterval: TimeInterval = 0.5, text: String) {
        let controller = CLTipsPopupController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.text = text
        controller.dismissInterval = dismissInterval
        showCustom(with: controller, only: only)
    }
    ///显示一个消息弹窗
    class func showOneAlert(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, only: Bool = true, title: String? = nil, message: String? = nil, sure: String = "确定", sureCallBack: (() -> ())? = nil) {
        let controller = CLMessagePopupController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.type = .one
        controller.titleLabel.text = title
        controller.messageLabel.text = message
        controller.sureButton.setTitle(sure, for: .normal)
        controller.sureButton.setTitle(sure, for: .selected)
        controller.sureButton.setTitle(sure, for: .highlighted)
        controller.sureCallBack = sureCallBack
        showCustom(with: controller, only: only)
    }
    ///显示两个消息弹窗
    class func showTwoAlert(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, only: Bool = true, title: String? = nil, message: String? = nil, left: String = "取消", right: String = "确定", leftCallBack: (() -> ())? = nil, rightCallBack: (() -> ())? = nil) {
        let controller = CLMessagePopupController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.type = .two
        controller.titleLabel.text = title
        controller.messageLabel.text = message
        controller.leftButton.setTitle(left, for: .normal)
        controller.leftButton.setTitle(left, for: .selected)
        controller.leftButton.setTitle(left, for: .highlighted)
        controller.rightButton.setTitle(right, for: .normal)
        controller.rightButton.setTitle(right, for: .selected)
        controller.rightButton.setTitle(right, for: .highlighted)
        controller.leftCallBack = leftCallBack
        controller.rightCallBack = rightCallBack
        showCustom(with: controller, only: only)
    }
    ///显示成功
    class func showSuccess(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, only: Bool = true) {
        let controller = CLSuccessController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        showCustom(with: controller, only: only)
    }
}
