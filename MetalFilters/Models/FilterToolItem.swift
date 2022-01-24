//
//  FilterToolItem.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/12.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

enum FilterControlType {
    case adjustStrength
    case edit(FilterEditType)
}

enum FilterEditType {
    case adjust
    case brightness
    case contrast
    case structure
    case warmth
    case saturation
    case color
    case fade
    case highlights
    case shadows
    case vignette
    case tiltShift
    case sharpen
    
    var title: String {
        switch self {
        case .adjust:
            return "调整"
        case .brightness:
            return "亮度"
        case .contrast:
            return "对比度"
        case .structure:
            return "结构"
        case .warmth:
            return "暖色调"
        case .saturation:
            return "饱和度"
        case .color:
            return "颜色"
        case .fade:
            return "淡化"
        case .highlights:
            return "高亮"
        case .shadows:
            return "光影"
        case .vignette:
            return "晕影"
        case .tiltShift:
            return "移轴"
        case .sharpen:
            return "锐度"

        }
    }
    
    var icon: String {
        switch self {
        case .adjust:
            return "icon-structure"
        case .brightness:
            return "icon-brightness"
        case .contrast:
            return "icon-contrast"
        case .structure:
            return "icon-structure"
        case .warmth:
            return "icon-warmth"
        case .saturation:
            return "icon-saturation"
        case .color:
            return "icon-color"
        case .fade:
            return "icon-fade"
        case .highlights:
            return "icon-highlights"
        case .shadows:
            return "icon-shadows"
        case .vignette:
            return "icon-vignette"
        case .tiltShift:
            return "icon-tilt-shift"
        case .sharpen:
            return "icon-sharpen"
        }
    }
}

enum FilterToolType {
    case adjustStrength
    case adjust
    case brightness
    case contrast
    case structure
    case warmth
    case saturation
    case color
    case fade
    case highlights
    case shadows
    case vignette
    case tiltShift
    case sharpen
    
    
}

struct FilterToolItem {
    
    let type: FilterToolType
    
    let slider: SliderValueRange
    
    var title: String {
        switch type {
        case .adjustStrength:
            return ""
        case .adjust:
            return "调整"
        case .brightness:
            return "亮度"
        case .contrast:
            return "对比度"
        case .structure:
            return "结构"
        case .warmth:
            return "暖色调"
        case .saturation:
            return "饱和度"
        case .color:
            return "颜色"
        case .fade:
            return "淡化"
        case .highlights:
            return "高亮"
        case .shadows:
            return "光影"
        case .vignette:
            return "晕影"
        case .tiltShift:
            return "移轴"
        case .sharpen:
            return "锐度"
        }
    }
    
    var icon: String {
        switch type {
        case .adjustStrength:
            return ""
        case .adjust:
            return "icon-structure"
        case .brightness:
            return "icon-brightness"
        case .contrast:
            return "icon-contrast"
        case .structure:
            return "icon-structure"
        case .warmth:
            return "icon-warmth"
        case .saturation:
            return "icon-saturation"
        case .color:
            return "icon-color"
        case .fade:
            return "icon-fade"
        case .highlights:
            return "icon-highlights"
        case .shadows:
            return "icon-shadows"
        case .vignette:
            return "icon-vignette"
        case .tiltShift:
            return "icon-tilt-shift"
        case .sharpen:
            return "icon-sharpen"
        }
    }
}
