//
//  ScrollDetectModifier.swift
//  Mcare
//
//  Created by kyle on 6/26/24.
//  Copyright © 2024 Kakao Healthcare Corp. All rights reserved.
//

import SwiftUI

public struct VerticalScrollDirectionDetector: ViewModifier {
	public enum Constant {
		public static let namespace = "ScrollDirectionDetector"
	}
	
	public enum Direction: Equatable {
		case up
		case down
	}
	
	@Binding var didScrollContent: Direction
	
	public init(didScrollContent: Binding<Direction>) {
		self._didScrollContent = didScrollContent
	}
	
	public func body(content: Content) -> some View {
		content
			.zIndex(.infinity)
			.overlay(GeometryReader { geometry in
				let currentFrame = geometry.frame(in: .named(Constant.namespace))
				
				Color.clear
					.onChange(of: currentFrame) {
						didScrollContent = $0.minY <= 0 ? .up : .down
					}
			})
	}
}
