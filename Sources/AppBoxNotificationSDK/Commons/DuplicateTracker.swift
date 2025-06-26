//
//  DuplicateTracker.swift
//  AppBoxNotificationSDK
//
//  Created by mobilePartners on 4/21/25.
//

enum DuplicateType: String {
    case initSDK
    case application
    case savePushToken
    case coreSavePushOpen
    case saveSegment
}

class DuplicateTracker {
    static let shared = DuplicateTracker()
    private var flags: [DuplicateType: Bool] = [:]
    
    func set(_ type: DuplicateType) {
        flags[type] = true
    }
    
    func clear(_ type: DuplicateType) {
        flags[type] = false
    }
    
    func isCalled(_ type: DuplicateType) -> Bool {
        return flags[type] ?? false
    }
}
