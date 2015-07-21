//
//  AloeTweenChain.swift
//  swiftLib
//
//  Created by kawase yu on 2014/09/16.
//  Copyright (c) 2014年 marimo. All rights reserved.
//

import Foundation

typealias AloeTweenChainFunc = ()->()


class AloeTweenChain{
    
    private var commandList:[ChainCommand] = []
    private var total:Int = 0
    private var current:Int = 0
    
    class func create()->AloeTweenChain{
        return AloeTweenChain()
    }
    
    func add(duration:Double, ease:AloeEase, progress:AloeTweenProgressCallback)->AloeTweenChain{
        commandList.append(ToCommand(duration: duration, ease: ease, progress: progress))
        return self
    }
    
    func wait(delay:Double)->AloeTweenChain{
        commandList.append(WaitCommand(delay:delay))
        return self
    }
    
    func call(f:AloeTweenChainFunc)->AloeTweenChain{
        commandList.append(FuncCommand(f:f))
        return self
    }
    
    func execute(){
        total = commandList.count
        subThread { () -> () in
            self.executeRow()
        }
    }
    
    deinit{

    }
    
    private func executeRow(){
        // end
        if(total == current){
            return
        }
        var c:ChainCommand = commandList.removeAtIndex(0)
        c.setComplete_({ () -> () in
            self.current++
            self.executeRow()
        })
        c.execute()
    }
    
    // MARK: コマンド基底
    class ChainCommand:NSObject{
        
        var complete:AloeTweenChainCommandCallback = { () -> () in
            
        }
        
        typealias AloeTweenChainCommandCallback = ()->()
        override init(){
            super.init()
        }
        func onComplete(){
            subThread { () -> () in
                self.complete()
            }
        }
        func setComplete_(complete:AloeTweenChainCommandCallback){
            self.complete = complete
        }
        
        func execute(){}
        
        deinit{

        }
    }
    
    // MARK: Tween
    class ToCommand:ChainCommand{
        
        private let duration:Double
        private let ease:AloeEase
        private let progress:AloeTweenProgressCallback
        
        init(duration:Double, ease:AloeEase, progress:AloeTweenProgressCallback){
            self.duration = duration
            self.ease = ease
            self.progress = progress
            super.init()
        }
        
        override func execute() {
            AloeTween.doTween(duration, ease: ease, progress:progress, complete:{ () -> () in
                self.onComplete()
            })
        }
    }
    
    // MARK: wait
    class WaitCommand:ChainCommand{
        
        private var delay:Double
        
        init(delay:Double){
            self.delay = delay
            super.init()
        }
        
        override func execute() {
            NSThread.sleepForTimeInterval(delay)
            self.onComplete()
        }
    }
    
    // MARK: func
    class FuncCommand:ChainCommand{
        
        private var f:AloeTweenChainFunc
        
        init(f:AloeTweenChainFunc){
            self.f = f
            super.init()
        }
        
        override func execute() {
            mainThread { () -> () in
                self.f()
                subThread({ () -> () in
                    self.onComplete()
                })
            }
        }
    }
}
