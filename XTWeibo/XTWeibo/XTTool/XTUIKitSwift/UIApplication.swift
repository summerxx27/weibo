//
//  File.swift
//  XTWeibo
//
//  Created by summerxx on 2023/2/1.
//  Copyright © 2023 夏天然后. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    /// 获取 AppDelegate 的 window 对象
    @objc
    public class var window: UIWindow? {
        guard let delegate = shared.delegate else { return nil }
        guard let window = delegate.window else { return nil }
        return window
    }

    /// 获取当前的状态栏高度
    @objc
    public class var statusBarHeight: CGFloat {
        UIApplication.shared.statusBarFrame.height
    }

    private static var _statusBarHeightCached: CGFloat = 0

    /// 获取状态栏高度（带缓存）
    @objc
    public class var statusBarHeightCached: CGFloat {
        _statusBarHeightCached
    }
}

// 仅限 UIKitSwift 内部使用
extension UIApplication {

    @objc dynamic
    private class func _updateStatusBarHeightCached(_ height: NSNumber) {
        _statusBarHeightCached = CGFloat(height.doubleValue)
    }
}

extension UIApplication {
    /// 当前是否竖屏
    @objc
    public static var isPortrait: Bool {
        shared.statusBarOrientation.isPortrait
    }

    /// 当前是否横屏
    @objc
    public static var isLandscape: Bool {
        shared.statusBarOrientation.isLandscape
    }
}
