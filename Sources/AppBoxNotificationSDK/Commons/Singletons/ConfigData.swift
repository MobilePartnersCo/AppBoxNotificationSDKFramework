//
//  ConfigData.swift
//  AppBoxNotificationSDK
//
//  Created by mobilePartners on 3/26/25.
//

final class ConfigData {
    static let shared = ConfigData()
    private init() {}
    
    var isFcmInit: Bool = false
}
