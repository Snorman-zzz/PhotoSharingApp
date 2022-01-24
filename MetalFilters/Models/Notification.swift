//
//  Notification.swift
//  A-List
//
//  Created by Norman Yuan on 11/14/21.
//  Copyright © 2021 A-List. All rights reserved.
//

import Foundation

struct ALNotification: Codable {
    let identifier: String
    let notificationType: Int // 1: like, 2: comment, 3: follow
    let profilePictureUrl: String
    let username: String
    let dateString: String
    // Follow/Unfollow
    let isFollowing: Bool?
    // Like/Comment
    let postId: String?
    let postUrl: String?
}
