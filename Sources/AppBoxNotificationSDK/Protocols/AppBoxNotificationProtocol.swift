//
//  AppBoxNotificationProtocol.swift
//  AppBoxNotificationSDK
//
//  Created by mobilePartners on 3/25/25.
//
import Foundation
import UserNotifications

@objc public protocol AppBoxNotificationProtocol {
    func initSDK(projectId: String?)
    func initSDK(projectId: String?, completion: ((_ result: AppBoxNotiResultModel?, _ error: NSError?) -> Void)?)
    func application(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    func application(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data, completion: ((_ result: AppBoxNotiResultModel?, _ error: NSError?) -> Void)?)
    func savePushToken(token: String, pushYn: Bool)
    func savePushToken(token: String, pushYn: Bool, completion: ((_ result: AppBoxNotiResultModel?, _ error: NSError?) -> Void)?)
    func receiveNotiModel(_ receive: UNNotificationResponse) -> AppBoxNotiModel?
    func setDebug(debugMode: Bool)
}
