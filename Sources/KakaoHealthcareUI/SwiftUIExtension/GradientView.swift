//
//  GradientView.swift
//  UIExtension
//
//  Created by bryn on 1/12/24.
//  Copyright © 2024 Kakao Healthcare Corp. All rights reserved.
//

import SwiftUI

public struct GradientView: View {
	
	private let foregroundColor: Color
	
	public init(_ foregroundColor: Color) {
		self.foregroundColor = foregroundColor
	}
	
	public var body: some View {
		Rectangle()
			.fill(
				LinearGradient(
					gradient: Gradient(colors: [foregroundColor, foregroundColor.opacity(0)]),
					startPoint: .bottom,
					endPoint: .top
				)
			)
	}
}
