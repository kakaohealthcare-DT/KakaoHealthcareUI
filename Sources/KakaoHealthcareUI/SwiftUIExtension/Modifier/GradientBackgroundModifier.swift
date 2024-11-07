//
//  GradientBackgroundModifier.swift
//  UIExtension
//
//  Created by bryn on 1/12/24.
//  Copyright © 2024 Kakao Healthcare Corp. All rights reserved.
//

import SwiftUI

struct GradientBackgroundModifier: ViewModifier {
	
	private let foregroundColor: Color
	
	init(foregroundColor: Color) {
		self.foregroundColor = foregroundColor
	}
	
	func body(content: Content) -> some View {
		VStack(spacing: 0) {
			GradientView(foregroundColor)
				.frame(height: 16)
			
			content
				.padding(.horizontal, 16)
				.padding(.bottom, 16)
				.background(foregroundColor)
		}
	}
}
