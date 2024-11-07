import Foundation
import UIKit

public enum Haptic {
	case impact(UIImpactFeedbackGenerator.FeedbackStyle)
	case notification(UINotificationFeedbackGenerator.FeedbackType)
	case selection
	
	/// trigger
	public func generate() {
		switch self {
		case .impact(let style):
			let generator = UIImpactFeedbackGenerator(style: style)
			generator.prepare()
			generator.impactOccurred()
		case .notification(let type):
			let generator = UINotificationFeedbackGenerator()
			generator.prepare()
			generator.notificationOccurred(type)
		case .selection:
			let generator = UISelectionFeedbackGenerator()
			generator.prepare()
			generator.selectionChanged()
		}
	}
	
	public static func generate(for target: HapticTarget) {
		switch target {
		case .pullToRefresh:
			Haptic.impact(.soft).generate()
		case .button:
			Haptic.impact(.light).generate()
		case .tab:
			Haptic.impact(.light).generate()
		case .longPressed:
			Haptic.impact(.medium).generate()
		}
	}
}

public enum HapticTarget {
	case pullToRefresh
	case button
	case tab
	case longPressed
}
