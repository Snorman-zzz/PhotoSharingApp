//
//  MainViewController.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/9.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import Photos
import Metal
import MetalKit

class MainViewController: UIViewController {
    
    fileprivate var scrollView: MTScrollView!
    fileprivate var selectedAsset: PHAsset?
    
    fileprivate var albumController: AlbumPhotoViewController?
    
    private let photoView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let albumView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(photoView)
        view.addSubview(albumView)

        setupScrollView()
        requestPhoto()
        test()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "继续", style: .done, target: self, action: #selector(nextButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(didTapClose))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func test() {
        
    }
    
    @objc func didTapClose() {
        tabBarController?.selectedIndex = 0
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        albumView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: view.height)
        photoView.frame = CGRect(
            x: 0,
            y: albumView.bottom,
            width: view.width,
            height: view.width)
    }
    
    private func setupScrollView() {
        scrollView = MTScrollView(frame: photoView.bounds)
        photoView.addSubview(scrollView)
    }
    
    fileprivate func requestPhoto() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    PHPhotoLibrary.shared().register(self)
                    self.loadPhotos()
                }
                break
            case .notDetermined:
                break
            default:
                break
            }
        }
    }
    
    fileprivate func loadPhotos() {
        let options = PHFetchOptions()
        options.wantsIncrementalChangeDetails = false
        options.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false) ]
        let result = PHAsset.fetchAssets(with: .image, options: options)
        if let firstAsset = result.firstObject {
            loadImageFor(firstAsset)
        }
        
        if let controller = albumController {
            controller.update(dataSource: result)
        } else {
            let albumController = AlbumPhotoViewController(dataSource: result)
            albumController.didSelectAssetHandler = { [weak self] selectedAsset in
                self?.loadImageFor(selectedAsset)
            }
            albumController.view.frame = albumView.bounds
            albumView.addSubview(albumController.view)
            addChild(albumController)
            albumController.didMove(toParent: self)
            self.albumController = albumController
        }
    }
    
    fileprivate func loadImageFor(_ asset: PHAsset) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = true
        let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .default, options: options) { (image, _) in
            DispatchQueue.main.async {
                self.scrollView.image = image
            }
        }
        selectedAsset = asset
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func nextButtonTapped() {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let editorController = mainStoryBoard.instantiateViewController(withIdentifier: "PhotoEditorViewController") as? PhotoEditorViewController else {
            return
        }
        editorController.croppedImage = scrollView.croppedImage
        
        navigationController?.pushViewController(editorController, animated: false)
    }
    
}

extension MainViewController: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.loadPhotos()
    }
}
