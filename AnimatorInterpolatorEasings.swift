//
//  AnimatorCurves.swift
//
//  Created by areschoug on 20/11/14.
//

//Math in swift... Sigh...
//This can't be the best way of doing this
//All easings might not work :)

import Foundation
import Darwin

class AnimatorInterpolatorBackOut: AnimatorInterpolator {
	init(factor:Float = 1.70158) {
		super.init()
		self.interpolatorBlock = {t in
			let s:Float = factor
			let ft = t-1.0
			let done = (ft * ft * ((s+1.0)*ft + s) + 1.0)
			return done
		}
	}
}

class AnimatorInterpolatorBackIn: AnimatorInterpolator {
    init(factor:Float = 1.70158) {
        super.init()
        self.interpolatorBlock = {t in
            let s:Float = factor
            return t*t*((s+1)*t - s)
        }
    }
}

class AnimatorInterpolatorBackInOut: AnimatorInterpolator {
    init() {
        super.init()
        self.interpolatorBlock = {t in

			let p = t

			if(p < 0.5) {
				let f:Float = 2 * p;
				return 0.5 * (f * f * f - f * sin(f * Float(M_PI)))
			}
			else
			{
				let f:Float = (1 - (2*p - 1));
				return 0.5 * (1 - (f * f * f - f * sin(f * Float(M_PI)))) + 0.5;
			}
        }
    }
}

class AnimatorInterpolatorSineIn: AnimatorInterpolator {
    init() {
        super.init()
        self.interpolatorBlock = {t in
            let ct = CDouble(t)
            let value = Float(cos(ct * (M_PI / 2.0)))
            return -1.0 * value + 1.0
        }
    }
}

class AnimatorInterpolatorSineOut: AnimatorInterpolator {
    init() {
        super.init()
        self.interpolatorBlock = {t in
            let ct = CDouble(t)
            let value = Float(sin(ct * (M_PI / 2.0)))
            return value
        }
    }
}

class AnimatorInterpolatorSineInOut: AnimatorInterpolator {
    init() {
        super.init()
        self.interpolatorBlock = {t in
            let ct = CDouble(t)
            let value = Float(cos(M_PI * ct))
            return -0.5 * (value - 1.0)
        }
    }
}


class AnimatorInterpolatorQuadraticIn: AnimatorInterpolator {
    init() {
        super.init()
        self.interpolatorBlock = {t in
            return t * t
        }
    }
}

class AnimatorInterpolatorQuadraticOut: AnimatorInterpolator {
    init() {
        super.init()
        self.interpolatorBlock = {t in
            return t * (2.0 - t)
        }
    }
}

class AnimatorInterpolatorQuadraticInOut: AnimatorInterpolator {
    init() {
        super.init()
        self.interpolatorBlock = {t in
            let ft = (t * 2.0)
            if (ft < 1.0){
                return 0.5 * ft * ft
            } else {
                let ftx = ft - 1
                return -0.5 * ((ftx) * (ftx - 2.0) - 1.0)
            }
        }
    }
}

class AnimatorInterpolatorQuarticIn: AnimatorInterpolator {
    init() {
        super.init()
        self.interpolatorBlock = {t in
            return t * t * t * t
        }
    }
}

class AnimatorInterpolatorQuarticOut: AnimatorInterpolator {
    init() {
        super.init()
        self.interpolatorBlock = {t in
            let ft = t - 1.0
            return -1.0 * (ft * ft * ft * ft - 1.0)
        }
    }
}

class AnimatorInterpolatorQuarticInOut: AnimatorInterpolator {
    init() {
        super.init()
        self.interpolatorBlock = {t in
            let ft = (t * 2.0)
            if (ft < 1.0) {
                return 0.5 * ft  * ft * ft * ft
            } else {
                let ftx = (ft * 2.0)
                return -0.5 * (ftx  * ftx * ftx * ftx + 2)
            }
        }
    }
}

class AnimatorInterpolatorQuinticIn: AnimatorInterpolator {
    init() {
        super.init()
        self.interpolatorBlock = {t in
            return t * t * t * t * t
        }
    }
}

class AnimatorInterpolatorQuinticOut: AnimatorInterpolator {
    init() {
        super.init()
        self.interpolatorBlock = {t in
            let ft = (t - 1.0)
            return (ft * ft * ft * ft * ft + 1.0)
        }
    }
}

class AnimatorInterpolatorQuinticInOut: AnimatorInterpolator {
    init() {
        super.init()
        self.interpolatorBlock = {t in
            let ft = (t * 2.0)
            if (ft < 1.0) {
                return 0.5 * ft * ft * ft * ft * ft
            } else {
                let ftx = (ft * 2.0)
                return 0.5 * (ftx * ftx * ftx * ftx * ftx + 2)
            }
        }
    }
}


