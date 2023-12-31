//
//  ExploreViewController.swift
//  A-List
//
//  Created by Norman Yuan on 11/13/21.
//  Copyright © 2021 A-List. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController, UISearchResultsUpdating {
    
    private let searchVC = UISearchController(searchResultsController: SearchResultsViewController())

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout{ index, _ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(2/3),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            let fullItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            let tripletItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.33),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/3),
                    heightDimension: .fractionalHeight(1)
                ),                subitem: fullItem,
                count: 2
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(300)
                ),
                subitems: [
                    item,
                    verticalGroup
                ]
            )
            
            let threeItemGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(0.000125)
                ),
                subitem: tripletItem,
                count: 3
            )
            
            let leftHorizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(300)
                ),
                subitems: [
                    verticalGroup,
                    item
                ]
            )
            
            let finalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1200)
                ),
                subitems: [
                    horizontalGroup,
                    threeItemGroup,
                    threeItemGroup,
                    leftHorizontalGroup,
                    threeItemGroup,
                    threeItemGroup
                ]
            )

            return NSCollectionLayoutSection(group: finalGroup)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private var posts = [(post: Post, user: User)]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        (searchVC.searchResultsController as? SearchResultsViewController)?.delegate = self
        searchVC.searchBar.placeholder = "搜索"
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func fetchData() {
        DatabaseManager.shared.explorePosts { [weak self] posts in
            DispatchQueue.main.async {
                self?.posts = posts
                self?.collectionView.reloadData()
            }
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsVC = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        DatabaseManager.shared.findUsers(with: query) { results in
            DispatchQueue.main.async {
                resultsVC.update(with: results)
            }
        }
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath
        ) as? PhotoCollectionViewCell else {
            fatalError()
        }
        let model = posts[indexPath.row]
        cell.configure(with: URL(string: model.post.postUrlString))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = posts[indexPath.row]
        let vc = PostViewController(post: model.post, owner: model.user.username)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ExploreViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewController(_ vc: SearchResultsViewController, didSelectResultWith user: User) {
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}
