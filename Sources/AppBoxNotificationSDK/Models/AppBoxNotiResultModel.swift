//
//  AppBoxResultModel.swift
//  AppBoxNotificationSDK
//
//  Created by mobilePartners on 3/25/25.
//

import Foundation

@objcMembers
public class AppBoxNotiResultModel:NSObject, Codable {
    public let token: String
    public let message: String
    
    enum CodingKeys: String, CodingKey {
        case token, message
    }
    
    public init(token: String, message: String) {
        self.token = token
        self.message = message
    }
    
    required public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.token = try container.decode(String.self, forKey: .token)
        self.message = try container.decode(String.self, forKey: .message)
    }
}
