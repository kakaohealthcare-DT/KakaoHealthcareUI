//
//  SetNeedsLayout.swift
//  SampleUIKit
//
//  Created by nobleidea on 2023/04/05.
//

import UIKit

public struct InvalidationOptions: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let display = InvalidationOptions(rawValue: 1 << 0)
    public static let layout = InvalidationOptions(rawValue: 1 << 1)
}

@propertyWrapper
public final class SetNeeds<Value> where Value: Equatable {
    public typealias ViewType = UIView

    private var stored: Value
    private let invalidationOptions: InvalidationOptions

    public static subscript<EnclosingSelf>(
        _enclosingInstance observed: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, SetNeeds>
    ) -> Value where EnclosingSelf: ViewType {
        get {
            observed[keyPath: storageKeyPath].stored
        }
        set {
            let oldValue = observed[keyPath: storageKeyPath].stored

            if newValue != oldValue {
                observed[keyPath: storageKeyPath].stored = newValue

                let invalidationOptions = observed[keyPath: storageKeyPath].invalidationOptions

                if invalidationOptions.contains(.display) {
                    observed.setNeedsDisplay()
                }

                if invalidationOptions.contains(.layout) {
                    observed.setNeedsLayout()
                }
            }
        }
    }

    public var wrappedValue: Value {
        stored
    }

    public init(wrappedValue: Value, _ invalidationOptions: InvalidationOptions...) {
        self.stored = wrappedValue
        self.invalidationOptions = invalidationOptions.reduce(into: []) { $0.insert($1) }
    }

    public init(wrappedValue: Value, _ invalidationOptions: InvalidationOptions) {
        self.stored = wrappedValue
        self.invalidationOptions = invalidationOptions
    }
}
