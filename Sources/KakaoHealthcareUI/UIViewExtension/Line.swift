//
//  Line.swift
//  SampleUIKit
//
//  Created by nobleidea on 2023/04/05.
//

import UIKit

final class Line: ContentSizeView {

    init(_ axis: NSLayoutConstraint.Axis, size: CGFloat, color: UIColor) {
        switch axis {
        case .horizontal:
            super.init(frame: .zero, contentSize: CGSize(width: UIView.noIntrinsicMetric, height: size))
            setContentHuggingPriority(.required, for: .vertical)
        case .vertical:
            super.init(frame: .zero, contentSize: CGSize(width: size, height: UIView.noIntrinsicMetric))
            setContentHuggingPriority(.required, for: .horizontal)
        @unknown default:
            assertionFailure()
            super.init(frame: .zero, contentSize: CGSize(width: UIView.noIntrinsicMetric, height: size))
        }
        backgroundColor = color
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
