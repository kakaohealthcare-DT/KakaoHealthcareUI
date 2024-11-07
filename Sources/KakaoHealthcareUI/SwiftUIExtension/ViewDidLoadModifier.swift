//
//  ViewDidLoadModifier.swift
//  UIExtension
//
//  Created by bryn on 5/22/24.
//  Copyright © 2024 Kakao Healthcare Corp. All rights reserved.
//

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {
	@State var didLoad: Bool = false
	private let action: (() -> Void)?
	
	init(action: (() -> Void)? = nil) {
		self.action = action
	}
	
	func body(content: Content) -> some View {
		content
			.onAppear {
				if didLoad { return }
				action?()
				didLoad = true
			}
	}
}
