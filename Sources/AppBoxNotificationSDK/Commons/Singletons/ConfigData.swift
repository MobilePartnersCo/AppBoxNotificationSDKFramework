//
//  ConfigData.swift
//  AppBoxNotificationSDK
//
//  Created by mobilePartners on 3/26/25.
//

final class ConfigData {
    static let shared = ConfigData()
    private init() {}
    
    var initalize: Bool = false
    var isFcmInit: Bool = false
    var isDuplicateInit: Bool = false
    var isDuplicateSave: Bool = false
}
