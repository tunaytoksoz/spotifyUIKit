//
//  Factories.swift
//  SpotifyUIKit
//
//  Created by Tunay Toksöz on 14.04.2023.
//

import Foundation
import UIKit

extension UIColor {
    static let spotifyGreen = UIColor(red: 30 / 355, green: 215 / 255, blue: 96 / 255, alpha: 1.0)
    static let spotifyBlack = UIColor(red: 12 / 355, green: 12 / 255, blue: 12 / 255, alpha: 1.0)
}


func makeLabel(withTitle title: String) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = title
    label.textAlignment = .center
    label.textColor = .black
    label.numberOfLines = 0
    label.adjustsFontSizeToFitWidth = true
    
    return label
}

func makeStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = axis
    stack.spacing = 8.0
    
    return stack
}
