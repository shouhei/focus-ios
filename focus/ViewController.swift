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

class ViewController: UIViewController, CLLocationManagerDelegate, SelectLocationDelegate, ResultDelegate {

    private var locationManager: CLLocationManager!
    private var timerButton: UIButton!
    private var timerLabel: UILabel!
    private var locationLabel: UILabel!
    private var countNum = 0
    private var approachNum = 0
    private var timerRunning = false
    private var timer = NSTimer()
    private var lat: Double!
    private var lng: Double!
    private var date: String!
    private var foursquareUrl: String!
    private var json: JSON!
    private var _location: String!
    private var _rank: Int!
    private var _locationId: String!
    private var timerModel = TimerModel()
    private var startTime: NSDate!
    private var tmp: NSTimeInterval!
    private let api_url_timer_start = "http://54.191.229.14/timerstart/"
    private let api_url_timer_end = "http://54.191.229.14/timerend/"
    var myUserDafault:NSUserDefaults = NSUserDefaults()
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    let myDevice: UIDevice = UIDevice.currentDevice()
    let userModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myUserDafault.setBool(timerRunning, forKey: "timerRunning")
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //timerLabel
        if (timerLabel == nil) {
            timerLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
            timerLabel.textColor = UIColor.whiteColor()
            timerLabel.textAlignment = NSTextAlignment.Center
            timerLabel.layer.position = CGPoint(x: windowWidth()/2, y: windowHeight()/2 - 20)
        }
        backgroundTaskIdentifier = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
            UIApplication.sharedApplication().endBackgroundTask(self.backgroundTaskIdentifier!)
        })
        
        
        self.view.backgroundColor = UIColorFromHex(0x1253A4)
        
        //timerLabel
        
        timerLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
        timerLabel.textColor = UIColorFromHex(0xE9F2F9)
        timerLabel.textAlignment = NSTextAlignment.Center
        timerLabel.layer.position = CGPoint(x: windowWidth()/2, y: windowHeight()/2 - 20)
        
        
        //locationLabel
        
        locationLabel = UILabel(frame: CGRectMake(0, 0, 300, 50))
        locationLabel.textColor = UIColor.whiteColor()
        locationLabel.textAlignment = NSTextAlignment.Center
        locationLabel.layer.position = CGPoint(x: windowWidth()/2, y: windowHeight()/2 - 100)
        
        //timerButton
        
        timerButton = UIButton(frame: CGRectMake(0, 0, 200, 50))
        timerButton.layer.cornerRadius = 20.0
        timerButton.backgroundColor = UIColorFromHex(0xFFD464)
        timerButton.setTitle("集中開始!!", forState: UIControlState.Normal)
        timerButton.layer.position = CGPointMake(windowWidth()/2, windowHeight() - 125)
        timerButton.addTarget(self, action: "onTimerButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //現在地取得
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.NotDetermined {
            self.locationManager.requestAlwaysAuthorization()
        }
        
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager?.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        //addwindow
        self.view.addSubview(locationLabel)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterBackground:", name: "applicationWillEnterBackground", object: nil)
        
        let t = timerModel.get()
        if(t != nil) {
            timerModel.delete()
            let start_time_str = t!["datetime"] as! String
            let start_time = self.stringToDate(start_time_str)
            let now = NSDate()
            
            let tmpa = now.timeIntervalSinceDate(start_time)
            var timerInt = Int(tmpa)
            
            let location: String = t!["place"]! as! String
            _location = location
            startTime = stringToDate(t!["start_time"] as! String)
            var nowTime = NSDate()
            //差分を計算
            tmp = nowTime.timeIntervalSinceDate(startTime)
            
            if (timerInt <= 10) {
                //つづきから
                
                locationLabel.text = location
                timerRunning = true
                myUserDafault.setBool(timerRunning, forKey: "timerRunning")
                
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerUpdate"), userInfo: nil, repeats: true)
                
            } else {
                NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("goToResultView"), userInfo: nil, repeats: false)
            }
        } else {
            timerLabel.text = "集中する？"
        }
        self.view.addSubview(timerButton)
        self.view.addSubview(timerLabel)
        self.view.backgroundColor = UIColorFromHex(0x00bfff)
    }
    
    func willEnterBackground(notification: NSNotification?){
        self.save()
    }
    
    func save() {
        let datetime = getNowString()
        let start_time = dateToString(startTime)
        let place: String = locationLabel.text!
        
        timerModel.add(datetime, start_time: start_time, place: place, lat: lat, lng: lng)
    }
    
    func getNowString() -> String {
        return dateToString(NSDate())
    }
    
    func dateToString(date:NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        return formatter.stringFromDate(date)
    }
    
    func stringToDate(date_str:String) -> NSDate {
        var date_formatter: NSDateFormatter = NSDateFormatter()
        date_formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        var date:NSDate = date_formatter.dateFromString(date_str)!
        date_formatter.stringFromDate(date)
        return date
    }
    
    func timerUpdate() {
        countNum++
        
        var nowTime = NSDate()
        
        //差分を計算
        tmp = nowTime.timeIntervalSinceDate(startTime)
        var timerInt = Int(tmp)
        timerFormat(timerInt)
        
    }
    
    
    func timerFormat(timerint: Int) -> Void {
        let h = timerint / 3600
        let m = timerint / 60
        let s = timerint % 60
        
        timerLabel.text = String(format: "%02d:%02d.%02d", h, m, s)
    }

    
    func update() {
        countNum++
        timerFormat(countNum)
    }
    
    func onTimerButtonClick(sender: UIButton){
        
        if timerRunning == false {
            timerButton.backgroundColor = UIColor.blueColor()
            timerButton.setTitle("あきらめる!!", forState: UIControlState.Normal)
            self.timerRunning = true
            myUserDafault.setBool(timerRunning, forKey: "timerRunning")
        } else {
            //API
            requestApiEnd()
        }
        
        
        //API処理
        Alamofire.request(.GET, foursquareUrl).responseJSON{ (request, response, data, error) in
            
            if (response?.statusCode == 200) {
//                println(data)
                self.json = SwiftyJSON.JSON(data!)
//                println(self.json)
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
    
    func requestApiStart() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") // ロケールの設定
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let start_at = dateFormatter.stringFromDate(startTime)
        let param = ["_location": _location, "lat": String("\(lat)"), "lng": String("\(lng)"), "foursquare_id": _locationId, "start_at": start_at]
        let headers = ["Authorized-Token": userModel.getToken()]
        Alamofire.request(.POST, api_url_timer_start, parameters: param, headers:headers).responseJSON { (request, response, responseData, error) -> Void in
        /* r.responseJSON { (request, response, responseData, error) -> Void in */
        println(request)
            println(response)
            println(responseData)
            println(request.allHTTPHeaderFields)
            if (response?.statusCode == 200) {
                let results = SwiftyJSON.JSON(responseData!)
                println(8)
                println(results)
                println(9)
                println(results["response"]["timer_id"])
                let timer_id_int: Int = results["response"]["timer_id"].int!
                let timer_id: String = timer_id_int.description
                println(timer_id)
                self.myUserDafault.setObject(timer_id, forKey: "timer_id")
                println(self.myUserDafault.stringForKey("timer_id"))
            }else {
                println(request.allHTTPHeaderFields)
                println(error)
            }
        }
    }
    
    func requestApiEnd() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") // ロケールの設定
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let end_at = dateFormatter.stringFromDate(NSDate())
        let timer_id = myUserDafault.stringForKey("timer_id")!
        let param = ["id": timer_id, "end_at": end_at]
        let headers = ["Authorized-Token": userModel.getToken()]
        Alamofire.request(.POST, api_url_timer_end, parameters: param, headers:headers).responseJSON { (request, response, responseData, error) -> Void in
            /* r.responseJSON { (request, response, responseData, error) -> Void in */
            println(request)
            println(response)
            println(responseData)
            println(request.allHTTPHeaderFields)
            if (response?.statusCode == 200) {
                let results = SwiftyJSON.JSON(responseData!)
                println(results)

                println("ランキング")
                println(results["response"]["rank"])

                self._rank = results["response"]["rank"].intValue
                println("hogehogehoge")
                self.goToResultView()
            }else {
                println(request.allHTTPHeaderFields)
                println(error)
            }
            //            let token: String = results["response"]["token"].string!
        }


    }
    
    func goToResultView() {
        println("goresutl")
        println(_location)
        println(Int(tmp))
        println(223)
        let resultViewController: ResultViewController = ResultViewController()
        println(224)
        resultViewController.setUpParameter(_location, timer: Int(tmp), rank: _rank)
        println(225)
        self.presentViewController(resultViewController, animated: true, completion: nil)
        println(226)
        resultViewController.delegate = self
    }
    
    func locationManager(manager: CLLocationManager!,didUpdateLocations locations: [AnyObject]!){
        
        // 緯度・経度取得
        
        self.lat = manager.location.coordinate.latitude
        
        self.lng = manager.location.coordinate.longitude
        
        foursquareUrl = "https://api.foursquare.com/v2/venues/search?ll=\(String(stringInterpolationSegment: self.lat)),\(String(stringInterpolationSegment: self.lng))&client_id=ZBQVZ0XB5QSSEWODAWANQWIB51KNQTZBQVKIE0NYT435C1JT&client_secret=NNZB2RJAWHNQGE5WCFCWFYSWZILDZPJQ4JRW3ZHQEMJBLUSH&v=20150714"
        
        
    }
    
    
    func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
        //TODOエラー処理
        print("error")
        
    }
    
    func locationSelect(locationName: String, locationId: String) {
        
        self._location = locationName
        self._locationId = locationId
        locationLabel.text = self._location
//        self.view.addSubview(locationLabel)
        startTime = NSDate()
        println(-1)
        println(NSDate())
        println(startTime)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerUpdate"), userInfo: nil, repeats: true)
        
        self.requestApiStart()
    }
    
    func backbutton() {
        
        self.timerRunning = false
        myUserDafault.setBool(timerRunning, forKey: "timerRunning")
        timerButton.backgroundColor = UIColor.redColor()
        timerButton.setTitle("集中開始!!", forState: UIControlState.Normal)
    }
    
    func resetTimer() {
        
        locationLabel.text = ""
        timerLabel.text = ""
        timerRunning = false
        myUserDafault.setBool(timerRunning, forKey: "timerRunning")
        
        timer.invalidate()
        
        tmp = 0
        
        
        self.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

