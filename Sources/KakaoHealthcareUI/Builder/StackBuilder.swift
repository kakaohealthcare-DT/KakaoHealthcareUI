//
//  StackBuilder.swift
//  SampleUIKit
//
//  Created by nobleidea on 2023/04/05.
//

import UIKit

@resultBuilder
public struct StackBuilder {

    public static func buildBlock(_ views: UIView...) -> [UIView] {
        views
    }

    public static func buildEither(first component: [UIView]) -> [UIView] {
        component
    }

    public static func buildEither(second component: [UIView]) -> [UIView] {
        component
    }

    public static func buildOptional(_ component: [UIView]?) -> [UIView] {
        guard let component = component else { return [] }
        return component
    }

    public static func buildExpression(_ expression: UIView) -> [UIView] {
        [expression]
    }

    public static func buildBlock(_ components: [UIView]...) -> [UIView] {
        components.flatMap { $0 }
    }
}
