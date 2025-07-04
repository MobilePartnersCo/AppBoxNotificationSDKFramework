//
//  FcmUtil.swift
//  AppBoxNotificationSDK
//
//  Created by mobilePartners on 3/26/25.
//
#if !EXTENSION
import Firebase
#endif
@_spi(AppBoxNotification_Internal) import AppBoxCore

class FcmUtil {
    static func saveFcmToken(completion: @escaping (Result<AppBoxNotiResultModel, any Error>) -> Void) {
        Messaging.messaging().token { token, error in
            
            
            let pushToken = token ?? AppBoxCoreFramework.shared.coreGetPushToken() ?? ""
            
            setToken(pushToken: pushToken, pushYn: nil) { (result: Result<AppBoxNotiResultModel, Error>) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    static func setToken(pushToken: String, pushYn: Bool?, completion: @escaping (Result<AppBoxNotiResultModel, any Error>) -> Void) {
        AppBoxCoreFramework.shared.coreSaveDeviceToken(pushToken, pushYn: pushYn) { (result: Result<AppPushTokenApiModel, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.success {
                        AppBoxCoreFramework.shared.coreSavePushToken(pushToken)
                        completion(.success(AppBoxNotiResultModel(token: pushToken, message: "")))
                    } else {
                        let serverError = ErrorHandler.ServerError("\(model.message)(\(model.code))")
                        completion(.failure(NSError(domain: "", code: serverError.errorCode, userInfo: [NSLocalizedDescriptionKey: serverError.errorMessgae])))
                    }
                case .failure(let error):
                    var serverError = ErrorHandler.ServerError(error.localizedDescription)
                    let nsError = error as NSError
                    if ErrorHandler.allErrorCodes.contains(nsError.code) {
                        completion(.failure(nsError))
                    } else {
                        completion(.failure(NSError(domain: "", code: serverError.errorCode, userInfo: [NSLocalizedDescriptionKey: serverError.errorMessgae])))
                    }
                }
            }
        }
    }
}
