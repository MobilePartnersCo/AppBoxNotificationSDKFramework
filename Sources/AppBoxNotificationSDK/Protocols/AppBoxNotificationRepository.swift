//
//  AppBoxNotificationRepository.swift
//  AppBoxNotificationSDK
//
//  Created by mobilePartners on 3/25/25.
//

import UIKit
@_implementationOnly import Firebase
@_spi(AppBoxNotification_Internal) import AppBoxCore

class AppBoxNotificationRepository: NSObject, AppBoxNotificationProtocol {
    
    static let shared = AppBoxNotificationRepository()
    var messaging: Messaging? = nil
    
    func initSDK(projectId: String?) {
        initSDK(projectId: projectId, debugMode: false, completion: nil)
    }
    
    func initSDK(projectId: String?, debugMode: Bool) {
        initSDK(projectId: projectId, debugMode: debugMode, completion: nil)
    }
    
    func initSDK(projectId: String?, completion: ((AppBoxNotiResultModel?, NSError?) -> Void)?) {
        initSDK(projectId: projectId, debugMode: false, completion: completion)
    }
    
    func initSDK(projectId: String?, debugMode: Bool, completion: ((AppBoxNotiResultModel?, NSError?) -> Void)?) {
        AppBoxCoreFramework.shared.coreSaveDebugMode(debugMode)
        
        let pId = projectId ?? ""
        
        AppBoxCoreFramework.shared.coreSaveProjectId(pId)

        if let _ = FirebaseApp.app() {
            ConfigData.shared.isFcmInit = true
            let model = AppBoxNotiResultModel(token: "", message: "이미 Firebase가 초기화 되어있습니다.")
            completion?(model, nil)
        } else {
            ConfigData.shared.isFcmInit = false
            AppBoxCoreFramework.shared.coreGetPushInfo() { (result: Result<AppPushInfoApiModel, Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        if model.success {
                            let options = FirebaseOptions(
                                googleAppID: model.firebase_info.app_id,
                                gcmSenderID: model.firebase_info.sender_id
                            )
                            
                            options.apiKey = model.firebase_info.api_key
                            options.projectID = model.firebase_info.project_id
                            
                            FirebaseApp.configure(options: options)
                            
                            let model = AppBoxNotiResultModel(token: "", message: "Firebase 초기화 성공")
                            completion?(model, nil)
                            
                        } else {
                            let serverError = ErrorHandler.ServerError(model.message)
                            completion?(nil, NSError(domain: "", code: serverError.errorCode, userInfo: [NSLocalizedDescriptionKey: serverError.errorMessgae]))
                        }
                    case .failure(let error):
                        completion?(nil, error as NSError)
                    }
                }
            }
        }
    }
    
    func application(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        application(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken, completion: nil)
    }
    
    func application(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data, completion: ((AppBoxNotiResultModel?, NSError?) -> Void)?) {
        if !ConfigData.shared.isFcmInit {
            Messaging.messaging().apnsToken = deviceToken
        }
        
        FcmUtil.saveFcmToken { (result: Result<AppBoxNotiResultModel, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    completion?(model, nil)
                case .failure(let error):
                    completion?(nil, error as NSError)
                }
            }
        }
    }
    
    func savePushToken(token: String, pushYn: Bool) {
        savePushToken(token: token, pushYn: pushYn, completion: nil)
    }
    
    func savePushToken(token: String, pushYn: Bool, completion: ((AppBoxNotiResultModel?, NSError?) -> Void)?) {
        FcmUtil.setToken(pushToken: token, pushYn: pushYn) { (result: Result<AppBoxNotiResultModel, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    completion?(model, nil)
                case .failure(let error):
                    completion?(nil, error as NSError)
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
            
            AppBoxCoreFramework.shared.coreSavePushOpen(notiModel: content) { (result: Result<AppPushOpenApiModel, Error>) in
                switch result {
                case .success(let model):
                    if !model.success {
                        debugLog(model.message)
                    }
                case .failure(let error):
                    debugLog(error.localizedDescription)
                }
            }
            return model
        }
        return nil
    }
}
