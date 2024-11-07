//
//  View+Extension.swift
//  UIExtension
//
//  Created by bryn on 11/20/23.
//  Copyright © 2023 Kakao Healthcare Corp. All rights reserved.
//

import SwiftUI
import Combine

public extension View {
	func flipped() -> some View {
		self.rotationEffect(.radians(Double.pi))
			.scaleEffect(x: -1, y: 1, anchor: .center)
	}
	
	func boxShadow(color: Color = .black.opacity(0.04)) -> some View {
		self.shadow(color: color, radius: 16, x: 0, y: 4)
	}
	
	func roundedRectangleStroke(cornerRadius: CGFloat, color: Color, lineWidth: CGFloat = 1) -> some View {
		self
			.overlay(
				RoundedRectangle(cornerRadius: cornerRadius)
					.stroke(color, lineWidth: lineWidth)
					.foregroundColor(.clear)
			)
			.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
	}
	
	@ViewBuilder
	func `if`<Content: View>(
		_ condition: @autoclosure () -> Bool,
		transform: (Self) -> Content
	) -> some View {
		if condition() {
			transform(self)
		} else {
			self
		}
	}
	
	@ViewBuilder
	func `if`<Modifier: ViewModifier>(
		_ condition: @autoclosure () -> Bool,
		modifier: () -> Modifier
	) -> some View {
		if condition() {
			self
				.modifier(modifier())
		} else {
			self
		}
	}
	
	@ViewBuilder
	func unwrap<Content: View, T>(
		_ value: T?,
		@ViewBuilder transform: (T, Self) -> Content
	) -> some View {
		if let unwrap = value {
			transform(unwrap, self)
		} else {
			self
		}
	}
	
	func gradientBackground(
		foregroundColor: Color
	) -> some View {
		self.modifier(GradientBackgroundModifier(foregroundColor: foregroundColor))
	}
	
	func makeModalBackground(
		backgroundTapEnable: Bool = true,
		dismissTrigger: Binding<Bool>
	) -> some View {
		self.modifier(
			ModalBackgroundModifier(
				isBackgroundTapEnable: backgroundTapEnable,
				dismissTrigger: dismissTrigger
			)
		)
	}
	
	func sheet<Item: Identifiable, Content: View>(item: Binding<Item?>, @ViewBuilder sheetView: @escaping (Item) -> Content) -> some View {
		self
			.background(
				SheetProvider(item: item, sheetView: sheetView)
			)
	}
	
	func loading(_ isLoading: Bool) -> some View {
		self
			.overlay(
				Color.white
					.opacity(isLoading ? 0.5 : 0)
			)
			.allowsHitTesting(!isLoading)
			.overlay(
				ProgressView()
					.controlSize(.large)
					.opacity(isLoading ? 1 : 0)
			)
	}
	
	func viewDidLoad(perform action: (() -> Void)? = nil) -> some View {
		self
			.modifier(ViewDidLoadModifier(action: action))
	}
}
