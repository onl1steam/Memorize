//
//  ViewAnimations.swift
//  PlayingCard
//
//  Created by Рыжков Артем on 20.07.2020.
//  Copyright © 2020 rodzaevsky. All rights reserved.
//

import UIKit

class ViewAnimations {
    
    private enum SizeAnimationConstants {
        static var duration: TimeInterval = 0.2
        static var delay: TimeInterval = 0
        static var transformScale: CGFloat = 1.1
        static var initialScale: CGFloat = 1
    }
    
    static func zoomInOut(on view: UIView, completion: @escaping ((Bool) -> Void)) {
        zoomIn(on: view) { _ in
            zoomOut(on: view, completion: completion)
        }
    }
    
    private static func zoomIn(on view: UIView, completion: @escaping ((Bool) -> Void) ) {
        UIView.animate(
            withDuration: SizeAnimationConstants.duration,
            delay: SizeAnimationConstants.delay,
            options: [.curveEaseOut],
            animations: {
                view.transform = CGAffineTransform(
                    scaleX: SizeAnimationConstants.transformScale,
                    y: SizeAnimationConstants.transformScale)
            },
            completion: completion)
    }
    
    private static func zoomOut(on view: UIView, completion: @escaping ((Bool) -> Void)) {
        UIView.animate(
            withDuration: SizeAnimationConstants.duration,
            delay: SizeAnimationConstants.delay,
            options: [.curveEaseOut],
            animations: {
                view.transform = CGAffineTransform(
                    scaleX: SizeAnimationConstants.initialScale,
                    y: SizeAnimationConstants.initialScale)
            },
            completion: completion)
    }
}
