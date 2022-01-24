//
//  SettingsModels.swift
//  A-List
//
//  Created by Norman Yuan on 11/28/21.
//  Copyright © 2021 A-List. All rights reserved.
//

import Foundation
import UIKit

struct SettingsSection {
    let title: String
    let options: [SettingOption]
}

struct SettingOption {
    let title: String
    let image: UIImage?
    let color: UIColor
    let handler: (() -> Void)
}
