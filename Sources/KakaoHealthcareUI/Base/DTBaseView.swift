//
//  DTBaseView.swift
//  DTUIKit
//
//  Created by kyle.cha on 2023/04/17.
//  Copyright © 2023 Kakao Healthcare Corp. All rights reserved.
//

import UIKit
import KakaoHealthcareFoundation

open class DTBaseView: UIView {
	deinit {
		Logger.debug("\(Self.self)")
	}
	
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
	
	override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		updateFont(category: previousTraitCollection?.preferredContentSizeCategory)
	}
	
	open func updateFont(category: UIContentSizeCategory? = nil) { }
	
}
