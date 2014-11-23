//
//  Animator.swift
//
//  Created by areschoug on 20/11/14.
//

import Foundation

private let _animatorInstance = Animator()

class Animator:NSObject {
    
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
            if animationObjects.removeObject(object) {
                NSLog("did remove")
            }
        }
    }
}

