//
//  AppBoxNotificationProtocol.swift
//  AppBoxNotificationSDK
//
//  Created by mobilePartners on 3/25/25.
//
import Foundation
import UserNotifications

/**
 # AppBoxNotificationProtocol

 `AppBoxNotificationSDK`에서 사용되는 프로토콜로, SDK 초기화 및 다양한 설정을 제공합니다.
 */
@objc public protocol AppBoxNotificationProtocol {
    var delegate: AppBoxNotificationDelegate? { get set }
    
    /**
     # initSDK
     
     AppBoxNotificationSDK를 초기화합니다. 초기화 시 projectId를 설정합니다.
     
     ## Parameters
     - `projectId`: projectID

     ## Author
     - ss.moon
    
     ## Warning
     - Firebase가 이미 구성된 경우 Firebase init 이후 SDK를 초기화 해야합니다.
     
     ## Example
     ```swift
     AppBoxNotification.shared.initSDK(projectId: "projectId")
     ```
     */
    func initSDK(projectId: String?)
    /**
     # initSDK
     
     AppBoxNotificationSDK를 초기화합니다. 초기화 시 projectId를 설정합니다.
     
     ## Parameters
     - `projectId`: projectID
     - `debugMode`: 디버그 모드 활성화 여부 (옵션)
        - default: false

     ## Author
     - ss.moon
    
     ## Warning
     - Firebase가 이미 구성된 경우 Firebase init 이후 SDK를 초기화 해야합니다.
     
     ## Example
     ```swift
     AppBoxNotification.shared.initSDK(projectId: "projectId", debugMode: true)
     ```
     */
    func initSDK(projectId: String?, debugMode: Bool)
    /**
     # initSDK
     
     AppBoxNotificationSDK를 초기화합니다. 초기화 시 projectId와 completion을 설정합니다.
     
     ## Parameters
     - `projectId`: projectID
     - `completion`: 결과를 비동기적으로 전달받을 수 있는 콜백 클로저  (선택)

     ## Author
     - ss.moon
     
     ## Warning
     - Firebase가 이미 구성된 경우 Firebase init 이후 SDK를 초기화 해야합니다.
     
     ## Example
     ```swift
     AppBoxNotification.shared.initSDK(projectId: "AYX-371110") { result, error in
          if let error = error {
              print("초기화 실패: \(error.localizedDescription)")
          } else {
              print("초기화 성공: \(result.message)")
          }
     }
     ```
     */
    func initSDK(projectId: String?, completion: ((_ result: AppBoxNotiResultModel?, _ error: NSError?) -> Void)?)
    /**
     # initSDK
     
     AppBoxNotificationSDK를 초기화합니다. 초기화 시 projectId와 completion을 설정합니다.
     
     ## Parameters
     - `projectId`: projectID
     - `debugMode`: 디버그 모드 활성화 여부 (옵션)
        - default: false
     - `completion`: 결과를 비동기적으로 전달받을 수 있는 콜백 클로저  (선택)

     ## Author
     - ss.moon
     
     ## Warning
     - Firebase가 이미 구성된 경우 Firebase init 이후 SDK를 초기화 해야합니다.
     
     ## Example
     ```swift
     AppBoxNotification.shared.initSDK(projectId: "AYX-371110", debugMode: true) { result, error in
          if let error = error {
              print("초기화 실패: \(error.localizedDescription)")
          } else {
              print("초기화 성공: \(result.message)")
          }
     }
     ```
     */
    func initSDK(projectId: String?, debugMode: Bool, completion: ((_ result: AppBoxNotiResultModel?, _ error: NSError?) -> Void)?)
    /**
     # application
     
     Apns 등록 시점에 FCM 토큰을 저장합니다.
     
     ## Parameters
     - `didRegisterForRemoteNotificationsWithDeviceToken`:  Apns deviceToken

     ## Author
     - ss.moon
    
     ## Warning
     - Apns 등록 시점에 맞춰서 해당 함수를 등록해야 FCM 토큰이 정상적으로 저장됩니다.
     
     ## Example
     ```swift
     AppBoxNotification.shared.application(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
     ```
     */
    func application(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    /**
     # application
     
     Apns 등록 시점에 FCM 토큰을 저장합니다.
     
     ## Parameters
     - `didRegisterForRemoteNotificationsWithDeviceToken`:  Apns deviceToken
     - `completion`: 결과를 비동기적으로 전달받을 수 있는 콜백 클로저  (선택)

     ## Author
     - ss.moon
     
     ## Warning
     - Apns 등록 시점에 맞춰서 해당 함수를 등록해야 FCM 토큰이 정상적으로 저장됩니다.
     
     ## Example
     ```swift
     AppBoxNotification.shared.application(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) { result, error in
          if let error = error {
              print("토큰 저장 실패: \(error.localizedDescription)")
          } else {
              print("토큰 저장 성공: \(result.message)")
              print("토큰 저장 토큰: \(result.token)")
          }
     }
     ```
     */
    func application(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data, completion: ((_ result: AppBoxNotiResultModel?, _ error: NSError?) -> Void)?)
    /**
     # savePushToken
     
     푸시 알림에 대한 사용 여부와 토큰을 저장합니다.
     
     ## Parameters
     - `token`:  FCM Token
     - `pushYn`:  푸시알림 사용 여부
        - value: true:  사용, false: 미사용

     ## Author
     - ss.moon
     
     ## Example
     ```swift
     AppBoxNotification.shared.savePushToken(token: "FCM Token", pushYn: true)
     ```
     */
    func savePushToken(token: String, pushYn: Bool)
    /**
     # savePushToken
     
     푸시 알림에 대한 사용 여부와 토큰을 저장합니다.
     
     ## Parameters
     - `token`:  FCM Token
     - `pushYn`:  푸시알림 사용 여부
        - value: true:  사용, false: 미사용
     - `completion`: 결과를 비동기적으로 전달받을 수 있는 콜백 클로저  (선택)

     ## Author
     - ss.moon
     
     ## Example
     ```swift
     AppBoxNotification.shared.savePushToken(token: "FCM Token", pushYn: true) { result, error in
          if let error = error {
              print("토큰 저장 실패: \(error.localizedDescription)")
          } else {
              print("토큰 저장 성공: \(result.message)")
              print("토큰 저장 토큰: \(result.token)")
          }
     }
     ```
     */
    func savePushToken(token: String, pushYn: Bool, completion: ((_ result: AppBoxNotiResultModel?, _ error: NSError?) -> Void)?)
    /**
     # getPushToken
     
     저장된 FCM Token을 제공합니다.

     ## Author
     - ss.moon
     
     ## Returns
     - `String?`: 등록된 푸시 토큰.
        토큰이 발급되지 않은 경우 `nil`을 반환합니다.
     
     ## Example
     ```swift
     AppBoxNotification.shared.getPushToken()
     ```
     */
    func getPushToken() -> String?
    /**
     # receiveNotiModel
     
     푸시 알림 노티를 눌렀을 때 전달되는 메시지 Param값을 제공합니다.
     
     ## Parameters
     - `receive`:  UNNotificationResponse
     
     ## Returns
     - `AppBoxNotiModel?`: 전달받은 메시지 Param
        포맷이 안맞거나, 초기화가 되지않으면 `nil`을 반환합니다.

     ## Author
     - ss.moon
     
     ## Example
     ```swift
     if let notiReceive = AppBoxNotification.shared.receiveNotiModel(response) {
         print("push received :: \(notiReceive.params)")
     }
     ```
     */
    func receiveNotiModel(_ receive: UNNotificationResponse) -> AppBoxNotiModel?
}
