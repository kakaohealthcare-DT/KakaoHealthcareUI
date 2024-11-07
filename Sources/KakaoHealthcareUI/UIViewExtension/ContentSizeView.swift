//
//  ContentSizeView.swift
//  SampleUIKit
//
//  Created by nobleidea on 2023/04/05.
//

import UIKit

public class ContentSizeView: UIView {

    var contentSize: CGSize? {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    init(frame: CGRect, contentSize: CGSize?) {
        super.init(frame: frame)
        self.contentSize = contentSize
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override var intrinsicContentSize: CGSize {
        contentSize ?? CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        intrinsicContentSize
    }
}
