//
//  AnimatorInterpolator.swift
//
//  Created by areschoug on 23/11/14.
//

import Foundation

class AnimatorInterpolator {
    
    var interpolatorBlock:((progress:Float) -> Float)
    
    init(block interpolatorBlock:((progress:Float) -> Float) = {value in return value}){
        self.interpolatorBlock = interpolatorBlock
    }
    
    func valueForProgress(progress:Float) -> Float{
        return self.interpolatorBlock(progress: progress)
    }
    
}
