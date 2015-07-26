//
//  AloeTween.swift
//  swiftLib
//
//  Created by kawase yu on 2014/09/15.
//  Copyright (c) 2014年 marimo. All rights reserved.
//

import Foundation
import QuartzCore


func mainThread(block: () -> ()) {
    dispatch_async(dispatch_get_main_queue(), block)
}

func subThread(block: () -> ()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
}

typealias AloeTweenProgressCallback = (val:CGFloat)->()
typealias AloeTweenCompleteCallback = ()->()

private var aloeTweenTimer:NSTimer?
private var tweenList:[AloeTween.AloeTweenObject] = []
private let lock:NSObject = NSObject()
private var hasTimer:Bool = false

class AloeTween{
    
    // MARK: public
    
    // メイン
    class func doTween(duration:Double, ease:AloeEase, progress:AloeTweenProgressCallback)->AloeTweenObject{
        self.rock()
        
        if(!hasTimer){
            hasTimer = true
            let fps:Double = 60.0;
            mainThread({ () -> () in
                aloeTweenTimer = NSTimer(timeInterval: 1.0/fps, target: self, selector: "updateAnimations", userInfo: nil, repeats: true)
                NSRunLoop.currentRunLoop().addTimer(aloeTweenTimer!, forMode: NSRunLoopCommonModes)
            })
        }
        
        let obj:AloeTweenObject = AloeTweenObject(duration: duration, ease: ease, progressCallback: progress)
        tweenList.append(obj)
        
        self.unRock()
        
        return obj
    }
    
    // ショートカット
    class func doTween(duration:Double, ease:AloeEase
        , progress:AloeTweenProgressCallback, complete:AloeTweenCompleteCallback)->AloeTweenObject{
            let obj:AloeTweenObject = AloeTween.doTween(duration, ease: ease, progress: progress)
            obj.completeCallback = complete
            return obj
    }
    
    // ショートカット
    class func doTween(duration:Double, startValue:Double, endValue:Double, ease:AloeEase, progress:AloeTweenProgressCallback)->AloeTweenObject{
        let obj:AloeTweenObject = self.doTween(duration, ease: ease, progress: progress)
        obj.startValue = startValue
        obj.endValue = endValue
        
        return obj
    }
    
    // ショートカット
    class func doTween(duration:Double, startValue:Double, endValue:Double, ease:AloeEase
        , progress:AloeTweenProgressCallback, complete:AloeTweenCompleteCallback)->AloeTweenObject{
            let obj:AloeTweenObject = self.doTween(duration, startValue: startValue, endValue: endValue, ease: ease, progress: progress)
            obj.completeCallback = complete
            
            return obj
    }
    
    class func cancel(obj:AloeTweenObject){
        // removeAtがない
        self.rock()
        let to:Int = tweenList.count
        for index in 0..<to{
            if(obj == tweenList[index]){
                tweenList.removeAtIndex(index)
                self.unRock()
                return
            }
        }
        self.unRock()
    }
    
    class func cancelAll(){
        self.rock()
        tweenList = []
        self.unRock()
    }
    
    private class func rock(){
        objc_sync_enter(lock)
    }
    
    private class func unRock(){
        objc_sync_exit(lock)
    }
    
    // MARK: private
    
    // @objc つけないと呼べない。。
    @objc class func updateAnimations(){
        self.rock()
        let currentTime:Double = CACurrentMediaTime()
        var newList:[AloeTween.AloeTweenObject] = []
        for tweenObject in tweenList {
            tweenObject.next(currentTime)
            if(tweenObject.hasNext()){
                newList.append(tweenObject)
            }
        }
        tweenList = newList
        if(tweenList.count == 0){
            aloeTweenTimer!.invalidate()
            aloeTweenTimer = nil
            hasTimer = false
        }
        self.unRock()
    }
    
    // MARK: inner Class
    
    class AloeTweenObject:NSObject{
        
        private let duration:Double
        private let progressCallback:AloeTweenProgressCallback
        internal var completeCallback:AloeTweenCompleteCallback = { () -> () in
        }
        private let ease:AloeEase
        private var currentValue:Double
        private let startTime:Double
        internal var startValue:Double = 0.0
        internal var endValue:Double = 1.0
        private var isEnd:Bool = false
        
        internal init(duration:Double, ease:AloeEase, progressCallback:AloeTweenProgressCallback ){
            self.duration = duration
            self.progressCallback = progressCallback
            self.ease = ease
            currentValue = 0.0
            startTime = CACurrentMediaTime()
            super.init()
        }
        
        internal func next(currentTime:Double){
            let b:Double = startValue
            let c:Double = endValue - startValue
            let t:Double = currentTime - startTime;
            currentValue = ease.calc(t, b:b, c:c, d: duration)
            if(currentTime >= startTime + duration){
                currentValue = endValue
                isEnd = true
            }
            
            progressCallback(val: CGFloat(currentValue))
            if(isEnd){
                completeCallback()
            }
        }
        
        internal func hasNext()->Bool{
            return !isEnd
        }
        
        internal func getStartTime()->Double{
            return startTime
        }
        
        deinit{

        }
    }
}