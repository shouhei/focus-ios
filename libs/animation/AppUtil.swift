//
//  AppUtil.swift
//  hayashicamera
//
//  Created by kawase yu on 2015/02/28.
//  Copyright (c) 2015年 kawase. All rights reserved.
//

import UIKit

// global

func UIColorFromHex(rgbValue:UInt32)->UIColor{
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:1.0)
}

func UIColorFromHexString(str:String)->UIColor{
    let colorScanner:NSScanner = NSScanner(string: str)
    var color:UInt32 = 0x0;
    colorScanner.scanHexInt(&color)
    
    let r:CGFloat = CGFloat((color & 0xFF0000) >> 16) / 255.0
    let g:CGFloat = CGFloat((color & 0x00FF00) >> 8) / 255.0
    let b:CGFloat = CGFloat(color & 0x0000FF) / 255.0
    
    return UIColor(red:r, green:g, blue:b, alpha:1.0)
}

func is35Inch()->Bool{
    return (windowHeight() < 568)
}

func windowHeight()->CGFloat{
    return UIScreen.mainScreen().bounds.size.height
}

func windowWidth()->CGFloat{
    return UIScreen.mainScreen().bounds.size.width
}

func windowFrame()->CGRect{
    return UIScreen.mainScreen().bounds
}

func pain(view:UIView){
    let fromScale:CGFloat = 0.95
    view.transform = CGAffineTransformMakeScale(fromScale, fromScale)
    AloeTween.doTween(0.2, ease: AloeEase.OutBounce, progress: { (val) -> () in
        let scale:CGFloat = fromScale + ((1.0-fromScale) * val)
        view.transform = CGAffineTransformMakeScale(scale, scale)
    })
}


private var AppUtilImageCache:Dictionary<String, UIImage> = [:]
typealias AppUtilImageCacheCallback = (image:UIImage, key:String, useCache:Bool)->()

class AppUtil: NSObject {
    
    class func loadImage(imageUrl:String, callback:AppUtilImageCacheCallback){
        if AppUtilImageCache[imageUrl] != nil{
            callback(image: AppUtilImageCache[imageUrl]!, key: imageUrl, useCache: true)
            return
        }
        
        subThread { () -> () in
            // 別スレッドでの処理がここ
            let url = NSURL(string: imageUrl)
            var err: NSError?
            
            var imageData :NSData = NSData(contentsOfURL: url!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
            var image = UIImage(data:imageData)
            
            if image == nil{
                return
            }
            
            AppUtilImageCache[imageUrl] = image
            mainThread({ () -> () in
                
                callback(image: image!, key: imageUrl, useCache: false)
            })
        }
    }
    
    class func clearImageCache(){
        AppUtilImageCache.removeAll(keepCapacity: false)
    }
    
}
