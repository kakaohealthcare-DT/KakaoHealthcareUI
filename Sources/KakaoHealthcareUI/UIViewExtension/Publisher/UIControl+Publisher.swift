import UIKit

public extension UIControl {
	func publisher(for event: UIControl.Event, haptic: Haptic? = nil) -> ControlPublisher<UIControl> {
		ControlPublisher(self, event, haptic)
	}
	
	var tapPublisher: ControlPublisher<UIControl> {
		publisher(for: .touchUpInside)
	}
}
