//
//  NotificationsManager.swift
//  A-List
//
//  Created by Norman Yuan on 11/20/21.
//  Copyright © 2021 A-List. All rights reserved.
//

import Foundation

final class NotificationsManager {
    static let shared = NotificationsManager()
    
    enum ALType: Int {
        case like = 1
        case comment = 2
        case follow = 3
    }
    
    private init() {
        
    }
    
    public func getNotifications(
        completion: @escaping ([ALNotification]) -> Void
    ) {
        DatabaseManager.shared.getNotifications(completion: completion)
    }
    
    static func newIdentifier() -> String {
        let date = Date()
        let number1 = Int.random(in: 0...1000)
        let number2 = Int.random(in: 0...1000)
        return "\(number1)_\(number2)_\(date.timeIntervalSince1970)"
    }
    
    public func create(
        notification: ALNotification,
        for username: String
    ) {
        let identifier = notification.identifier
        guard let dictionary = notification.asDictionary() else {
            return
        }
        DatabaseManager.shared.insertNotification(
            identifier: identifier,
            data: dictionary,
            for: username
        )
    }
    
}
