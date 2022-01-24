//
//  SinglePostCellType.swift
//  A-List
//
//  Created by Norman Yuan on 12/1/21.
//  Copyright © 2021 A-List. All rights reserved.
//

import Foundation

enum SinglePostCellType {
    case poster(viewModel: PosterCollectionViewCellViewModel)
    case post(viewModel: PostCollectionViewCellViewModel)
    case actions(viewModel: PostActionsCollectionViewCellViewModel)
    case likeCount(viewModel: PostLikesCollectionViewCellViewModel)
    case caption(viewModel: PostCaptionCollectionViewCellViewModel)
    case timestamp(viewModel: PostDateTimeCollectionViewCellViewModel)
    case comment(viewModel: Comment)
}
