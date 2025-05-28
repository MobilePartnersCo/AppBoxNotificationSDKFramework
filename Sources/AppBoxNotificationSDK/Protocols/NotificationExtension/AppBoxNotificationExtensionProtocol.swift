//
//  AppBoxNotificationExtensionProtocol.swift
//  AppBoxNotificationSDK
//
//  Created by mobilePartners on 5/28/25.
//

import Foundation
import UserNotifications

/**
 # AppBoxNotificationExtensionProtocol

 `AppBoxNotificationExtensionSDK`에서 사용되는 프로토콜로, SDK 초기화 및 다양한 설정을 제공합니다.
 */
@objc public protocol AppBoxNotificationExtensionProtocol {
    
    /**
     # createFCMImage
     
     푸시알림에 이미지를 추가합니다.
     
     ## Parameters
     - `request`: UNNotificationRequest
     - `contentHandler`:  UNNotificationServiceExtension에 대한 콜백
     
     ## Author
     - ss.moon
     
     ## Example
     ```swift
     AppBoxNotification.shared.createFCMImage(request, contentHandler: contentHandler)
     ```
     */
    func createFCMImage(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void)
    
}
