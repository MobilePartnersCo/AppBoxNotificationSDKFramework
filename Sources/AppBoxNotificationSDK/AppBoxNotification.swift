//
//  AppBoxNotification.swift
//  AppBoxNotificationSDK
//
//  Created by mobilePartners on 3/25/25.
//

import Foundation

public class AppBoxNotification: NSObject {
    @objc public static let shared: AppBoxNotificationProtocol = AppBoxNotificationRepository.shared
}
