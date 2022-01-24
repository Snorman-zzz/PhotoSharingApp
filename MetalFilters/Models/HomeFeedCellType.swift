//
//  HomeFeedCellType.swift
//  A-List
//
//  Created by Norman Yuan on 11/18/21.
//  Copyright © 2021 A-List. All rights reserved.
//

import Foundation

enum HomeFeedCellType {
    case poster(viewModel: PosterCollectionViewCellViewModel)
    case post(viewModel: PostCollectionViewCellViewModel)
    case actions(viewModel: PostActionsCollectionViewCellViewModel)
    case likeCount(viewModel: PostLikesCollectionViewCellViewModel)
    case caption(viewModel: PostCaptionCollectionViewCellViewModel)
    case timestamp(viewModel: PostDateTimeCollectionViewCellViewModel)
}
