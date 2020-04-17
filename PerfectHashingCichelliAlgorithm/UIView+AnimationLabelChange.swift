//
//  UIView+AnimationLabelChange.swift
//  PerfectHashingCichelliAlgorithm
//
//  Created by Alperen Ünal on 24.11.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit

extension UIView {
    func pushTransition(_ duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
}
