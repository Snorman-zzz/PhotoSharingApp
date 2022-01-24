//
//  AnalyticsManager.swift
//  A-List
//
//  Created by Norman Yuan on 11/14/21.
//  Copyright © 2021 A-List. All rights reserved.
//

import Foundation
import FirebaseAnalytics

final class AnalyticsManager {
    static let shared = AnalyticsManager()

    private init() {}
    
    enum FeedInteraction: String {
        case like
        case comment
        case share
        case reported
        case doubleTapToLike
    }
    
    func logFeedInteraction(_ type: FeedInteraction) {
        Analytics.logEvent(
            "feedback_interaction",
            parameters: [
                "type":type.rawValue.lowercased()
            ]
        )
    }
}
