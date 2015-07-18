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

class ViewController: UIViewController, CLLocationManagerDelegate, SelectLocationDelegate{

    private var locationManager: CLLocationManager!
    private var timerButton: UIButton!
    private var timerLabel: UILabel!
    private var locationLabel: UILabel!
    private var countNum = 0
    private var timerRunning = false
    private var timer = NSTimer()
    private var lat: Double!
    private var lng: Double!
    private var date: String!
    private var foursquareUrl: String!
    private var json: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //timerLabel
        
        timerLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
        timerLabel.textColor = UIColor.whiteColor()
        timerLabel.textAlignment = NSTextAlignment.Center
        timerLabel.text = "集中する？"
        timerLabel.layer.position = CGPoint(x: windowWidth()/2, y: windowHeight()/2)
        
        
        //locationLabel
        
        locationLabel = UILabel(frame: CGRectMake(0, 0, 300, 50))
        locationLabel.textColor = UIColor.whiteColor()
        locationLabel.textAlignment = NSTextAlignment.Center
        locationLabel.layer.position = CGPoint(x: windowWidth()/2, y: windowHeight()/2 - 100)
        
        
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
        self.view.backgroundColor = UIColorFromHex(0x00bfff)
        
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
        
        //API処理
        Alamofire.request(.GET, foursquareUrl).responseJSON{ (request, response, data, error) in
            
            if (response?.statusCode == 200) {
                
                self.json = SwiftyJSON.JSON(data!)
                
            }else {
                //TODO エラー処理
                println(error)
            }
            
            let selectLocationViewController: SelectLocationViewController = SelectLocationViewController()
            selectLocationViewController.setUpParameter(self.json)
            self.presentViewController(selectLocationViewController, animated: true, completion: nil)
            selectLocationViewController.delegate = self
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager!,didUpdateLocations locations: [AnyObject]!){
        
        // 緯度・経度取得
        
        self.lat = manager.location.coordinate.latitude
        
        self.lng = manager.location.coordinate.longitude
        
        foursquareUrl = "https://api.foursquare.com/v2/venues/search?ll=\(String(stringInterpolationSegment: self.lat)),\(String(stringInterpolationSegment: self.lng))&client_id=ZBQVZ0XB5QSSEWODAWANQWIB51KNQTZBQVKIE0NYT435C1JT&client_secret=NNZB2RJAWHNQGE5WCFCWFYSWZILDZPJQ4JRW3ZHQEMJBLUSH&v=20150714"
        
    }
    
    
    func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
        print("error")
    }
    
    func locationSelect(locationName: String) {
        
        locationLabel.text = locationName
        self.view.addSubview(locationLabel)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

