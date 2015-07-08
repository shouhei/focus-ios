//
//  ViewController.swift
//  focus
//
//  Created by 山口将平 on 2015/07/07.
//  Copyright (c) 2015年 山口将平. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{

    private var locationManager: CLLocationManager!
    private var timerButton: UIButton!
    private var timerLabel: UILabel!
    private var latLabel: UILabel!
    private var lngLabel: UILabel!
    private var cnt: Float = 0
    private var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //timerLabel
        
        timerLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
        timerLabel.backgroundColor = UIColor.grayColor()
        timerLabel.text = "TIME:\(cnt)"
        timerLabel.textColor = UIColor.whiteColor()
        timerLabel.textAlignment = NSTextAlignment.Center
        timerLabel.layer.position = CGPoint(x: windowWidth()/2, y: windowHeight()/2)
        
        //latlnglabel
        
        latLabel = UILabel(frame: CGRectMake(0, 0, windowWidth(), 40))
        latLabel.layer.position = CGPointMake(windowWidth()/2, windowWidth()/3)
        lngLabel = UILabel(frame: CGRectMake(0, 0, windowWidth(), 40))
        lngLabel.layer.position = CGPointMake(windowWidth()/2, windowWidth()/3 + 50)
        
        
        //timerButton
        
        timerButton = UIButton(frame: CGRectMake(0, 0, 200, 50))
        timerButton.layer.cornerRadius = 20.0
        timerButton.backgroundColor = UIColor.redColor()
        timerButton.setTitle("START!", forState: UIControlState.Normal)
        timerButton.layer.position = CGPointMake(windowWidth()/2, windowHeight() - 100)
        timerButton.addTarget(self, action: "onMyButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //現在地取得
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.NotDetermined {
            self.locationManager.requestAlwaysAuthorization()
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        
        locationManager.startUpdatingLocation()
        
        
        
        //addwindow
        self.view.addSubview(timerButton)
        self.view.addSubview(timerLabel)
        
    }
    
    func onMyButtonClick(sender: UIButton){
        if timer?.valid == true {
            
            timer.invalidate()
            
            sender.backgroundColor = UIColor.redColor()
            sender.setTitle("START", forState: UIControlState.Normal)
            
        }else{
            
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)

            sender.backgroundColor = UIColor.blueColor()
            sender.setTitle("STOP", forState: UIControlState.Normal)
            
        }
    }
    
    func locationManager(manager: CLLocationManager!,didUpdateLocations locations: [AnyObject]!){
        
        // 緯度・経度の表示.
        latLabel.text = "緯度：\(manager.location.coordinate.latitude)"
        latLabel.textAlignment = NSTextAlignment.Center
        
        lngLabel.text = "経度：\(manager.location.coordinate.longitude)"
        lngLabel.textAlignment = NSTextAlignment.Center
        
        
        self.view.addSubview(latLabel)
        self.view.addSubview(lngLabel)
        
    }
    
    
    func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
        print("error")
    }
    
    func onUpdate(timer: NSTimer){
        cnt += 0.1
        
        let str = "TIME:".stringByAppendingFormat("%.1f", cnt)
        
        timerLabel.text = str
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

