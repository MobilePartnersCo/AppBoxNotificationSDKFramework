//
//  AppBoxNotification.swift
//  AppBoxNotificationSDK
//
//  Created by mobilePartners on 3/25/25.
//

import Foundation

/// AppBoxNotificationClass
public class AppBoxNotification: NSObject {
    /// AppBoxNotificationProtocol 접근 생성자
    @objc public static let shared: AppBoxNotificationProtocol = AppBoxNotificationRepository.shared
    
    /// AppBoxNotificationExtensionProtocol 접근 생성자
    @objc public static let sharedExtension: AppBoxNotificationExtensionProtocol = AppBoxNotificationExtensionRepository.shared
}

