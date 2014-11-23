//
//  Animator.swift
//  pod-ios
//
//  Created by areschoug on 20/11/14.
//  Copyright (c) 2014 areschoug. All rights reserved.
//

import Foundation

private let _animatorInstance = Animator()

class Animator:NSObject {
    
    private let fps:CGFloat = 1/60.0
    private var displayLink:CADisplayLink?
    private var animationObjects:[AnimatorObject] = [AnimatorObject]()
    
    override init(){
        super.init()
        self.displayLink = CADisplayLink(target: self, selector: Selector("update"))
        self.displayLink?.frameInterval = 1
        self.displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    
    }
    
    private class func sharedInstance() -> Animator{
        return _animatorInstance
    }

    class func addAnimatorObject(object:AnimatorObject){
        self.sharedInstance().addAnimatorObject(object)
    }
    
    func addAnimatorObject(object:AnimatorObject){
        object.started = true
        animationObjects.append(object)
    }

    class func removeAnimatorObject(object:AnimatorObject){
        self.sharedInstance().addAnimatorObject(object)
    }
    
    class func removeAllAnimations() {
        self.sharedInstance().animationObjects.removeAll(keepCapacity: false)
    }
    
    func removeAnimatorObject(object:AnimatorObject){
        if object.completed {
            object.completeBlock(completed: false)
            object.completed = true
        }
        animationObjects.removeObject(object)
    }
    
    func update(){
        
        var remove:[AnimatorObject] =  [AnimatorObject]()
        
        for object in animationObjects{
            object.addProgress(Float(self.displayLink!.duration))
            if object.completed {
                remove.append(object)
            }
        }
        
        for object in remove {
            object.completeBlock(completed: true)
            if animationObjects.removeObject(object){
                NSLog("did remove")
            }
        }

    }
    
}

class AnimatorInterpolator {
    
    var interpolatorBlock:((progress:Float) -> Float)
    
    init(block interpolatorBlock:((progress:Float) -> Float) = {value in return value}){
        self.interpolatorBlock = interpolatorBlock
    }
    
    func valueForProgress(progress:Float) -> Float{
        return self.interpolatorBlock(progress: progress)
    }
    
}

class AnimatorObject:Equatable {

    var randomId:UInt32
    var progress:Float
    var duration:Float
    var delay:Float
    var interpolator:AnimatorInterpolator
    var updateBlock:((progress:Float) -> Void)
    var completeBlock:((completed:Bool) -> Void)
    
    var started:Bool = false
    var completed:Bool = false {
        didSet {
            
            for object in afterAnimations {
                object.start()
            }
        }
    }
    var paused:Bool = false
    
    var afterAnimations:[AnimatorObject] = [AnimatorObject]()
    
    init(duration:Float = 0.0,
        delay:Float = 0.0,
        interpolator:AnimatorInterpolator = AnimatorInterpolator(),
        updateBlock:((progress:Float) -> Void) = {value in },
        completionBlock:((completed:Bool) -> Void) = {value in }){

            self.randomId = arc4random()
            self.progress = -delay
            self.delay = delay
            self.duration = duration
            self.interpolator = interpolator
            self.updateBlock = updateBlock
            self.completeBlock = completionBlock
        
    }
    
    func addProgress(add:Float){
        if paused { return }
        
        self.progress += add
        
        if self.progress > self.duration {
            self.updateBlock(progress: 1.0)
            self.completed = true
            self.completeBlock(completed: self.completed)
        
        } else if self.progress > 0 {
            self.updateBlock(progress: self.interpolator.valueForProgress(self.progress/self.duration))
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





