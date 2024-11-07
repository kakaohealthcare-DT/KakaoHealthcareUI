//
//  UINavigationController+Extension.swift
//  import KakaoHealthcareFoundation
//
//  Created by bryn on 11/29/23.
//  Copyright © 2023 Kakao Healthcare Corp. All rights reserved.
//

import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    viewControllers.count > 1
  }
}
