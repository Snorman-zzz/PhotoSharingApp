//
//  ALFollowButton.swift
//  A-List
//
//  Created by Norman Yuan on 11/27/21.
//  Copyright © 2021 A-List. All rights reserved.
//

import UIKit

final class ALFollowButton: UIButton {
    
    enum State: String {
        case follow = "关注"
        case unfollow = "已关注"
        
        var titleColor: UIColor {
            switch self {
            case .follow: return .white
            case .unfollow: return .label
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .follow: return .systemBlue
            case .unfollow: return .systemBackground
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func configure(for state: State) {
        setTitle(state.rawValue, for: .normal)
        backgroundColor = state.backgroundColor
        setTitleColor(state.titleColor, for: .normal)
        
        switch state {
        case .follow:
            layer.borderWidth = 0
        case .unfollow:
            layer.borderWidth = 0.5
            layer.borderColor = UIColor.secondaryLabel.cgColor
        }
    }
}
