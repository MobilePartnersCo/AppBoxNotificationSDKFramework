//
//  AppBoxNotificationDelegate.swift
//  AppBoxNotificationSDK
//
//  Created by mobilePartners on 4/15/25.
//

import Foundation

/// AppBoxNotificationDelegateClass
@objc public protocol AppBoxNotificationDelegate: AnyObject {
    /// 푸시토큰 전달하는 메서드
    @objc optional func appBoxPushTokenDidUpdate(_ token: String?)
}
