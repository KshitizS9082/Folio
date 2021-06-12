//
//  GradientExtension.swift
//  Folio
//
//  Created by Kshitiz Sharma on 03/12/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation


import Foundation
import UIKit

extension UIView {
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
