//
//  AppBoxNotificationRepository.swift
//  AppBoxNotificationSDK
//
//  Created by mobilePartners on 3/25/25.
//

import UIKit
import Firebase
@_spi(AppBoxNotification_Internal) import AppBoxCore

class AppBoxNotificationRepository: NSObject, AppBoxNotificationProtocol {
    static let shared = AppBoxNotificationRepository()
    public weak var delegate: AppBoxNotificationDelegate?
    let center = UNUserNotificationCenter.current()

    // MARK: - Fixed Topic

    private var lastAppliedPushYn: String? {
        get { AppBoxCoreFramework.shared.coreGetLastAppliedPushYn() }
        set {
            if let value = newValue {
                AppBoxCoreFramework.shared.coreSaveLastAppliedPushYn(value)
            }
        }
    }
    private var fixedTopics: [String] = []

    // MARK: - Topic Validation

    private let topicRegex = "^[a-zA-Z0-9_-]+$"
    private let maxTopicLength = 200
    
    
    func initSDK(projectId: String?) {
        initSDK(projectId: projectId, debugMode: false, autoRegisterForAPNS: true, completion: nil)
    }
    
    func initSDK(projectId: String?, debugMode: Bool) {
        initSDK(projectId: projectId, debugMode: debugMode, autoRegisterForAPNS: true, completion: nil)
    }
    
    func initSDK(projectId: String?, completion: ((AppBoxNotiResultModel?, NSError?, NSNumber?) -> Void)?) {
        initSDK(projectId: projectId, debugMode: false, autoRegisterForAPNS: true, completion: completion)
    }
    
    func initSDK(projectId: String?, debugMode: Bool, completion: ((AppBoxNotiResultModel?, NSError?, NSNumber?) -> Void)?) {
        initSDK(projectId: projectId, debugMode: debugMode, autoRegisterForAPNS: true, completion: completion)
    }
    
    func initSDK(projectId: String?, debugMode: Bool, autoRegisterForAPNS: Bool, completion: ((AppBoxNotiResultModel?, NSError?, NSNumber?) -> Void)?) {
        guard !DuplicateTracker.shared.isCalled(.initSDK) else {
            let error = ErrorHandler.preventDuplicate
            debugLog("Warning :: \(error.errorMessgae)", isWarning: true)
            completion?(nil, NSError(domain: "", code: error.errorCode, userInfo: [NSLocalizedDescriptionKey: error.errorMessgae]), nil)
            return
        }
        
        
        DuplicateTracker.shared.set(.initSDK)
        AppBoxCoreFramework.shared.coreSaveDebugMode(debugMode)
        
        guard let pId = projectId, !pId.isEmpty else {
            let error = ErrorHandler.noProjectId
            debugLog("Warning :: \(error.errorMessgae)", isWarning: true)
            completion?(nil, NSError(domain: "", code: error.errorCode, userInfo: [NSLocalizedDescriptionKey: error.errorMessgae]), nil)
            AppBoxCoreFramework.shared.coreInitQueue(false)
            DuplicateTracker.shared.clear(.initSDK)
            return
        }
        
        AppBoxCoreFramework.shared.coreSaveProjectId(pId)

        let trimmedProjectId = pId.trimmingCharacters(in: .whitespacesAndNewlines)
        fixedTopics = trimmedProjectId.isEmpty ? ["IOS"] : [trimmedProjectId, "IOS"]

        if let _ = FirebaseApp.app() {
            ConfigData.shared.isFcmInit = true
            AppBoxCoreFramework.shared.coreInitQueue(true)
            let model = AppBoxNotiResultModel(token: "", message: initMessage)
            debugLog("Success :: \(initMessage)")
            
            if autoRegisterForAPNS {
                self.requestPushAuthorization { granted in
                    let permission: NSNumber? = NSNumber(value: granted)
                    completion?(model, nil, permission)
                }
                UIApplication.shared.registerForRemoteNotifications()
            } else {
                completion?(model, nil, nil)
            }
            
        } else {
            ConfigData.shared.isFcmInit = false
            AppBoxCoreFramework.shared.coreGetPushInfo() { (result: Result<AppPushInfoApiModel, Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        if model.success {
                            AppBoxCoreFramework.shared.coreInitQueue(true)
                            
                            let options = FirebaseOptions(
                                googleAppID: model.data?.app_id ?? "",
                                gcmSenderID: model.data?.sender_id ?? ""
                            )
                            
                            options.apiKey = model.data?.api_key
                            options.projectID = model.data?.project_id
                            
                            FirebaseApp.configure(options: options)
                            
                            let model = AppBoxNotiResultModel(token: "", message: initMessage)
                            debugLog("Success :: \(initMessage)")
                            
                            if autoRegisterForAPNS {
                                self.requestPushAuthorization { granted in
                                    let permission: NSNumber? = NSNumber(value: granted)
                                    completion?(model, nil, permission)
                                }
                                UIApplication.shared.registerForRemoteNotifications()
                            } else {
                                completion?(model, nil, nil)
                            }
                            
                            
                        } else {
                            AppBoxCoreFramework.shared.coreInitQueue(false)
                            DuplicateTracker.shared.clear(.initSDK)
                            let serverError = ErrorHandler.ServerError("\(model.message)(\(model.code))")
                            debugLog("Error :: \(serverError.errorMessgae)")
                            completion?(nil, NSError(domain: "", code: serverError.errorCode, userInfo: [NSLocalizedDescriptionKey: serverError.errorMessgae]), nil)
                        }
                    case .failure(let error):
                        AppBoxCoreFramework.shared.coreInitQueue(false)
                        DuplicateTracker.shared.clear(.initSDK)
                        
                        let serverError = ErrorHandler.ServerError(error.localizedDescription)
                        let nsError = error as NSError
                        if ErrorHandler.allErrorCodes.contains(nsError.code) {
                            debugLog("Error :: \(nsError.localizedDescription)")
                            completion?(nil, nsError, nil)
                        } else {
                            debugLog("Error :: \(serverError.errorMessgae)")
                            completion?(nil, NSError(domain: "", code: serverError.errorCode, userInfo: [NSLocalizedDescriptionKey: serverError.errorMessgae]), nil)
                        }
                    }
                }
            }
        }
    }
    
    func application(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        application(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken, completion: nil)
    }
    
    func application(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data, completion: ((AppBoxNotiResultModel?, NSError?) -> Void)?) {
        guard !DuplicateTracker.shared.isCalled(.application) else {
            let error = ErrorHandler.alreadyExcute
            debugLog("Warning :: \(error.errorMessgae)", isWarning: true)
            completion?(nil, NSError(domain: "", code: error.errorCode, userInfo: [NSLocalizedDescriptionKey: error.errorMessgae]))
            return
        }
        
        DuplicateTracker.shared.set(.application)
        
        guard DuplicateTracker.shared.isCalled(.initSDK) else {
            let error = ErrorHandler.validInit
            debugLog("Warning :: \(error.errorMessgae)", isWarning: true)
            completion?(nil, NSError(domain: "", code: error.errorCode, userInfo: [NSLocalizedDescriptionKey: error.errorMessgae]))
            return
        }

        AppBoxCoreFramework.shared.coreEnqueue {
            DispatchQueue.main.async {
                Messaging.messaging().apnsToken = deviceToken

                FcmUtil.saveFcmToken { (result: Result<AppBoxNotiResultModel, Error>) in
                    DispatchQueue.main.async {
                        self.processFixedTopicsIfNeeded()
                        switch result {
                        case .success(let model):
                            debugLog("Success :: \(model.token)")
                            completion?(model, nil)
                            DuplicateTracker.shared.clear(.application)
                        case .failure(let error):
                            debugLog("Error :: \(error.localizedDescription)")
                            completion?(nil, error as NSError)
                            DuplicateTracker.shared.clear(.application)
                        }
                        self.delegate?.appBoxPushTokenDidUpdate?(self.getPushToken())
                    }
                }
            }
        }
    }
    
    func savePushToken(token: String, pushYn: Bool) {
        savePushToken(token: token, pushYn: pushYn, completion: nil)
    }
    
    func savePushToken(token: String, pushYn: Bool, completion: ((AppBoxNotiResultModel?, NSError?) -> Void)?) {
        guard !DuplicateTracker.shared.isCalled(.savePushToken) else {
            let error = ErrorHandler.alreadyExcute
            debugLog("Warning :: \(error.errorMessgae)", isWarning: true)
            completion?(nil, NSError(domain: "", code: error.errorCode, userInfo: [NSLocalizedDescriptionKey: error.errorMessgae]))
            return
        }
        
        DuplicateTracker.shared.set(.savePushToken)
        
        guard DuplicateTracker.shared.isCalled(.initSDK) else {
            let error = ErrorHandler.validInit
            debugLog("Warning :: \(error.errorMessgae)", isWarning: true)
            completion?(nil, NSError(domain: "", code: error.errorCode, userInfo: [NSLocalizedDescriptionKey: error.errorMessgae]))
            return
        }

        AppBoxCoreFramework.shared.coreEnqueue {
            FcmUtil.setToken(pushToken: token, pushYn: pushYn) { (result: Result<AppBoxNotiResultModel, Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        AppBoxCoreFramework.shared.coreSavePushYn(pushYn ? "Y" : "N")
                        self.syncFixedTopics(pushYn: pushYn ? "Y" : "N")
                        debugLog("Success :: \(model.token) pushYn: \(pushYn)")
                        completion?(model, nil)
                        DuplicateTracker.shared.clear(.savePushToken)
                    case .failure(let error):
                        debugLog("Error :: \(error.localizedDescription)")
                        completion?(nil, error as NSError)
                        DuplicateTracker.shared.clear(.savePushToken)
                    }
                    self.delegate?.appBoxPushTokenDidUpdate?(self.getPushToken())
                }
            }
        }
    }
    
    func getPushToken() -> String? {
        return AppBoxCoreFramework.shared.coreGetPushToken()
    }
    
    func receiveNotiModel(_ receive: UNNotificationResponse) -> AppBoxNotiModel? {
        if let content = AppboxNotificationModel(userInfo: receive.notification.request.content.userInfo) {
            let model = AppBoxNotiModel(params: content.param)
            return model
        }
        return nil
    }
    
    func saveNotiClick(_ receive: UNNotificationResponse) {
        guard !DuplicateTracker.shared.isCalled(.coreSavePushOpen) else {
            let error = ErrorHandler.alreadyExcute
            debugLog("Warning :: \(error.errorMessgae)", isWarning: true)
            return
        }
        
        DuplicateTracker.shared.set(.coreSavePushOpen)
        
        guard DuplicateTracker.shared.isCalled(.initSDK) else {
            let error = ErrorHandler.validInit
            debugLog("Warning :: \(error.errorMessgae)", isWarning: true)
            return
        }
        
        AppBoxCoreFramework.shared.coreEnqueue {
            if let content = AppboxNotificationModel(userInfo: receive.notification.request.content.userInfo) {
                AppBoxCoreFramework.shared.coreSavePushOpen(notiModel: content) { (result: Result<AppPushOpenApiModel, Error>) in
                    switch result {
                    case .success(let model):
                        if !model.success {
                            let serverError = ErrorHandler.ServerError("\(model.message)(\(model.code))")
                            debugLog("Error :: \(serverError.errorMessgae)")
                        } else {
                            debugLog("Success :: \(successMessage)")
                        }
                        DuplicateTracker.shared.clear(.coreSavePushOpen)
                    case .failure(let error):
                        var serverError = ErrorHandler.ServerError(error.localizedDescription)
                        let nsError = error as NSError
                        if ErrorHandler.allErrorCodes.contains(nsError.code) {
                            debugLog("Error :: \(nsError.localizedDescription)")
                        } else {
                            debugLog("Error :: \(serverError.errorMessgae)")
                        }
                        
                        DuplicateTracker.shared.clear(.coreSavePushOpen)
                    }
                }
                
                // Conversion 데이터 저장 (AppBoxCore에 위임)
                AppBoxCoreFramework.shared.coreSaveConversionData(notiModel: content)
            }
        }
    }
    
    func requestPushAuthorization(completion: @escaping (Bool) -> Void) {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional:
                    //허용
                    debugLog("user permission authorized")
                    completion(true)
                case .denied:
                    //거부
                    debugLog("user permission denied")
                    completion(false)
                case .notDetermined:
                    // 권한 요청 안함
                    self.center.requestAuthorization(options: options) { granted, error in
                        DispatchQueue.main.async {
                            if let error = error {
                                debugLog("Error requesting notification authorization: \(error.localizedDescription)")
                            }
                            
                            if granted {
                                debugLog("user permission authorized")
                            } else {
                                debugLog("user permission denied")
                            }

                            completion(granted)
                        }
                    }
                case .ephemeral:
                    debugLog("Ephemeral state detected - push will work, but session is temporary.")
                    completion(true)
                @unknown default:
                    //알 수없는 상태
                    debugLog("unkown error")
                    completion(false)
                }
            }
        }
    }
    
    func createFCMImage(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        AppBoxCore.AppBoxCoreFramework.shared.coreSetFCMImage(request, contentHandler: contentHandler)
    }
    
    func saveSegment(segment: [String : String]) {
        saveSegment(segment: segment, completion: nil)
    }
    
    func saveSegment(segment: [String : String], completion: ((AppBoxNotiResultModel?, NSError?) -> Void)?) {
        guard !DuplicateTracker.shared.isCalled(.saveSegment) else {
            let error = ErrorHandler.alreadyExcute
            debugLog("Warning :: \(error.errorMessgae)", isWarning: true)
            return
        }
        
        DuplicateTracker.shared.set(.saveSegment)
        
        guard DuplicateTracker.shared.isCalled(.initSDK) else {
            let error = ErrorHandler.validInit
            debugLog("Warning :: \(error.errorMessgae)", isWarning: true)
            return
        }
        
        AppBoxCoreFramework.shared.coreEnqueue {
            AppBoxCoreFramework.shared.coreSaveSegment(segment) { (result: Result<AppPushSegmentApiModel, any Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        if model.success {
                            let model = AppBoxNotiResultModel(token: "", message: "save Success")
                            debugLog("Success :: \(successMessage)")
                            completion?(model, nil)
                        } else {
                            let serverError = ErrorHandler.ServerError("\(model.message)(\(model.code))")
                            debugLog("Error :: \(serverError.errorMessgae)")
                            completion?(nil, NSError(domain: "", code: serverError.errorCode, userInfo: [NSLocalizedDescriptionKey: serverError.errorMessgae]))
                        }
                        DuplicateTracker.shared.clear(.saveSegment)
                    case .failure(let error):
                        var serverError = ErrorHandler.ServerError(error.localizedDescription)
                        let nsError = error as NSError
                        if ErrorHandler.allErrorCodes.contains(nsError.code) {
                            debugLog("Error :: \(nsError.localizedDescription)")
                            completion?(nil, nsError)
                        } else {
                            debugLog("Error :: \(serverError.errorMessgae)")
                            completion?(nil, NSError(domain: "", code: serverError.errorCode, userInfo: [NSLocalizedDescriptionKey: serverError.errorMessgae]))
                        }
                        
                        DuplicateTracker.shared.clear(.saveSegment)
                    }
                }
            }
        }
    }
    
    func trackingConversion(conversionCode: String, completion: ((_ success: Bool, _ error: NSError?) -> Void)?) {
        guard DuplicateTracker.shared.isCalled(.initSDK) else {
            let error = ErrorHandler.validInit
            debugLog("Warning :: \(error.errorMessgae)", isWarning: true)
            completion?(false, NSError(domain: "", code: error.errorCode, userInfo: [NSLocalizedDescriptionKey: error.errorMessgae]))
            return
        }
        
        // AppBoxCore에 모든 로직 위임 (단순 전달만)
        AppBoxCoreFramework.shared.coreEnqueue {
            AppBoxCoreFramework.shared.coreSendConversion(conversionCode: conversionCode) { (result: Result<AppConversionApiModel, Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        if model.success {
                            debugLog("Success :: Conversion tracked for \(conversionCode)")
                            completion?(true, nil)
                        } else {
                            let error = NSError(domain: "", code: model.code, userInfo: [NSLocalizedDescriptionKey: model.message])
                            debugLog("Error :: \(model.message)")
                            completion?(false, error)
                        }
                    case .failure(let error):
                        debugLog("Error :: \(error.localizedDescription)")
                        completion?(false, error as NSError)
                    }
                }
            }
        }
    }
    
    func trackingConversion(conversionCode: String) {
        trackingConversion(conversionCode: conversionCode, completion: nil)
    }

    // MARK: - Topic Subscribe/Unsubscribe (Public API)

    func subscribeToTopic(_ topic: String, completion: ((_ success: Bool, _ error: NSError?) -> Void)?) {
        sendTopicEvent(eventType: "SUBSCRIBE", topic: topic, completion: completion)
    }

    func subscribeToTopic(_ topic: String) {
        subscribeToTopic(topic, completion: nil)
    }

    func unsubscribeFromTopic(_ topic: String, completion: ((_ success: Bool, _ error: NSError?) -> Void)?) {
        sendTopicEvent(eventType: "UNSUBSCRIBE", topic: topic, completion: completion)
    }

    func unsubscribeFromTopic(_ topic: String) {
        unsubscribeFromTopic(topic, completion: nil)
    }
}

// MARK: - Fixed Topic (Private)
private extension AppBoxNotificationRepository {

    func processFixedTopicsIfNeeded() {
        let currentPushYn = AppBoxCoreFramework.shared.coreGetEffectivePushYn()
        guard lastAppliedPushYn != currentPushYn else {
            debugLog("processFixedTopics: 이미 처리됨(lastApplied=\(currentPushYn)), 스킵")
            return
        }
        guard !fixedTopics.isEmpty else {
            debugLog("processFixedTopics: 고정 토픽 없음")
            lastAppliedPushYn = currentPushYn
            return
        }
        let shouldSubscribe = (currentPushYn == "Y")
        debugLog("processFixedTopics: 시작 - pushYN=\(currentPushYn), topics=\(fixedTopics), subscribe=\(shouldSubscribe)")
        let group = DispatchGroup()
        let lock = NSLock()
        var allSuccess = true
        for topic in fixedTopics {
            group.enter()
            fcmTopic(eventType: shouldSubscribe ? "SUBSCRIBE" : "UNSUBSCRIBE", topic: topic) { success in
                if !success { lock.lock(); allSuccess = false; lock.unlock() }
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            if allSuccess {
                self.lastAppliedPushYn = currentPushYn
                debugLog("processFixedTopics: 완료 - pushYN=\(currentPushYn), topics=\(self.fixedTopics)")
            } else {
                debugLog("processFixedTopics: 일부 실패, 다음 실행 시 재시도 (lastAppliedPushYn 미저장)")
            }
        }
    }

    func syncFixedTopics(pushYn: String) {
        guard !fixedTopics.isEmpty else { return }
        let shouldSubscribe = (pushYn == "Y")
        debugLog("syncFixedTopics: 시작 - pushYN=\(pushYn), topics=\(fixedTopics), subscribe=\(shouldSubscribe)")
        let group = DispatchGroup()
        let lock = NSLock()
        var allSuccess = true
        for topic in fixedTopics {
            group.enter()
            fcmTopic(eventType: shouldSubscribe ? "SUBSCRIBE" : "UNSUBSCRIBE", topic: topic) { success in
                if !success { lock.lock(); allSuccess = false; lock.unlock() }
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            if allSuccess {
                self.lastAppliedPushYn = pushYn
                debugLog("syncFixedTopics: 완료 - pushYN=\(pushYn), topics=\(self.fixedTopics)")
            } else {
                debugLog("syncFixedTopics: 일부 실패, 다음 실행 시 재시도 (lastAppliedPushYn 미저장)")
            }
        }
    }

    func sendTopicEvent(eventType: String, topic: String, completion: ((_ success: Bool, _ error: NSError?) -> Void)?) {
        // [1] 유효성 검사
        let trimmed = topic.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty,
              trimmed.count <= maxTopicLength,
              trimmed.range(of: topicRegex, options: .regularExpression) != nil else {
            let error = ErrorHandler.rangeValue("topic")
            debugLog("Warning :: \(error.errorMessgae) - topic=\(topic)", isWarning: true)
            completion?(false, NSError(domain: "", code: error.errorCode, userInfo: [NSLocalizedDescriptionKey: error.errorMessgae]))
            return
        }
        // [2] 고정 토픽 차단
        guard !fixedTopics.contains(trimmed) else {
            let error = ErrorHandler.fixedTopicProtected
            debugLog("Warning :: \(error.errorMessgae) - topic=\(trimmed)", isWarning: true)
            completion?(false, NSError(domain: "", code: error.errorCode, userInfo: [NSLocalizedDescriptionKey: error.errorMessgae]))
            return
        }
        // [3] fetchTopicFilter API
        AppBoxCoreFramework.shared.coreFetchTopicFilter(eventType: eventType, topics: [trimmed]) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    completion?(false, error as NSError)
                case .success(let model):
                    guard model.success, let subscribable = model.data?.subscribable, subscribable.contains(trimmed) else {
                        let error = ErrorHandler.ServerError("\(model.message)(\(model.code))")
                        completion?(false, NSError(domain: "", code: error.errorCode, userInfo: [NSLocalizedDescriptionKey: error.errorMessgae]))
                        return
                    }
                    // [4] FCM 처리
                    self.fcmTopic(eventType: eventType, topic: trimmed) { fcmSuccess in
                        guard fcmSuccess else {
                            let error = ErrorHandler.ServerError("FCM \(eventType) 실패")
                            completion?(false, NSError(domain: "", code: error.errorCode, userInfo: [NSLocalizedDescriptionKey: error.errorMessgae]))
                            return
                        }
                        // [5] sendTopicCallback API
                        AppBoxCoreFramework.shared.coreSendTopicCallback(eventType: eventType, topics: [trimmed]) { [weak self] callbackResult in
                            guard let self = self else { return }
                            DispatchQueue.main.async {
                                switch callbackResult {
                                case .success(let model) where model.success:
                                    debugLog("sendTopicEvent: 완료 - topic=\(trimmed), eventType=\(eventType)")
                                    completion?(true, nil)
                                default:
                                    // [6] 콜백 실패 → FCM 롤백
                                    let rollbackType = eventType == "SUBSCRIBE" ? "UNSUBSCRIBE" : "SUBSCRIBE"
                                    self.fcmTopic(eventType: rollbackType, topic: trimmed) { _ in
                                        debugLog("sendTopicEvent: 콜백 실패, FCM 롤백 완료 - topic=\(trimmed)")
                                        let error = ErrorHandler.ServerError("callback 실패")
                                        completion?(false, NSError(domain: "", code: error.errorCode, userInfo: [NSLocalizedDescriptionKey: error.errorMessgae]))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func fcmTopic(eventType: String, topic: String, completion: @escaping (Bool) -> Void) {
        if eventType == "SUBSCRIBE" {
            Messaging.messaging().subscribe(toTopic: topic) { error in completion(error == nil) }
        } else {
            Messaging.messaging().unsubscribe(fromTopic: topic) { error in completion(error == nil) }
        }
    }
}
