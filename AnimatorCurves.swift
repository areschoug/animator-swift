//
//  AnimatorCurves.swift
//
//  Created by areschoug on 20/11/14.
//

import Foundation

class AnimatorInterpolatorBackOut: AnimatorInterpolator {
    
    init() {
        super.init()
        self.interpolatorBlock = {t in
            let s:Float = 1.70158;
            let ft = t-1.0
            var done = (ft * ft * ((s+1.0)*ft + s) + 1.0);
            return done
        }
    }
    
    
}
