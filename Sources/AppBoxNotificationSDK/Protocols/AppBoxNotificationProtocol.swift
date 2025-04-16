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
    /**
     # delegate
     
     AppBoxNotificationSDK에서 푸시 토큰 갱신 이벤트를 수신받기 위한 delegate입니다.
     푸시 토큰이 성공적으로 발급되고 저장된 후 `appBoxPushTokenDidUpdate(_:)` 메서드가 호출됩니다.

     ## Author
     - ss.moon
     
     ## Warning
     - `initSDK` 호출 전에 delegate를 설정해야 이벤트를 정상적으로 받을 수 있습니다.
     
     ## Example
     ```swift
     AppBoxNotification.shared.delegate = self
     
     extension ViewController: AppBoxNotificationDelegate {
         func appBoxPushTokenDidUpdate(_ token: String?) {
             if let token = token {
                 print("appBoxPushTokenDidUpdate :: \(token)")
             } else {
                 print("appBoxPushTokenDidUpdate :: nil")
             }
         }
     }
     ```
     */
    var delegate: AppBoxNotificationDelegate? { get set }
    
    /**
     # initSDK
     
     AppBoxNotificationSDK를 초기화합니다.
     `autoRegisterForAPNs`는 기본값이 `true`입니다.
     특별한 사유가 없다면 별도로 설정할 필요 없이 자동으로 APNS 등록 및 푸시 권한이 수행됩니다.
     기존 FCM 연동 앱 등에서 수동으로 등록을 제어하고 싶다면 `autoRegisterForAPNs: false`로 설정해 주세요.
     
     ## Parameters
     - `projectId`: projectID
     - `debugMode`: 디버그 모드 활성화 여부 (옵션)
        - default: false
     - `autoRegisterForAPNs`: APNS 등록 실행 여부 (옵션)
        - default: true
     - `completion`: 결과를 비동기적으로 전달받을 수 있는 콜백 클로저  (선택)
        - `granted`: 푸시 권한 요청 결과입니다. `autoRegisterForAPNs`가 `true`인 경우에만 전달됩니다.
            - true: 권한이 허용됨
            - false: 권한이 거부됨
            - nil: 권한 요청이 수행되지 않았거나 autoRegisterForAPNs가 false인 경우

     ## Author
     - ss.moon
     
     ## Warning
     - Firebase가 이미 구성된 경우 Firebase init 이후 SDK를 초기화 해야합니다.
     
     ## Example
     ```swift
     AppBoxNotification.shared.initSDK(projectId: "YOUR PROJECT ID", debugMode: true) { result, error, granted in
          if let error = error {
              print("초기화 실패: \(error.localizedDescription)")
          } else {
              print("초기화 성공: \(result.message)")
          }
     
          if let granted = granted {
             if let granted = granted {
                 if !granted.boolValue {
                     print("권한 미허용")
                 }
             }
          }
     }
     ```
     */
    func initSDK(projectId: String?, debugMode: Bool, autoRegisterForAPNs: Bool, completion: ((_ result: AppBoxNotiResultModel?, _ error: NSError?, _ pushPermissionGranted: NSNumber?) -> Void)?)
    func initSDK(projectId: String?, debugMode: Bool, completion: ((_ result: AppBoxNotiResultModel?, _ error: NSError?, _ pushPermissionGranted: NSNumber?) -> Void)?)
    func initSDK(projectId: String?, completion: ((_ result: AppBoxNotiResultModel?, _ error: NSError?, _ pushPermissionGranted: NSNumber?) -> Void)?)
    func initSDK(projectId: String?, debugMode: Bool)
    func initSDK(projectId: String?)
    
    
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
    func application(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    
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
    func savePushToken(token: String, pushYn: Bool)
   
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
    
    /**
     # requestPushAuthorization
     
     푸시 알림 권한을 요청합니다.
     시스템 알림 권한 상태를 확인한 뒤, 필요한 경우에만 권한 요청 UI를 표시합니다.
     이미 권한이 허용된 경우에는 별도의 요청 없이 바로 `true`를 반환하며,
     거부되었거나 요청할 수 없는 상태인 경우 `false`를 반환합니다.
     
     ## Parameters
     - `completion`:  푸시 권한 요청 결과를 비동기적으로 전달받는 콜백.
        - `true`: 권한 허용됨
        - `false`: 권한 거부됨 또는 알 수 없음
     
     ## Author
     - ss.moon
     
     ## Example
     ```swift
     AppBoxNotification.shared.requestPushAuthorization { granted in
         if granted {
             UIApplication.shared.registerForRemoteNotifications()
         } else {
             print("알림 권한이 거부되었습니다.")
         }
     }
     ```
     */
    func requestPushAuthorization(completion: @escaping (Bool) -> Void)
}
