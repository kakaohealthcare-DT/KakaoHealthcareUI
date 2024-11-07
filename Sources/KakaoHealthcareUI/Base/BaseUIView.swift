//
//  BaseView.swift
//  SampleUIKit
//
//  Created by nobleidea on 2023/04/02.
//

import UIKit

open class BaseUIView: UIView {

    required public init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        setUserInterface()
        bind()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func setUserInterface() {}
    open func bind() {}
}
