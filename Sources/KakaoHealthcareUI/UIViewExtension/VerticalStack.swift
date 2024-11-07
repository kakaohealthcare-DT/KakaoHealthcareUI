//
//  VStack.swift
//  SampleUIKit
//
//  Created by nobleidea on 2023/04/05.
//

import UIKit

public final class VerticalStack: UIStackView {
  
  public init(@StackBuilder _ views: () -> [UIView]) {
    super.init(frame: .zero)
    axis = .vertical
    views().forEach { addArrangedSubview($0) }
    
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
  }
}
