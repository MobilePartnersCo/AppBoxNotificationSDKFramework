//
//  NotiModel.swift
//  AppBoxNotificationSDK
//
//  Created by mobilePartners on 3/25/25.
//

import Foundation

@objcMembers
public class AppBoxNotiModel: NSObject {
    public let params: String
    
    init(params: String) {
        self.params = params
    }
}
