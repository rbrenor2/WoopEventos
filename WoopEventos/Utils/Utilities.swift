//
//  Utilities.swift
//  WoopEventos
//
//  Created by Breno Ramos on 22/12/21.
//

import UIKit
import SwiftIcons

class Utilities {
    func infoStack(withTitle titleLabel: UILabel, views: [UIView], direction: NSLayoutConstraint.Axis) -> UIStackView {
        let stackedViews = [titleLabel] + views
        let stack = UIStackView(arrangedSubviews: stackedViews)
        stack.axis = direction
        stack.spacing = 4
        
        return stack
    }
    
    func actionButton(withIcon icon: FontType, size: CGFloat, color: UIColor) -> UIButton {
        
        let button = UIButton(type: .system)
        button.setIcon(icon: icon, iconSize: size - 10, color: color, forState: .normal)
        button.setDimensions(width: size, height: size)
        button.layer.cornerRadius = size/2
        return button
        
    }
}
