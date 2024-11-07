import Foundation
import UIKit

public extension UITapGestureRecognizer {
	var tapPublisher: GesturePublisher<UITapGestureRecognizer> {
		GesturePublisher(gesture: self)
	}
}
