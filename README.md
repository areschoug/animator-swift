animator-swift
==============

`THIS IS WORK IN PROGRESS`

##Usage

#####Simple
```swift 
AnimatorObject().duration(0.3).delay(0.2).update({ (progress) -> Void in //animation progress 0 -> 1
    let scale = CGFloat(progress + 1)
    view.transform = CGAffineTransformMakeScale(scale, scale)
}).completion({ (completed) -> Void in //If stopped completed will be false eles true
    //yay animation is done
}).start()
```

#####Chain animations
```swift 

//setup first animation
let firstAnimation = AnimatorObject().duration(0.3).update({ progress in
    let scale = CGFloat(progress)
    view.transform = CGAffineTransformMakeScale(scale, scale)
})

//setup second animation
let secondAnimation = AnimatorObject().duration(0.3).update({ progress in
    let scale = CGFloat(1.0 - progress)
    view.transform = CGAffineTransformMakeScale(scale, scale)
})

//append secondAnimation to firstAnimation
firstAnimation.appendAnimationAfter(secondAnimation)

//secondAnimation will automatically start when firstAnimation is completed
firstAnimation.start()
```

#####Easings

```swift 
//setup first animation
AnimatorObject().duration(0.3).update({ progress in
    let scale = CGFloat(progress) //progress is the interplated value
    view.transform = CGAffineTransformMakeScale(scale, scale)
}).interpolator(AnimatorInterpolatorBackOut()).start()
```

`AnimatorInterpolatorEasings.swift` needs more easing curves

#####Custom easing

```swift 
AnimatorObject().duration(0.3).update({ progress in
  let scale = CGFloat(progress) //progress is the interplated value
  view.transform = CGAffineTransformMakeScale(scale, scale)
}).interpolator({ progress -> Float in //progress is linear between 0 -> 1
  //do cool easing math here
  return progress //return value should start on 0 and end on 1
}).start()
```

#####Start/stop/pause

```swift 
self.animatorObject = AnimatorObject().duration(3).update({ progress in
  let scale = CGFloat(progress)
  view.transform = CGAffineTransformMakeScale(scale, scale)
})

// Start the animation, if paused it resumes it
self.animatorObject.start()

// Stops the animation and progress get reseted, completion block gets called with completed false
self.animatorObject.stop()

// Pauses the animation with current progress
self.animatorObject.pause()

```

## License

MIT License. See the LICENSE file for more info.
