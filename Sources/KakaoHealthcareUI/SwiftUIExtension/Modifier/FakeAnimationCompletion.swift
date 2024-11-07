//
//  FakeAnimationCompletion.swift
//  UIExtension
//
//  Created by kyle.cha on 2/27/24.
//  Copyright © 2024 Kakao Healthcare Corp. All rights reserved.
//

import SwiftUI

private struct CompletionPreferenceKey: PreferenceKey {
	typealias Value = CGFloat
	static let defaultValue: CGFloat = 0

	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}

private struct CompletionModifier: AnimatableModifier {
	var progress: CGFloat = 0

	var animatableData: CGFloat {
		get { progress }
		set { progress = newValue }
	}

	func body(content: Content) -> some View {
		content
			.preference(key: CompletionPreferenceKey.self, value: progress)
	}
}

private final class Catcher {
	var animation: Animation?
	var disablesAnimations: Bool = false
}

private func getDuration(from animation: Animation) -> Double {
	fatalError("TODO")
}

extension View {
	public func onCompletion(
		condition: Bool,
		_ completion: @escaping () -> Void
	) -> some View {
		let catcher = Catcher()
		var completed = false
		return self
			.transaction { transaction in
				// Restore the transaction values
				transaction.animation = catcher.animation
				transaction.disablesAnimations = catcher.disablesAnimations
			}
			.modifier(CompletionModifier(progress: condition ? 1 : 0))
			.transaction { transaction in
				// Catch transaction value before modification
				catcher.animation = transaction.animation
				catcher.disablesAnimations = transaction.disablesAnimations
//        if let animation = transaction.animation {
//          let duration = _getDuration(from: animation)
//          transaction.animation = .linear(duration: duration)
//        }
			}
			.onPreferenceChange(CompletionPreferenceKey.self) { progress in
				if completed == false && progress >= 1 {
					completed = true
					completion()
				}
			}
	}
}
