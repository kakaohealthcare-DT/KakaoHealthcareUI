//
//  ViewFactory.swift
//  SampleUIKit
//
//  Created by nobleidea on 2023/04/05.
//

import UIKit

public enum ViewFactory {

    public static func label() -> UILabel {
        UILabel()
    }

    public static func button(
        type: UIButton.ButtonType = .custom
    ) -> UIButton {
        UIButton(type: type)
    }

    public static func imageView(_ image: UIImage?) -> UIImageView {
        UIImageView(image: image)
    }

    public static func view() -> UIView {
        UIView()
    }

    public static func shapeLayer() -> CAShapeLayer {
        CAShapeLayer()
    }

    public static func bezierPath() -> UIBezierPath {
        UIBezierPath()
    }

    public static func scrollView() -> UIScrollView {
        UIScrollView()
    }

    public static func segmentedControl(items: [String]) -> UISegmentedControl {
        UISegmentedControl(items: items)
    }

    public static func gradientLayer() -> CAGradientLayer {
        CAGradientLayer()
    }

    public static func collectionView(frame: CGRect, collectionViewLayout: UICollectionViewLayout) -> UICollectionView {
        UICollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
    }

    public static func searchBar(frame: CGRect) -> UISearchBar {
        UISearchBar(frame: frame)
    }

    public static func pickerView(frame: CGRect) -> UIPickerView {
        UIPickerView(frame: frame)
    }
}
