//
//  AppBoxNotificationDelegate.swift
//  AppBoxNotificationSDK
//
//  Created by mobilePartners on 4/15/25.
//

import Foundation

@objc public protocol AppBoxNotificationDelegate: AnyObject {
    @objc optional func appBoxPushTokenDidUpdate(_ token: String?)
}
