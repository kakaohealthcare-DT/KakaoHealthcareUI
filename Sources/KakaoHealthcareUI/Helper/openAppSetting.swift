//
//  openAppSetting.swift
//  UIExtension
//
//  Created by bryn on 2/26/24.
//  Copyright © 2024 Kakao Healthcare Corp. All rights reserved.
//

import SwiftUI

public extension UIApplication {
	static func openAppSetting() {
		if let bundleIdentifier = Bundle.main.bundleIdentifier,
			 let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
			if UIApplication.shared.canOpenURL(appSettings) {
				UIApplication.shared.open(appSettings)
			}
		}
	}
}
