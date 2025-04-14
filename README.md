![AppBoxNotification_JPG](https://raw.githubusercontent.com/MobilePartnersCo/AppBoxSampleiOS/main/resource/image/AppboxVisual.jpg)

# AppBoxNotification SDK 사용 샘플소스
[![Swift Package Manager](https://img.shields.io/badge/SPM-Compatible-green.svg)](https://swift.org/package-manager/)
[![Version](https://img.shields.io/github/v/tag/MobilePartnersCo/AppBoxNotificationSDKFramework?label=version)](https://github.com/MobilePartnersCo/AppBoxNotificationSampleiOS)

- AppBoxNotification SDK는 푸시를 간편하게 연동하는 솔루션입니다. 

---

## 라이선스

- 앱박스의 SDK의 사용은 영구적으로 무료입니다. 기업 또는 개인 상업적인 목적으로 사용 할 수 있습니다.

---

## 개발자 메뉴얼

- **메뉴얼**: [https://www.appboxapp.com/guide/dev](https://www.appboxapp.com/guide/dev)

---

## 데모앱 다운로드

- GooglePlay : https://play.google.com/store/apps/details?id=kr.co.mobpa.appbox
- AppStore : https://apps.apple.com/kr/app/id6737824370

---

## 설치 방법

AppBoxNotificationSDK는 [Swift Package Manager](https://swift.org/package-manager/)를 통해 배포됩니다. SPM 설치를 위해 다음 단계를 따라주세요:
<br>AppBoxPushSDK는 [Firebase 11.11.0] 종속성으로 사용하고 있습니다.

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

---

## 사용법

### 1. SDK 초기화

AppBoxNotification SDK를 사용하려면 먼저 초기화를 수행해야 합니다. initSDK 메서드를 호출하여 초기화를 완료하세요.

`AppDelegate`에서 초기화를 진행합니다.

#### import 설정:

```swift
import AppBoxNotificationSDK
```

#### 예제 코드:

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {


// AppBoxNotification 초기화
// Firbase가 init이 있을 경우
// FirebaseApp.configure() 이후 선언

AppBoxNotification.shared.initSDK(projectId: "", debugMode: true) { result, error in
    if let error = error {
        print("error :: \(error)")
    } else {
        print("success:: \(String(describing: result?.message))")
    }
}

return true
}

func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    
    // AppBoxNotification FCM APNS 토큰 등록 (FCM Messaging 사용 중이 아닐 경우 (필수))
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

### 2. SDK 실행

초기화된 SDK를 실행하려면 start 메서드를 호출하세요. 실행 결과는 콜백을 통해 전달됩니다.

#### 예제 코드:

```swift

// AppBox 실행
AppBox.shared.start(from: self) { isSuccess, error in
   if isSuccess {
       // 실행 성공 처리
       print("AppBox:: SDK 실행 성공")
   } else {
       // 실행 실패 처리
       if let error = error {
           print("error : \(error.localizedDescription)")
       } else {
           print("error : unkown Error")
       }
   }
}
```

---

### 3. 추가 기능 설정

AppBox SDK 실행 전 추가 기능이 설정이 되어야 적용이 됩니다.

- #### **BaseUrl 설정**

AppBox SDK init에 설정된 BaseUrl를 재설정 합니다.

#### 예제 코드:

```swift
// AppBox BaseUrl 설정
AppBox.shared.setBaseUrl(baseUrl: "https://example.com")
```

- #### **Debug 설정**

AppBox SDK init에 설정된 Debug모드를 재설정 합니다.

#### 예제 코드:

```swift
// AppBox Debug모드 설정
AppBox.shared.setDebug(debugMode: true)
```

- #### **인트로 설정**

최초 앱 설치 후 AppBox SDK를 실행 시 인트로 화면이 노출됩니다.

#### 예제 코드:

```swift
// AppBox 인트로 설정
if let introItem1 = AppBoxIntroItems(imageUrl: "https://example.com/image.jpg") {
  let items = [introItem1]
  let intro = AppBoxIntro(indicatorDefColor: "#a7abab", indicatorSelColor: "#000000", fontColor: "#000000", item: items)
  AppBox.shared.setIntro(intro)
} else {
  print("Failed to initialize AppBoxIntro with empty URL.")
}
```

- #### **당겨서 새로고침 설정**

스크롤을 당기면 웹이 새로고침되는 기능입니다.

사용여부 설정에 따라서 당겨서 새로고침 기능이 적용이 됩니다.

#### 예제 코드:

```swift
// AppBox 당겨서 새로고침 설정
AppBox.shared.setPullDownRefresh(
   used: true
)
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

---

## 지원

문제가 발생하거나 추가 지원이 필요한 경우 아래로 연락하세요:

- **이메일**: [contact@mobpa.co.kr](mailto:contact@mobpa.co.kr)
- **홈페이지**: [https://www.appboxapp.com](https://www.appboxapp.com)

---
