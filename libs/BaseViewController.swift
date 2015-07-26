//
//  BaseViewController.swift
//  haris
//
//  Created by kawase yu on 2015/04/15.
//  Copyright (c) 2015年 marimo. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var loadingView:UIView?
    var isLoading:Bool = false
    
    func showLoading(){
        if(loadingView != nil){
            return
        }
        isLoading = true
        loadingView = UIView(frame: CGRectMake(0, 0, 100, 100))
        
        let bgView:UIView = UIView(frame: CGRectMake(0, 0, 100, 100))
        bgView.backgroundColor = UIColor.blackColor()
        bgView.layer.cornerRadius = 10
        bgView.alpha = 0.6
        loadingView!.addSubview(bgView)
        
        let indicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        indicator.frame = bgView.frame
        indicator.startAnimating()
        
        loadingView!.addSubview(indicator)
        
        loadingView!.center = self.view.center
        loadingView!.alpha = 0
        loadingView!.transform = CGAffineTransformMakeTranslation(0, 20)
        
        self.view.addSubview(loadingView!)
        AloeTween.doTween(0.3, ease: AloeEase.OutQuint) { (val) -> () in
            self.loadingView!.alpha = val
            self.loadingView!.transform = CGAffineTransformMakeTranslation(0, 20.0-(val*20.0))
        }
    }
    
    func hideLoading(){
        if(!isLoading){
            return
        }
        isLoading = false
        
        AloeTweenChain.create().add(0.3, ease: AloeEase.InQuint, progress:{ (val) -> () in
            self.loadingView!.alpha = 1.0-val
            self.loadingView!.transform = CGAffineTransformMakeTranslation(0, -(val*20.0))
        }).call({ () -> () in
            self.loadingView!.removeFromSuperview()
            self.loadingView = nil
        }).execute()
    }
    
    func showToast(str:String, onView:UIView){
        
        let view = UIView(frame: CGRectMake(0, 0, windowHeight()/2, 100))
        let bg = UIView(frame: view.frame)
        bg.layer.cornerRadius = 10
        bg.backgroundColor = UIColor.blackColor()
        bg.alpha = 0.7
        view.addSubview(bg)
        
        let label = UILabel(frame: view.frame)
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 0
        label.textColor = UIColor.whiteColor()
        label.text = str
        label.font = UIFont.systemFontOfSize(16.0)
        
        view.addSubview(label)
        onView.addSubview(view)
        
        view.center = onView.center
        view.transform = CGAffineTransformMakeTranslation(0, 20)
        view.alpha = 0
        AloeTweenChain().add(0.2, ease: AloeEase.OutCirc, progress:{ (val) -> () in
            view.transform = CGAffineTransformMakeTranslation(0, 20-(20*val))
            view.alpha = val
        }).wait(3.0).add(0.2, ease: AloeEase.InCirc, progress:{ (val) -> () in
            view.transform = CGAffineTransformMakeTranslation(0, -(20*val))
            view.alpha = 1.0-val
        }).call({ () -> () in
            view.removeFromSuperview()
        }).execute()
    }
    
    func showToast(str:String){
        self.showToast(str, onView: self.view)
    }
    
    deinit{
        isLoading = false
    }
    

}
