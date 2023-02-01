//
//  UIScreen.swift
//  XTWeibo
//
//  Created by summerxx on 2023/2/1.
//  Copyright © 2023 夏天然后. All rights reserved.
//

import Foundation
import UIKit

public extension UIScreen {

    /// 屏幕宽度
    @objc
    static let width = UIScreen.main.bounds.size.width

    /// 屏幕高度
    @objc
    static let height = UIScreen.main.bounds.size.height

    /// scale
    @objc
    static let scale = UIScreen.main.scale

    /// 是否是异形屏
    @objc
    static let isSpecial = (height - DJ_HEIGHT_OF_IPHONE_X) >= -1e-5

    /// 导航栏高度
    @objc
    static var navibarHeight: CGFloat {
        if #available(iOS 14.0, *) {
            return UIApplication.statusBarHeight + 44.0
        }
        return height >= DJ_HEIGHT_OF_IPHONE_X ? 88.0 : 64.0
    }

    /// 底部 tab 高度
    @objc
    static var tabbarHeight: CGFloat {
        height >= DJ_HEIGHT_OF_IPHONE_X ? 83.0 : 49.0
    }

    internal static let DJ_HEIGHT_OF_IPHONE_X: CGFloat = 812.0
    internal static let DJ_HEIGHT_OF_IPHONE_XR: CGFloat = 896.0
    internal static let DJ_HEIGHT_OF_IPHONE_12: CGFloat = 844.0
    internal static let DJ_HEIGHT_OF_IPHONE_12Mini: CGFloat = 812.0
    internal static let DJ_HEIGHT_OF_IPHONE_12ProMax: CGFloat = 926.0
}
