//
//  NotificationCellType.swift
//  A-List
//
//  Created by Norman Yuan on 11/20/21.
//  Copyright © 2021 A-List. All rights reserved.
//

import Foundation

enum NotificationCellType {
    case follow(viewModel: FollowNotificationCellViewModel)
    case like(viewModel: LikeNotificationCellViewModel)
    case comment(viewModel: CommentNotificationCellViewModel)
}
