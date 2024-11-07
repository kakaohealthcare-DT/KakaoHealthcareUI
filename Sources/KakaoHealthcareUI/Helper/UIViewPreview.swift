//
//  UIViewPreview.swift
//  SampleUIKit
//
//  Created by nobleidea on 2023/04/02.
//

#if DEBUG
import SwiftUI

public struct UIViewPreview<View: UIView>: UIViewRepresentable {

    let view: View

    public init(_ build: @escaping () -> View) {
        view = build()
    }

    // MARK: - UIViewRepresentable

    public func makeUIView(context: Context) -> UIView {
        view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

public enum Device {
    case iPhone13
    case iPhone13mini
    case iPhone13Pro
    case iPhone13ProMax
    case iPhoneXR
    case iPhoneXS
    case iPhoneXSMax
    case iPhoneX
    case iPhone8
    case iPhone8Plus

    public var layout: PreviewLayout {
        switch self {
        case .iPhone13,
            .iPhone13Pro:
            return .fixed(width: 390, height: 844)
        case .iPhone13mini,
            .iPhoneXS,
            .iPhoneX:
            return .fixed(width: 375, height: 812)
        case .iPhone13ProMax:
            return .fixed(width: 428, height: 926)
        case .iPhoneXR,
            .iPhoneXSMax:
            return .fixed(width: 414, height: 896)
        case .iPhone8:
            return .fixed(width: 375, height: 667)
        case .iPhone8Plus:
            return .fixed(width: 414, height: 736)
        }
    }

    public var scale: CGFloat {
        switch self {
        case .iPhone13,
            .iPhone13mini,
            .iPhone13Pro,
            .iPhone13ProMax,
            .iPhoneXS,
            .iPhoneXSMax,
            .iPhoneX,
            .iPhone8Plus:
            return 3
        case .iPhoneXR,
            .iPhone8:
            return 2
        }
    }
}

#endif
