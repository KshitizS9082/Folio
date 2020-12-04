//
//  ImageViewBlurExtension.swift
//  Folio
//
//  Created by Kshitiz Sharma on 30/11/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
}
extension UIView{
    func addBlurEffect(with style: UIBlurEffect.Style)
    {
        self.layer.masksToBounds=true
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
        self.sendSubviewToBack(blurEffectView)
    }
}
