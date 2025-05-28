//
//  AppBoxNotificationExtensionRepository.swift
//  AppBoxNotificationSDK
//
//  Created by mobilePartners on 5/28/25.
//

import UIKit
@_spi(AppBoxNotification_Internal) import AppBoxCore


class AppBoxNotificationExtensionRepository: NSObject, AppBoxNotificationExtensionProtocol {
    static let shared = AppBoxNotificationExtensionRepository()
    
    func createFCMImage(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        AppBoxCore.AppBoxCoreFramework.shared.coreSetFCMImage(request, contentHandler: contentHandler)
    }
}
