//
//  PostLikesCollectionViewCell.swift
//  A-List
//
//  Created by Norman Yuan on 11/18/21.
//  Copyright © 2021 A-List. All rights reserved.
//

import UIKit

protocol PostLikesCollectionViewCellDelegate: AnyObject {
    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell, index: Int)
}

class PostLikesCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostLikesCollectionViewCell"
    
    private var index = 0
    
    weak var delegate: PostLikesCollectionViewCellDelegate?
    
    private let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(label)
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapLabel))
        
        label.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didTapLabel() {
        delegate?.postLikesCollectionViewCellDidTapLikeCount(self, index: index)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 10, y: 0, width: contentView.width-12, height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    func configure(with viewModel: PostLikesCollectionViewCellViewModel, index: Int) {
        self.index = index
        let users = viewModel.likers
        label.text = "\(users.count) 次赞"
    }
}
