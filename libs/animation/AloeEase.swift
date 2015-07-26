//
//  AloeEase.swift
//  swiftLib
//
//  Created by kawase yu on 2014/09/15.
//  Copyright (c) 2014年 marimo. All rights reserved.
//

import Foundation

enum AloeEase {
    case None
    , InQuad , OutQuad , InOutQuad
    , InCubic , OutCubic , InOutCubic
    , InQuart, OutQuart, InOutQuart
    , InQuint, OutQuint, InOutQuint
    , InSine, OutSine, InOutSine
    , InExpo, OutExpo, InOutExpo
    , InCirc, OutCirc, InOutCirc
    , InElastic, OutElastic, InOutElastic
    , InBack, OutBack, InOutBack
    , InBounce, OutBounce, InOutBounce
    
    static let list = [None
        , InQuad , OutQuad , InOutQuad
        , InCubic , OutCubic , InOutCubic
        , InQuart, OutQuart, InOutQuart
        , InQuint, OutQuint, InOutQuint
        , InSine, OutSine, InOutSine
        , InExpo, OutExpo, InOutExpo
        , InCirc, OutCirc, InOutCirc
        , InElastic, OutElastic, InOutElastic
        , InBack, OutBack, InOutBack
        , InBounce, OutBounce, InOutBounce]
    
    func name()->String{
        switch(self){
        case .None: return "None"
        case .InQuad: return "InQuad"
        case .OutQuad: return "OutQuad"
        case .InOutQuad: return "InOutQuad"
        case .InCubic: return "InCubic"
        case .OutCubic: return "OutCubic"
        case .InOutCubic: return "InOutCubic"
        case .InQuart: return "InQuart"
        case .OutQuart: return "OutQuart"
        case .InOutQuart: return "InOutQuart"
        case .InQuint: return "InQuint"
        case .OutQuint: return "OutQuint"
        case .InOutQuint: return "InOutQuint"
        case .InSine: return "InSine"
        case .OutSine: return "OutSine"
        case .InOutSine: return "InOutSine"
        case .InExpo: return "InExpo"
        case .OutExpo: return "OutExpo"
        case .InOutExpo: return "InOutExpo"
        case .InCirc: return "InCirc"
        case .OutCirc: return "OutCirc"
        case .InOutCirc: return "InOutCirc"
        case .InElastic: return "InElastic"
        case .OutElastic: return "OutElastic"
        case .InOutElastic: return "InOutElastic"
        case .InBack: return "InBack"
        case .OutBack: return "OutBack"
        case .InOutBack: return "InOutBack"
        case .InBounce: return "InBounce"
        case .OutBounce: return "OutBounce"
        case .InOutBounce: return "InOutBounce"
        }
    }
    
    func calc (t:Double, b:Double, c:Double, d:Double) -> Double {
        
        switch(self){
        case .None: return easeNone(t, b: b, c: c, d: d)
        case .InQuad: return easeInQuad(t, b: b, c: c, d: d)
        case .OutQuad: return easeOutQuad(t, b: b, c: c, d: d)
        case .InOutQuad: return easeInOutQuad(t, b: b, c: c, d: d)
        case .InCubic: return easeInCubic(t, b: b, c: c, d: d)
        case .OutCubic: return easeOutCubic(t, b: b, c: c, d: d)
        case .InOutCubic: return easeInOutCubic(t, b: b, c: c, d: d)
        case .InQuart: return easeInQuart(t, b: b, c: c, d: d)
        case .OutQuart: return easeOutQuart(t, b: b, c: c, d: d)
        case .InOutQuart: return easeInOutQuart(t, b: b, c: c, d: d)
        case .InQuint: return easeInQuint(t, b: b, c: c, d: d)
        case .OutQuint: return easeOutQuint(t, b: b, c: c, d: d)
        case .InOutQuint: return easeInOutQuint(t, b: b, c: c, d: d)
        case .InSine: return easeInSine(t, b: b, c: c, d: d)
        case .OutSine: return easeOutSine(t, b: b, c: c, d: d)
        case .InOutSine: return easeInOutSine(t, b: b, c: c, d: d)
        case .InExpo: return easeInExpo(t, b: b, c: c, d: d)
        case .OutExpo: return easeOutExpo(t, b: b, c: c, d: d)
        case .InOutExpo: return easeInOutExpo(t, b: b, c: c, d: d)
        case .InCirc: return easeInCirc(t, b: b, c: c, d: d)
        case .OutCirc: return easeOutCirc(t, b: b, c: c, d: d)
        case .InOutCirc: return easeInOutCirc(t, b: b, c: c, d: d)
        case .InElastic: return easeInElastic(t, b: b, c: c, d: d)
        case .OutElastic: return easeOutElastic(t, b: b, c: c, d: d)
        case .InOutElastic: return easeInOutElastic(t, b: b, c: c, d: d)
        case .InBack: return easeInBack(t, b: b, c: c, d: d)
        case .OutBack: return easeOutBack(t, b: b, c: c, d: d)
        case .InOutBack: return easeInOutBack(t, b: b, c: c, d: d)
        case .InBounce: return easeInBounce(t, b: b, c: c, d: d)
        case .OutBounce: return easeOutBounce(t, b: b, c: c, d: d)
        case .InOutBounce: return easeInOutBounce(t, b: b, c: c, d: d)
        }
    }
    private func easeNone(t:Double, b:Double, c:Double, d:Double)->Double{
        return c*t/d + b
    }
    private func easeInQuad(t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t / d
        return c*t*t + b
    }
    private func easeOutQuad(t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t / d
        return (-c) * t * (t-2) + b
    }
    private func easeInOutQuad(t:Double, b:Double, c:Double, d:Double)->Double{
        var t:Double = t / (d/2)
        if (t < 1) {
            return c/2*t*t + b
        }
        t--
        return -c/2 * (t*(t-2) - 1) + b
    }
    private func easeInCubic(t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t/d
        return c*t*t*t + b
    }
    private func easeOutCubic(t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t/d-1
        return c*(t*t*t + 1) + b
    }
    private func easeInOutCubic(t:Double, b:Double, c:Double, d:Double)->Double{
        var t:Double = t / (d/2)
        if (t < 1) {
            return c/2*t*t*t + b
        }
        
        t -= 2
        return c/2*(t*t*t + 2) + b
    }
    private func easeInQuart(t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t / d
        return c*t*t*t*t + b
    }
    private func easeOutQuart(t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t/d-1
        return -c * (t*t*t*t - 1) + b
    }
    private func easeInOutQuart(t:Double, b:Double, c:Double, d:Double)->Double{
        var t:Double = t / (d/2)
        if (t < 1) {
            return c/2*t*t*t*t + b
        }
        
        t-=2
        return -c/2 * (t*t*t*t - 2) + b
    }
    private func easeInQuint(t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t / d
        return c*t*t*t*t*t + b
    }
    private func easeOutQuint(t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t/d-1
        return c*(t*t*t*t*t + 1) + b
    }
    private func easeInOutQuint(t:Double, b:Double, c:Double, d:Double)->Double{
        var t:Double = t / (d/2)
        if(t < 1) {
            return c/2*t*t*t*t*t + b
        }
        t -= 2
        return c/2*(t*t*t*t*t + 2) + b
    }
    private func easeInSine(t:Double, b:Double, c:Double, d:Double)->Double{
        return -c * cos(t/d * (3.1419/2)) + c + b
    }
    private func easeOutSine(t:Double, b:Double, c:Double, d:Double)->Double{
        return c * sin(t/d * (3.1419/2)) + b
    }
    private func easeInOutSine(t:Double, b:Double, c:Double, d:Double)->Double{
        return -c/2 * (cos(3.1419*t/d) - 1) + b
    }
    private func easeInExpo(t:Double, b:Double, c:Double, d:Double)->Double{
        return (t==0) ? b : c * pow(2, 10 * (t/d - 1)) + b
    }
    private func easeOutExpo(t:Double, b:Double, c:Double, d:Double)->Double{
        return (t==d) ? b+c : c * (-pow(2, -10 * t/d) + 1) + b
    }
    private func easeInOutExpo(t:Double, b:Double, c:Double, d:Double)->Double{
        if (t==0){ return b }
        if (t==d){ return b+c }
        var t:Double = t / (d/2)
        if (t < 1){ return c/2 * pow(2, 10 * (t - 1)) + b }
        return c/2 * (-pow(2, -10 * --t) + 2) + b
    }
    private func easeInCirc(t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t / d
        return -c * (sqrt(1 - t*t) - 1) + b
    }
    private func easeOutCirc(t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t/d-1
        return c * sqrt(1 - t*t) + b
    }
    private func easeInOutCirc(t:Double, b:Double, c:Double, d:Double)->Double{
        var t:Double = t / (d/2)
        if (t < 1) {
            return -c/2 * (sqrt(1 - t*t) - 1) + b
        }
        t-=2
        return c/2 * (sqrt(1 - t*t) + 1) + b
    }
    private func easeInElastic(t:Double, b:Double, c:Double, d:Double)->Double{
        var s:Double = 1.70158
        var p:Double = 0
        var a:Double = c
        if (t==0){
            return b
        }
        var t:Double = t / d
        if (t==1){
            return b+c
        }
        if (p == 0){
            p = d * 0.3
        }
        if (a < abs(c)) {
            a=c
            s=p/4
        }else{
            s = p/(2*3.1419) * asin (c/a)
        }
        t--
        return -(a*pow(2,10*t) * sin( (t*d-s)*(2*3.1419)/p )) + b
    }
    private func easeOutElastic(t:Double, b:Double, c:Double, d:Double)->Double{
        var s:Double = 1.70158
        var p:Double = 0
        var a:Double = c
        
        if (t==0){
            return b
        }
        var t:Double = t / d
        if (t==1){
            return b+c
        }
        if (p == 0){
            p = d * 0.3
        }
        if (a < abs(c)) {
            a=c
            s=p/4
        }
        else{
            s = p/(2*3.1419) * asin (c/a)
        }
        return a*pow(2,-10*t) * sin( (t*d-s)*(2*3.1419)/p ) + c + b
    }
    private func easeInOutElastic(t:Double, b:Double, c:Double, d:Double)->Double{
        var s:Double = 1.70158
        var p:Double = 0
        var a:Double = c
        
        if (t==0){
            return b
        }
        var t:Double = t / (d/2)
        if (t==2){
            return b+c
        }
        if (p == 0){
            p = d*(0.3*1.5)
        }
        if (a < abs(c)) {
            a=c
            s=p/4
        }
        else{
            s = p/(2*3.1419) * asin (c/a)
        }
        if (t < 1) {
            t--
            return -0.5*(a*pow(2,10*t) * sin( (t*d-s)*(2*3.1419)/p )) + b
        }
        t--
        return a*pow(2,-10*t) * sin( (t*d-s)*(2*3.1419)/p )*0.5 + c + b
    }
    private func easeInBack(t:Double, b:Double, c:Double, d:Double)->Double{
        let s:Double = 1.70158
        let t:Double = t / d
        return c*t*t*((s+1)*t - s) + b
    }
    private func easeOutBack(t:Double, b:Double, c:Double, d:Double)->Double{
        let s:Double = 1.70158
        let t:Double = t/d-1
        return c*(t*t*((s+1)*t + s) + 1) + b
    }
    private func easeInOutBack(t:Double, b:Double, c:Double, d:Double)->Double{
        var s:Double = 1.70158
        let k:Double = 1.525
        var t:Double = t / (d/2)
        s = s * k
        if (t < 1) {
            return c/2*(t*t*((s+1)*t - s)) + b
        } else {
            t -= 2
            return c/2*(t*t*((s+1)*t + s) + 2) + b
        }
    }
    private func easeInBounce(t:Double, b:Double, c:Double, d:Double)->Double{
        return c - self.easeOutBounce(d-t, b:0, c:c, d:d) + b
    }
    private func easeOutBounce(t:Double, b:Double, c:Double, d:Double)->Double{
        var k:Double = 2.75
        var t:Double = t / d
        if (t < (1/k)) {
            return c*(7.5625*t*t) + b
        } else if (t < (2/k)) {
            t-=1.5/k
            return c*(7.5625*t*t + 0.75) + b
        } else if (t < (2.5/k)) {
            t-=2.25/k
            return c*(7.5625*t*t + 0.9375) + b
        } else {
            t-=2.625/k
            return c*(7.5625*t*t + 0.984375) + b
        }
    }
    private func easeInOutBounce(t:Double, b:Double, c:Double, d:Double)->Double{
        if (t < d*0.5){
            return self.easeOutBounce(t*2, b: 0, c: c, d: d) * 0.5 + b
        }
        return self.easeOutBounce(t*2-d, b:0, c:c, d:d) * 0.5 + c*0.5 + b
    }
}