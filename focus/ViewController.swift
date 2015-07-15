//
//  ViewController.swift
//  focus
//
//  Created by 山口将平 on 2015/07/07.
//  Copyright (c) 2015年 山口将平. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate{

    private var locationManager: CLLocationManager!
    private var timerButton: UIButton!
    private var timerLabel: UILabel!
    private var countNum = 0
    private var timerRunning = false
    private var timer = NSTimer()
    private var latLabel: UILabel!
    private var lngLabel: UILabel!
    private var lat: Double!
    private var lng: Double!
    private var date: String!
    private var foursquareUrl: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //timerLabel
        
        timerLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
        timerLabel.backgroundColor = UIColor.grayColor()
        timerLabel.textColor = UIColor.whiteColor()
        timerLabel.textAlignment = NSTextAlignment.Center
        timerLabel.text = "00:00:00"
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
        timerButton.setTitle("集中開始!!", forState: UIControlState.Normal)
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
    
    func update() {
        countNum++
        timerFormat(countNum)
    }
    
    func timerFormat(countNum: Int) {
        let h = countNum / 3600
        let m = (countNum - h*3600) / 60
        let s = countNum % 60
        
        timerLabel.text = String(format: "%02d:%02d.%02d", h, m, s)
    }
    
    
    func onMyButtonClick(sender: UIButton){
        if timerRunning == false {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
            timerButton.backgroundColor = UIColor.blueColor()
            timerButton.setTitle("あきらめる!!", forState: UIControlState.Normal)
            timerRunning = true
            
        } else {
            //TODO集中完了画面遷移
            print("onMyButtonClick.True")
        }
        var dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")  // JPロケール
       
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"// フォーマットの指定
        println(dateFormatter.stringFromDate(NSDate()))
//        println(self.foursquareUrl)
        
        Alamofire.request(.GET, foursquareUrl).responseJSON{ (request, response, data, error) in
            if (response?.statusCode == 200) {
                let json = SwiftyJSON.JSON(data!)
                println(json)
                return;
                
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!,didUpdateLocations locations: [AnyObject]!){
        
        // 緯度・経度の表示.
        self.lat = manager.location.coordinate.latitude
        latLabel.text = "緯度：\(self.lat)"
        latLabel.textAlignment = NSTextAlignment.Center
        
        self.lng = manager.location.coordinate.longitude
        lngLabel.text = "経度：\(self.lng)"
        lngLabel.textAlignment = NSTextAlignment.Center
        
        foursquareUrl = "https://api.foursquare.com/v2/venues/search?ll=\(String(stringInterpolationSegment: self.lat)),\(String(stringInterpolationSegment: self.lng))&client_id=ZBQVZ0XB5QSSEWODAWANQWIB51KNQTZBQVKIE0NYT435C1JT&client_secret=NNZB2RJAWHNQGE5WCFCWFYSWZILDZPJQ4JRW3ZHQEMJBLUSH&v=20150714"
        
        self.view.addSubview(latLabel)
        self.view.addSubview(lngLabel)
        
    }
    
    
    func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
        print("error")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

