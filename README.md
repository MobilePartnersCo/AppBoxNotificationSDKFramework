![AppBoxNotification_JPG](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/AppboxVisual.jpg)

# AppBoxNotification SDK 사용 샘플소스
[![Swift Package Manager](https://img.shields.io/badge/SPM-Compatible-green.svg)](https://swift.org/package-manager/)
[![Version](https://img.shields.io/github/v/tag/MobilePartnersCo/AppBoxNotificationSDKFramework?label=version)](https://github.com/MobilePartnersCo/AppBoxNotificationSampleiOS)

- AppBoxNotification SDK는 푸시를 간편하게 연동하는 솔루션입니다.
- AppBoxNotification SDK는 앱박스 홈페이지의 [푸시 전용 콘솔](https://appboxapp.com/console/launchpad)을 활용하여 푸시알림 서비스를 사용할 수 있습니다.
- 푸시 전용 콘솔을 이용하여 테스트 발송, 예약 발송 등 다양한 푸시 기능을 사용하실 수 있습니다.
  
---

## 라이선스

- 앱박스 푸시알림 SDK는 기업 및 개인이 상업적 목적으로 사용할 수 있습니다.<br>
본 SDK의 사용 및 일부 기능은 앱박스 푸시 콘솔을 통한 구독 등급에 따라 제한되거나 유료로 제공될 수 있습니다.<br>
자세한 라이선스 및 이용 조건은 [공식문서](https://appboxapp.com/policy/terms/push)를 확인해 주세요.

---

## 전체 기능

**푸시 콘솔 페이지를 활용하여 사용할 수 있는 기능**
1. 테스트 및 예약 발송 기능
2. 진동이나 사운드없이 조용한 발송 기능
3. 파라미터 및 URL 이동 기능
4. 푸시 데이터 발송 통계 제공(OS별 성공/실패/오픈률 집계)
5. 푸시 수신 방문율 제공(푸시 오픈 시간 추이 및 발송 시간대별 푸시 오픈률 제공)
6. 전환 추적 기능 - 푸시를 통한 사용자 행동 전환 측정 (v1.0.3+)
   
---

## 설치 방법

AppBoxNotificationSDK는 [Swift Package Manager](https://swift.org/package-manager/)를 통해 배포됩니다. SPM 설치를 위해 다음 단계를 따라주세요:
<br>AppBoxPushSDK는 [Firebase 11.12.0] 종속성으로 사용하고 있습니다.

1. Xcode에서 ①[Project Target] > ②[Package Dependencies] > ③[Packages +]를 눌러 패키지 추가 화면을 엽니다.
![SPM_Step1_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/spm1.png)

3. 다음 SPM URL 복사합니다:
   ```console
   https://github.com/MobilePartnersCo/AppBoxNotificationSDKFramework
   ```

4. ④[검색창] SPM URL 검색 > ⑤[Dependency Rule] `Up to Next Major Version 최신 버전` 입력 > ⑥[Add Package]를 눌러 패키지 추가합니다.
![SPM_Step3_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/spm2.png)

5. 필요한 모듈을 선택하여 넣습니다.
![SPM_Step4_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/spm3.png)

6. 설정 완료 
![SPM_Step4_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/spm4.png)
![SPM_Step5_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/spm5.png)


### Info.plist 설정

SDK를 사용하려면 `Info.plist` 파일에 아래와 같은 항목을 추가하세요:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### Signing & Capabilities 설정

푸시를 사용하려면 `Signing & Capabilities`에 Push Notifications을 추가해야합니다. 다음 단계를 따라주세요:

1. Xcode에서 ①[Targets Target] > ②[Signing & Capabilities] > ③[+ Capability]를 눌러 Capability 추가 화면을 엽니다.
![Signing_Step1_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/signing1.png)

2. Xcode에서 ④[검색창]에 `Push Notifications` 입력  > ⑤더블클릭하여 적용합니다.
![Signing_Step2_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/push1.png)

3. 설정 완료
![Signing_Step3_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/push2.png)


## Service Extension 설정

푸시에 이미지를 사용하려면 다음 단계를 따라주세요:

1. Xcode에서 [Targets Target] > [Signing & Capabilities] > ①+ 클릭하여 Extension 추가 화면을 엽니다.
![Extension_Step1_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/noti1.png)

2. 검색창에 `noti` 입력 > ②[Notification Service Extension]선택 > ③[Next]버튼 클릭 합니다. 
![Extension_Step2_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/noti2.png)

3. ④`product Name` 생성할 Extension에 이름을 입력합니다. > ⑤[Finish]버튼 클릭 합니다. 
![Extension_Step3_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/noti3.png)

4. ⑥[Don`t Activate] 버튼을 클릭합니다. 
![Extension_Step4_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/noti4.png)

5. 신규 추가한 Targets에 추가되며,  ⑦`Minimum Deployments` 버전을 현재 사용 중인 메인 앱 Target의 버전과 동일하게 설정합니다.
![Extension_Step5_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/noti5.png)

6. 메인 앱 Target을 선택 > [Signing & Capabilities] > ⑧[+ Capability]를 눌러 Capability 추가 화면을 엽니다.
![Extension_Step6_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/noti6.png)

7. ⑨[검색창]에 `group` 입력  > `App Groups` 더블클릭하여 적용합니다.
![Extension_Step7_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/noti7.png)

8. App Groups 추가 > ⑩+ 클릭하여 App Group을 추가합니다.
![Extension_Step8_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/noti8.png)

9. `group.{번들ID}.{생성할 이름}` 입력하여 생성합니다.
![Extension_Step9_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/noti9.png)

10. App Groups에 생성한 group명이 보이며, ⑪체크가 되어있는지 확인합니다.
![Extension_Step10_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/noti10.png)

11. 동일한 방법으로 Extension Target으로 변경 후 App Groups를 추가하여 ⑫생성한 group명을 체크하여 활성화 시킵니다.
![Extension_Step11_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/noti11.png)

12. [General] > [Frameworks and Libraries] > ⑬+ 클릭합니다.
![Extension_Step12_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/noti12.png)

13. ⑭`AppBoxNotificationSDK`를 추가합니다.
![Extension_Step13_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/noti13.png)

14. ⑮`AppBoxNotificationSDK`이 추가된 것을 확인합니다.
![Extension_Step14_Image](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxNotificationSDKFramework/main/Resource/Image/noti14.png)

15. `NotificationService`파일을 열어 다음과 같이 적용합니다.

#### 적용 코드:

```swift
import UserNotifications
import AppBoxNotificationSDK

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        AppBoxNotification.shared.createFCMImage(request, withContentHandler: contentHandler)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
```

---

## 사용법

### 1. SDK 초기 설정

AppBoxNotificationSDK를 초기화합니다.<br>
`autoRegisterForAPNS`는 기본값이 `true`입니다.<br>
특별한 사유가 없다면 별도로 설정할 필요 없이 자동으로 APNS 등록 및 푸시 권한이 수행됩니다.<br>
기존 FCM 연동 앱에서 수동으로 등록을 제어하고 싶다면 `autoRegisterForAPNS: false`로 설정해 주세요.<br><br>

`AppDelegate`에서 초기설정을 진행합니다.

#### import 설정:

```swift
import AppBoxNotificationSDK
```

#### 예제 코드:

##### Firebase 미사용
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
// APNS 권한 및 등록
UNUserNotificationCenter.current().delegate = self

// AppBoxNotification 초기화
AppBoxNotification.shared.initSDK(projectId: "YOUR_PROJECT_ID", debugMode: true) { result, error, granted in
   if let error = error {
       print("error :: \(error)")
   } else {
       print("success :: \(String(describing: result?.message))")
   }
   
   if let granted = granted {
       if !granted.boolValue {
           print("권한 미허용")
       }
   }
}

return true
}

func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    
    // AppBoxNotification APNS 토큰 등록 및 푸시토큰 저장
    AppBoxNotification.shared.application(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) { result, error in
         if let error = error {
             print("error :: \(error)")
         } else {
             print("success:: \(String(describing: result?.message)) pushToken :: \(String(describing: result?.token))")
         }
    }
}

// MARK: UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    //알림이 클릭이 되었을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // AppBoxNotification 클릭 데이터 제공
        AppBoxNotification.shared.saveNotiClick(response)
        if let notiReceive = AppBoxNotification.shared.receiveNotiModel(response) {
            print("push received :: \(notiReceive.params)")
        }
        completionHandler()
    }
    
    // foreground일 때, 알림이 발생
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // AppBoxNotification sound 설정
        completionHandler([.badge, .alert, .sound])
    }
}
```

##### Firebase 사용
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

// FirebaseApp 초기화
FirebaseApp.configure()

// AppBoxNotification 초기화
AppBoxNotification.shared.initSDK(projectId: "YOUR_PROJECT_ID", debugMode: true, autoRegisterForAPNS: false) { result, error, granted in
   if let error = error {
       print("error :: \(error)")
   } else {
       print("success:: \(String(describing: result?.message))")
   }
}

// AppBoxNotification 푸시권한 요청
AppBoxNotification.shared.requestPushAuthorization { granted in
   if granted {
       print("권한 허용")
   } else {
       print("권한 실패")
   }
}

// APNS 권한 및 등록
UNUserNotificationCenter.current().delegate = self
application.registerForRemoteNotifications()

return true
}

func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    
    // AppBoxNotification APNS 토큰 등록 및 푸시토큰 저장
    AppBoxNotification.shared.application(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) { result, error in
         if let error = error {
             print("error :: \(error)")
         } else {
             print("success:: \(String(describing: result?.message)) pushToken :: \(String(describing: result?.token))")
         }
    }
}

// MARK: UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    //알림이 클릭이 되었을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // AppBoxNotification 클릭 데이터 제공
        AppBoxNotification.shared.saveNotiClick(response)
        if let notiReceive = AppBoxNotification.shared.receiveNotiModel(response) {
            print("push received :: \(notiReceive.params)")
        }
        completionHandler()
    }
    
    // foreground일 때, 알림이 발생
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // AppBoxNotification sound 설정
        completionHandler([.badge, .alert, .sound])
    }
}
```
---

### 2. 기능

#### **initSDK**로 초기화 후 다음 기능들을 사용할 수 있습니다.

<br>

#### **푸시토큰 제공**

저장된 푸시토큰을 제공합니다.

#### 예제 코드:

```swift
// 푸시 토큰 가져오기
let pushToken: String? = AppBoxNotification.shared.getPushToken()
```

<br>
<br>

#### **푸시토큰 저장 및 알림 수신 여부 설정**

푸시 알림에 대한 사용 여부와 토큰을 저장합니다.

#### 예제 코드:

```swift
// 푸시 토큰 저장하기
AppBoxNotification.shared.savePushToken(token: pushToken, pushYn: true) { result, error in
    if let error = error {
        print("error :: \(error)")
    } else {
        print("success :: \(String(describing: result?.message)) pushToken :: \(String(describing: result?.token))")
    }
}
```

<br>
<br>

#### **푸시토큰 갱신 이벤트 설정**

AppBoxNotificationSDK에서 푸시 토큰 갱신 이벤트를 수신받기 위한 delegate입니다.<br>
푸시 토큰이 성공적으로 발급되고 저장된 후 `appBoxPushTokenDidUpdate(_:)` 메서드가 호출됩니다.

#### 예제 코드:

```swift
// 푸시 토큰 갱신 이벤트를 수신받기 위한 delegate
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

<br>
<br>

#### **푸시 권한 요청**

푸시 알림 권한을 요청합니다.<br>
시스템 알림 권한 상태를 확인한 뒤, 필요한 경우에만 권한 요청 UI를 표시합니다.<br>
이미 권한이 허용된 경우에는 별도의 요청 없이 바로 `true`를 반환하며,<br>
거부되었거나 요청할 수 없는 상태인 경우 `false`를 반환합니다.

#### 예제 코드:

```swift
// AppBoxNotification 푸시권한 요청
AppBoxNotification.shared.requestPushAuthorization { granted in
   if granted {
       UIApplication.shared.registerForRemoteNotifications()
   } else {
       print("알림 권한이 거부되었습니다.")
   }
}
```

<br>
<br>

#### **세그먼트 저장**

콘솔에 설정한 세그먼트를 저장합니다.

#### 예제 코드:

```swift
// AppBoxNotification 세그먼트 저장
let segmentModel: [String: String] = [
    "name": "이름",
    "age": "12"
]

AppBoxNotification.shared.saveSegment(segment: segmentModel) { result, error in
    if let error = error {
        print("error :: \(error)")
    } else {
        print("success :: \(String(describing: result?.message))")
    }
}
```

<br>
<br>

#### **전환 추적**

푸시 알림을 통해 유입된 사용자의 특정 행동을 추적합니다.<br>
**사용자가 푸시 알림을 클릭하면** 알림에 포함된 `conversionCode`가 자동으로 CoreData에 저장되며, 이후 사용자가 전환 행동을 완료했을 때 `trackingConversion` 메서드를 호출하여 서버에 전송합니다.<br>
저장된 데이터는 삭제되지 않으므로 동일한 `conversionCode`로 여러 번 전환 추적이 가능합니다.

#### 예제 코드:
```swift
// 전환 이벤트 발생 시
AppBoxNotification.shared.trackingConversion(conversionCode: "YKFbBcki") { success, error in
    if success {
        print("전환 추적 성공")
    } else {
        if let error = error {
            print("전환 추적 실패: \(error.localizedDescription)")
        }
    }
}

// Completion이 필요 없는 경우
AppBoxNotification.shared.trackingConversion(conversionCode: "YKFbBcki")
```

---

## 요구 사항

- **iOS** 13.0 이상
- **Swift** 5.6 이상
- **Xcode** 16.0 이상

---

## 주의 사항

1. **초기화 필수**
   - initSDK를 호출하여 SDK를 초기화한 후에만 다른 기능을 사용할 수 있습니다.
   - 초기화를 수행하지 않으면 실행 시 예외가 발생할 수 있습니다.

2. **Firebase 종속성**
   - AppBoxNotification SDK는 [Firebase 11.12.0] 종속성으로 사용하고 있습니다.

---

## 지원

문제가 발생하거나 추가 지원이 필요한 경우 아래로 연락하세요:

- **이메일**: [appbox@mobpa.co.kr](mailto:appbox@mobpa.co.kr)
- **홈페이지**: [https://www.appboxapp.com](https://www.appboxapp.com)

---
