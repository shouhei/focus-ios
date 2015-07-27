//
//  AppDelegate.swift
//  focus
//
//  Created by 山口将平 on 2015/07/07.
//  Copyright (c) 2015年 山口将平. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, CLLocationManagerDelegate, UIApplicationDelegate {
    
    var locationManager: CLLocationManager!
    var window: UIWindow?
    var myUserDafault:NSUserDefaults = NSUserDefaults()
    private var tabBarController: UITabBarController!
    private var notification: UILocalNotification!
    private var flag: Bool = false
    private var approachTimer = NSTimer()
    private var approachNum = 0
    let myDevice: UIDevice = UIDevice.currentDevice()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
       
        
        println("launched")
        
        let userViewController: UserViewController = UserViewController()
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = userViewController
        
        self.window?.makeKeyAndVisible()
        
        return true
        
    }
    
    func approachTimerUpdate(){
        approachNum++
        
//        if(approachNum == 15) {
//            println("離れました")
//        }
        
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let timerRunning: Bool = myUserDafault.boolForKey("timerRunning")
        //Notification登録前のおまじない。テストの為、現在のノーティフケーションを削除します
        if (!timerRunning) {
            return
        }
        UIApplication.sharedApplication().cancelAllLocalNotifications();
        
        //Notification登録前のおまじない。これがないとpermissionエラーが発生するので必要です。
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        
        //以下で登録処理
        var notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 5);//５秒後
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "集中して！"
        notification.alertAction = "OK"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification);
        
        println("did enter back")
        NSNotificationCenter.defaultCenter().postNotificationName("applicationWillEnterBackground", object: nil)
    }
    
//    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
//        
//        var alert = UIAlertView();
//        alert.title = "ほげ";
//        alert.message = notification.alertBody;
//        alert.addButtonWithTitle(notification.alertAction!);
//        alert.show();
//        
//    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        println("did become active")
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
//        func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
//    
//            var alert = UIAlertView();
//            alert.title = "focus!!!!";
//            alert.message = notification.alertBody;
//            alert.addButtonWithTitle(notification.alertAction!);
//            alert.show();
//            UIApplication.sharedApplication().cancelAllLocalNotifications();
//        }

    
}


