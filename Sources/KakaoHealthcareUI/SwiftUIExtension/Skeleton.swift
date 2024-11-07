//
//  Skeleton.swift
//  SampleUIKit
//
//  Created by kyle.cha on 2023/09/20.
//

import SwiftUI

public struct SkeletonView<ShapeType: Shape>: View {
	@State private var animationPosition: CGFloat = -1
	
	let shape: ShapeType
	let animation: Animation
	let gradient: Gradient
	
	public init(shape: ShapeType, animation: Animation, gradient: Gradient) {
		self.shape = shape
		self.gradient = gradient
		self.animation = animation
	}
	
	public var body: some View {
		shape
			.fill(self.gradientFill())
			.onAppear {
				withAnimation(self.animation) {
					self.animationPosition = 2
				}
			}
	}
	
	private func gradientFill() -> LinearGradient {
		LinearGradient(
			gradient: gradient,
			startPoint: .init(x: self.animationPosition - 1, y: self.animationPosition - 1),
			endPoint: .init(x: self.animationPosition + 1, y: self.animationPosition + 1)
		)
	}
}

public extension View {
	func skeleton(with: Bool) -> some View {
		self.skeleton(with: with, shape: Rectangle())
	}
	
	func skeleton(
		with: Bool,
		gradient: Gradient
	) -> some View {
		self.skeleton(with: with, shape: Rectangle(), gradient: gradient)
	}
	
	func skeleton<ShapeType: Shape>(
		with: Bool,
		shape: ShapeType,
		animation: Animation = Animation.easeInOut(duration: 3).repeatForever(autoreverses: false),
		gradient: Gradient = Gradient(colors: [.gray.opacity(0.1), .white.opacity(0.5), .gray.opacity(0.1)])
	) -> some View {
		self.modifier(SkeletonModifier(loading: with, shape: shape, animation: animation, gradient: gradient))
	}
}

public struct SkeletonModifier: ViewModifier {
	let loading: Bool
	let overlayView: AnyView
	
	public init<ShapeType: Shape>(loading: Bool, shape: ShapeType, animation: Animation, gradient: Gradient) {
		self.loading = loading
		overlayView = AnyView(SkeletonView(shape: shape, animation: animation, gradient: gradient))
	}
	
	public func body(content: Content) -> some View {
		Group {
			if loading {
				content
					.overlay(overlayView)
					.transition(.opacity)
			} else {
				content
					.transition(.opacity)
			}
		}
	}
}
