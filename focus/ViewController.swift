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
    private var startImage = CIImage(image: UIImage(named: "start_to_focus.png"))
    private var stopImage = CIImage(image: UIImage(named: "focus_home.png"))
    private var myImageView = UIImageView(frame: CGRectMake(0, 0, 350, 600))
    private var resultBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myUserDafault.setBool(timerRunning, forKey: "timerRunning")
        
        myImageView.image = UIImage(CIImage: startImage)
        self.view.addSubview(myImageView)

        //timerLabel
        if (timerLabel == nil) {
            timerLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
            // フォントサイズ
            timerLabel.font = UIFont(name: "GillSans-Bold", size: 24)
            timerLabel.textColor = UIColor.blackColor()
            timerLabel.textAlignment = NSTextAlignment.Center
            timerLabel.layer.position = CGPoint(x: windowWidth()/2 - 50, y: windowHeight()/2 + 50)
        }
        backgroundTaskIdentifier = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
            UIApplication.sharedApplication().endBackgroundTask(self.backgroundTaskIdentifier!)
        })
        
        
        self.view.backgroundColor = UIColorFromHex(0x1253A4)
        
        //timerLabel
        
        timerLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
        timerLabel.font = UIFont(name: "GillSans-Bold", size: 22)
        timerLabel.textColor = UIColor.blackColor()
        timerLabel.textAlignment = NSTextAlignment.Center
        timerLabel.layer.position = CGPoint(x: windowWidth()/2 - 42, y: windowHeight()/2 + 57)
        
        
        //locationLabel
        
        locationLabel = UILabel(frame: CGRectMake(0, 0, 300, 50))
        locationLabel.textColor = UIColor.whiteColor()
        locationLabel.textAlignment = NSTextAlignment.Center
        locationLabel.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
        locationLabel.layer.position = CGPoint(x: windowWidth()/2, y: windowHeight()/2 - 100)
        
        //timerButton
        var image = UIImage(named: "startbutton.png")
        timerButton = UIButton(frame: CGRectMake(0, 0, 150, 60))
        timerButton.setImage(image, forState: UIControlState.Normal)
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
                locationLabel.text = location
                timerRunning = true
                myUserDafault.setBool(timerRunning, forKey: "timerRunning")

                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerUpdate"), userInfo: nil, repeats: true)
                myImageView.image = UIImage(CIImage: stopImage)
                var image = UIImage(named: "stopbutton.png")
                timerButton.setImage(image, forState: UIControlState.Normal)
                
                //追加
                self.view.addSubview(myImageView)
                self.view.addSubview(timerButton)
                self.view.addSubview(timerLabel)
                self.view.addSubview(locationLabel)
                
            } else {
                resultBool = false
                NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("goToResultView"), userInfo: nil, repeats: false)
            }
        } else {
            timerLabel.text = "集中する？"
        }
        self.view.addSubview(timerButton)
        self.view.addSubview(timerLabel)
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
            self.timerRunning = true
            myUserDafault.setBool(timerRunning, forKey: "timerRunning")
        } else {
            //API
            requestApiEnd()
        }
        
        //API処理
        Alamofire.request(.GET, foursquareUrl).responseJSON{ (request, response, data, error) in
            if (response?.statusCode == 200) {
                self.json = SwiftyJSON.JSON(data!)
            } else {
                // TODO エラー処理
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
            
            if (response?.statusCode == 200) {
                let results = SwiftyJSON.JSON(responseData!)
                println(results["response"]["timer_id"])
                let timer_id_int: Int = results["response"]["timer_id"].int!
                let timer_id: String = timer_id_int.description
                self.myUserDafault.setObject(timer_id, forKey: "timer_id")
            }else {
                // TODO エラー処理
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
            
            if (response?.statusCode == 200) {
                let results = SwiftyJSON.JSON(responseData!)
                self._rank = results["response"]["rank"].intValue
                self.goToResultView()
            }else {
                println(error)
            }
        }
    }
    
    func goToResultView() {
        let resultViewController: ResultViewController = ResultViewController()
        resultViewController.setUpParameter(_location, timer: Int(tmp), resultbool: resultBool, rank: _rank)
        self.presentViewController(resultViewController, animated: true, completion: nil)
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
    }
    
    func locationSelect(locationName: String, locationId: String) {
        self._location = locationName
        self._locationId = locationId
        locationLabel.text = self._location
        startTime = NSDate()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerUpdate"), userInfo: nil, repeats: true)
        myImageView.image = UIImage(CIImage: stopImage)
        var image = UIImage(named: "stopbutton.png")
        timerButton.setImage(image, forState: UIControlState.Normal)
        //追加
        self.view.addSubview(myImageView)
        self.view.addSubview(timerButton)
        self.view.addSubview(timerLabel)
        self.view.addSubview(locationLabel)
        self.requestApiStart()
    }
    
    func backbutton() {
        self.timerRunning = false
        myUserDafault.setBool(timerRunning, forKey: "timerRunning")
    }
    
    func resetTimer() {
        locationLabel.text = ""
        timerLabel.text = ""
        timerRunning = false
        myUserDafault.setBool(timerRunning, forKey: "timerRunning")
        resultBool = true
        timer.invalidate()
        tmp = 0
        self.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

