//
//  Spacer.swift
//  SampleUIKit
//
//  Created by nobleidea on 2023/04/05.
//

import UIKit

public class Spacer: ContentSizeView {

    public init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        huggingPriority: UILayoutPriority = .defaultLow
    ) {
        super.init(frame: .zero, contentSize: CGSize(width: width ?? .zero, height: height ?? .zero))
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
        if width != nil {
            self.setContentHuggingPriority(huggingPriority, for: .horizontal)
            self.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        if height != nil {
            self.setContentHuggingPriority(huggingPriority, for: .vertical)
            self.setContentCompressionResistancePriority(.required, for: .vertical)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

public final class FixedSpacer: Spacer {

    public init(
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        super.init(width: width, height: height, huggingPriority: .required)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

public final class FlexibleSpacer: Spacer {

    public init(_ axis: NSLayoutConstraint.Axis) {
        switch axis {
        case .horizontal:
            super.init(width: 1, height: nil, huggingPriority: .init(1))
        case .vertical:
            super.init(width: nil, height: 1, huggingPriority: .init(1))
        @unknown default:
            assertionFailure()
            super.init(width: 1, height: nil, huggingPriority: .init(1))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

