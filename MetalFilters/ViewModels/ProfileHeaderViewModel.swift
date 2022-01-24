//
//  ProfileHeaderViewModel.swift
//  A-List
//
//  Created by Norman Yuan on 11/25/21.
//  Copyright © 2021 A-List. All rights reserved.
//

import Foundation

enum ProfileButtonType {
    case edit
    case follow(isFollowing: Bool)
}

struct ProfileHeaderViewModel {
    let profilePictureUrl: URL?
    let followerCount: Int
    let followingCount: Int
    let postCount: Int
    let buttonType: ProfileButtonType
    let name: String?
    let bio: String?
}
