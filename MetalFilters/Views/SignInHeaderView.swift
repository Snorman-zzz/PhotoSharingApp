//
//  SinginHeaderView.swift
//  A-List
//
//  Created by Norman Yuan on 11/15/21.
//  Copyright © 2021 A-List. All rights reserved.
//

import UIKit

class SignInHeaderView: UIView {
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "7")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var gradientLayer: CALayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        createGradient()
        addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func createGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPink.cgColor]
        layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = layer.bounds
        imageView.frame = CGRect(x: 20, y: 20, width: width-40, height: height-40)

        
    }
}
