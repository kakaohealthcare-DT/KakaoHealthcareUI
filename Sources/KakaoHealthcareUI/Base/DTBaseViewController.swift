//
//  DTBaseViewController.swift
//  DTUIKit
//
//  Created by kyle.cha on 2023/04/17.
//  Copyright © 2023 Kakao Healthcare Corp. All rights reserved.
//

import UIKit
import KakaoHealthcareFoundation
import Combine

open class DTBaseViewController: UIViewController {
	private weak var previousDelegate: UIGestureRecognizerDelegate?
	private var previousSwipeBackEnabled: Bool?
	
	open var subscription = Set<AnyCancellable>()
	deinit {
		Logger.debug("\(Self.self)")
	}
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		setUserInterface()
		bind()
	}
	
	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setNavigationPopDisable()
	}
	
	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		unsetNavigaionPopDisable()
	}
	
	open func setUserInterface() {}
	open func bind() {}

	override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		updateFont(category: previousTraitCollection?.preferredContentSizeCategory)
	}
	/// This method is for handling with font's content size, when it comes to accessibility
	open func updateFont(category: UIContentSizeCategory? = nil) { }
}

/// Navigation Disable Back
private extension DTBaseViewController {
	private func setNavigationPopDisable() {
		guard self is NavigationPopDisable else { return }
		if let previousDelegate = navigationController?.interactivePopGestureRecognizer?.delegate {
			self.previousDelegate = previousDelegate
		}
		if let previousIsEnabled = navigationController?.interactivePopGestureRecognizer?.isEnabled {
			self.previousSwipeBackEnabled = previousIsEnabled
		}
		navigationController?.interactivePopGestureRecognizer?.delegate = nil
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
		
	}
	
	private func unsetNavigaionPopDisable() {
		guard self is NavigationPopDisable else { return }
		if let previousDelegate {
			navigationController?.interactivePopGestureRecognizer?.delegate = previousDelegate
		}
		
		if let previousSwipeBackEnabled {
			navigationController?.interactivePopGestureRecognizer?.isEnabled = previousSwipeBackEnabled
		}
	}
}
