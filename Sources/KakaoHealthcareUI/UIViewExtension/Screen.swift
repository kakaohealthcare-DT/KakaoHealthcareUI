//
//  Screen.swift
//  UIExtension
//
//  Created by bryn on 1/19/24.
//  Copyright © 2024 Kakao Healthcare Corp. All rights reserved.
//

import UIKit

public enum Screen {
	public static let size = UIScreen.main.bounds.size
	public static let safeAreaInsets: UIEdgeInsets = UIApplication.shared.representedKeyWindow?.safeAreaInsets ?? .zero
}
