//
//  PostViewController.swift
//  A-List
//
//  Created by Norman Yuan on 11/14/21.
//  Copyright © 2021 A-List. All rights reserved.
//

import UIKit
import Appirater

class ProfilePostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private let post: Post
    
    private let owner: String
    
    private var collectionView: UICollectionView?
    
    private var viewModels: [SinglePostCellType] = []
    
    private let commentBarView = CommentBarView()
    
    private var observer: NSObjectProtocol?
    
    private var hideObserver: NSObjectProtocol?
    
    private var allPosts: [(post: Post, owner: String)] = []
        
    // MARK: - Init
    
    init(
        post: Post,
        owner: String
    ) {
        self.owner = owner
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "帖子"
        view.backgroundColor = .systemBackground
        configureCollectionView()
        view.addSubview(commentBarView)
        commentBarView.delegate = self
        fetchPost()
        observeKeyboardChange()
        
//        Appirater.tryToShowPrompt()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        commentBarView.frame = CGRect(
            x: 0,
            y: view.height-view.safeAreaInsets.bottom-70,
            width: view.width,
            height: 70
        )
    }
    
    private func observeKeyboardChange() {
        observer = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            queue: .main
        ) { notification in
            guard let userInfo = notification.userInfo,
                  let height = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
                else {
                return
            }
            UIView.animate(withDuration: 0.2) {
                self.commentBarView.frame = CGRect(
                    x: 0,
                    y: self.view.height-70-height,
                    width: self.view.width,
                    height: 70)
            }
        }
        hideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            UIView.animate(withDuration: 0.2) {
                self.commentBarView.frame = CGRect(
                    x: 0,
                    y: self.view.height-self.view.safeAreaInsets.bottom-70,
                    width: self.view.width,
                    height: 70
                )
            }
        }
    }

    private func fetchPost() {
        // mock data
        let username = owner
        DatabaseManager.shared.getPost(with: post.id, from: username) { [weak self] post in
            guard let post = post else {
                return
            }
            self?.createViewModel(
                model: post,
                username: username,
                completion: { success in
                    guard success else {
                        print("failed to create VM")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self?.collectionView?.reloadData()
                    }
                }
            )
        }
    }
    
    private func createViewModel(
        model: Post,
        username: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else { return }
            StorageManager.shared.profilePictureURL(for: username) { [weak self] profilePictureURL in
                
                guard let strongSelf = self,
                    let postUrl = URL(string: model.postUrlString),
                    let profilePhotoUrl = profilePictureURL else {
                        completion(false)
                        return
                }
                
                let isLiked = model.likers.contains(currentUsername)
                
                DatabaseManager.shared.getComments(
                    postID: strongSelf.post.id,
                    owner: strongSelf.owner
                ) { comments in
                    var postData: [SinglePostCellType] = [
                        .poster(viewModel: PosterCollectionViewCellViewModel(
                            username: username,
                            profilePictureURL: profilePhotoUrl
                            )
                        ),
                        .post(
                            viewModel: PostCollectionViewCellViewModel(
                                postUrl: postUrl
                            )
                        ),
                        .actions(viewModel: PostActionsCollectionViewCellViewModel(isLiked: isLiked)),
                        .likeCount(viewModel: PostLikesCollectionViewCellViewModel(likers: model.likers)),
                        .caption(viewModel: PostCaptionCollectionViewCellViewModel(
                            username: username,
                            caption: model.caption)),
                    ]
                    
//                    comments.forEach { in
//
//                    }
                    
                    if let comment = comments.first {
                        postData.append(
                            .comment(viewModel: comment)
                        )
                    }
                    
                    postData.append(
                        .timestamp(
                            viewModel: PostDateTimeCollectionViewCellViewModel(
                                date: DateFormatter.formatter.date(from: model.postedDate) ?? Date()
                            )
                        )
                    )
                    self?.viewModels = postData
                    completion(true)
                }
            }

    }
        
    // CollectionView
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = viewModels[indexPath.row]
        switch cellType {
        case .poster(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProfilePosterCollectionViewCell.identifier,
                for: indexPath
            ) as? ProfilePosterCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCollectionViewCell.identifier,
                for: indexPath
            ) as? PostCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
        case .actions(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostActionsCollectionViewCell.identifier,
                for: indexPath
            ) as? PostActionsCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
        case .likeCount(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostLikesCollectionViewCell.identifier,
                for: indexPath
            ) as? PostLikesCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
        case .caption(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCaptionCollectionViewCell.identifier,
                for: indexPath
            ) as? PostCaptionCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .timestamp(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostDateTimeCollectionViewCell.identifier,
                for: indexPath
            ) as? PostDateTimeCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        case .comment(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CommentCollectionViewCell.identifier,
                for: indexPath
            ) as? CommentCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        }
    }
}

extension ProfilePostViewController: CommentBarViewDelegate {
    func commentBarViewDidTapDone(_ commentBarView: CommentBarView, withText text: String) {
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else { return }
        DatabaseManager.shared.createComments(
            comment: Comment(
                username: currentUsername,
                comment: text,
                dateString: String.date(from: Date()) ?? ""
            ),
            postID: post.id,
            owner: owner
        ) { success in
            DispatchQueue.main.async {
                guard success else {
                    return
                }
            }
        }
    }
}

extension ProfilePostViewController: PostLikesCollectionViewCellDelegate {
    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell, index: Int) {
        let vc = ListViewController(type: .likers(usernames: allPosts[index].post.likers))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfilePostViewController: PostCaptionCollectionViewCellDelegate {
    func postCaptionCollectionViewCellDidTapCaption(_ cell: PostCaptionCollectionViewCell) {
        print("tapped caption")
    }
}

extension ProfilePostViewController: PostActionsCollectionViewCellDelegate {
    func postActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell, index: Int) {
        let cellType = viewModels[index]
            switch cellType {
            case .post(let viewModel):
                let vc = UIActivityViewController(
                    activityItems: ["来自爱琳的分享", viewModel.postUrl],
                    applicationActivities: []
                )
                present(vc, animated: true)
                
            default:
                break
        }
    }
    
    func postActionsCollectionViewCellDidTapComment(_ cell: PostActionsCollectionViewCell, index: Int) {
        commentBarView.field.becomeFirstResponder()
    }
    
    func postActionsCollectionViewCellDidTapLike(
        _ cell: PostActionsCollectionViewCell,
        isLiked: Bool,
        index: Int) {
            DatabaseManager.shared.updateLikeState(
                state: isLiked ? .like : .unlike,
                postID: post.id,
                owner: owner
            ) { success in
                    guard success else {
                        return
                    }
                    print("Failed to like")
        }
    }
   
    func postCollectionViewCellDidLike(_ cell: PostCollectionViewCell, index: Int) {
        DatabaseManager.shared.updateLikeState(
            state: .like,
            postID: post.id,
            owner: owner
        ) { success in
                guard success else {
                    return
                }
                print("Failed to like")
        }
    }
}

//extension PostViewController: PostCollectionViewCellDelegate {}
extension ProfilePostViewController: ProfilePosterCollectionViewCellDelegate {
    
    func posterCollectionViewCellDidTapMore(_ cell: ProfilePosterCollectionViewCell, index: Int) {
        let sheet = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "分享", style: .default, handler: { [weak self]  _ in
            DispatchQueue.main.async {
                let cellType = self?.viewModels[index]
                switch cellType {
                case .post(let viewModel):
                    let vc = UIActivityViewController(
                        activityItems: ["来自爱琳的分享", viewModel.postUrl],
                        applicationActivities: []
                    )
                    self?.present(vc, animated: true)

                default:
                    break
                }
            }
        }))
        sheet.addAction(UIAlertAction(title: "举报", style: .destructive, handler: { _ in
            // Report post
        }))
        present(sheet, animated: true)
    }
    func posterCollectionViewCellDidTapUsername(_ cell: ProfilePosterCollectionViewCell, index: Int) {
        DatabaseManager.shared.findUser(username: owner) { [weak self] user in
            DispatchQueue.main.async {
                guard let user = user else {
                    return
                }
                let vc = ProfileViewController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}


extension ProfilePostViewController {
    func configureCollectionView() {
        let sectionHeight: CGFloat = 300 + view.width
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in
                
                //Item
                let posterItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(60)
                    )
                )
                
                let postItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalWidth(1)
                    )
                )
                
                let actionsItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(40)
                    )
                )
                
                let likeCountItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(40)
                    )
                )
                
                let captionItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(60)
                    )
                )
                
                let commentItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(60)
                    )
                )
                
                let timestampItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(40)
                    )
                )
                                
                //Group
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(sectionHeight)
                    ),
                    subitems: [
                        posterItem,
                        postItem,
                        actionsItem,
                        likeCountItem,
                        captionItem,
                        commentItem,
                        timestampItem
                    ]
                )
                
                //Section
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)
                
                return section
            })
        )
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            ProfilePosterCollectionViewCell.self,
            forCellWithReuseIdentifier: ProfilePosterCollectionViewCell.identifier
        )
        
        collectionView.register(
            PostCollectionViewCell.self,
            forCellWithReuseIdentifier: PostCollectionViewCell.identifier
        )
        
        collectionView.register(
            PostActionsCollectionViewCell.self,
            forCellWithReuseIdentifier: PostActionsCollectionViewCell.identifier
        )
        
        collectionView.register(
            PostLikesCollectionViewCell.self,
            forCellWithReuseIdentifier: PostLikesCollectionViewCell.identifier
        )
        
        collectionView.register(
            PostCaptionCollectionViewCell.self,
            forCellWithReuseIdentifier: PostCaptionCollectionViewCell.identifier
        )
        
        collectionView.register(
            PostDateTimeCollectionViewCell.self,
            forCellWithReuseIdentifier: PostDateTimeCollectionViewCell.identifier
        )
        collectionView.register(CommentCollectionViewCell.self,
                                forCellWithReuseIdentifier: CommentCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.collectionView = collectionView
    }
}

extension ProfilePostViewController: PostCollectionViewCellDelegate {
    func zooming(started: Bool) {
    }
}
