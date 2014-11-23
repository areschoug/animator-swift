//
//  AnimatorObject.swift
//
//  Created by areschoug on 23/11/14.
//

import Foundation

class AnimatorObject:Equatable {
    
    var randomId:UInt32
    var progress:Float
    var duration:Float
    var delay:Float
    var interpolator:AnimatorInterpolator
    var updateBlock:((progress:Float) -> Void)
    var completeBlock:((completed:Bool) -> Void)
    
    var started:Bool = false
    var completed:Bool = false
    var paused:Bool = false
    
    var afterAnimations:[AnimatorObject] = [AnimatorObject]()
    
    init(duration:Float = 0.0,
        delay:Float = 0.0,
        interpolator:AnimatorInterpolator = AnimatorInterpolator(),
        updateBlock:((progress:Float) -> Void) = {value in },
        completionBlock:((completed:Bool) -> Void) = {value in }){
            
            self.randomId = arc4random()
            self.progress = 0
            self.delay = delay
            self.duration = duration
            self.interpolator = interpolator
            self.updateBlock = updateBlock
            self.completeBlock = completionBlock
            
    }
    
    func addProgress(add:Float){
        if paused { return }
        
        self.progress += add
        
        let progress = self.progress - delay;
        
        if progress > self.duration {
            self.updateBlock(progress: 1.0)
            self.completed = true
            self.completeBlock(completed: self.completed)
            for object in afterAnimations {
                object.start()
            }
        } else if progress > 0 {
            self.updateBlock(progress: self.interpolator.valueForProgress(progress/self.duration))
        }
    }
    
    
    
    func interpolator(block:((progress:Float) -> Float)) -> AnimatorObject{
        self.interpolator = AnimatorInterpolator(block: block)
        return self
    }
    
    func interpolator(interpolator:AnimatorInterpolator) -> AnimatorObject{
        self.interpolator = interpolator
        return self
    }
    
    func delay(delay:Float) -> AnimatorObject {
        self.delay = delay
        return self
    }
    
    func duration(duration:Float) -> AnimatorObject {
        self.duration = duration
        return self
    }
    
    func completionBlock(block:((completed:Bool) -> Void)) -> AnimatorObject {
        return self.completion(block)
    }
    
    func completion(block:((completed:Bool) -> Void)) -> AnimatorObject {
        self.completeBlock = block
        return self
    }
    
    func updateBlock(block:((progress:Float) -> Void)) -> AnimatorObject {
        return self.update(block)
    }
    
    func update(block:((progress:Float) -> Void)) -> AnimatorObject {
        self.updateBlock = block
        return self
    }
    
    func appendAnimationAfter(object:AnimatorObject) -> AnimatorObject {
        if !completed {
            afterAnimations.append(object)
        }
        
        return self
    }
    
    func start(){
        if started { self.paused = false}
        else { Animator.addAnimatorObject(self) }
        
    }
    
    func stop(){
        Animator.removeAnimatorObject(self)
    }
    
    func pause(){
        self.paused = true
    }
    
}

func ==(first: AnimatorObject, second: AnimatorObject) -> Bool{
    return first.randomId == second.randomId
}
