//
//  TerritoryViewController.swift
//  focus
//
//  Created by  TakuyaOmura on 2015/07/19.
//  Copyright (c) 2015年 山口将平. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON


class TerritoryViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    private var MyMapView : MKMapView!
    private var myLocationManager: CLLocationManager!
    private var mySearchBar: UISearchBar!
    private var userLocation: CLLocationCoordinate2D!
    private var destLocation: CLLocationCoordinate2D!
    private var selectAnnotation: MKPointAnnotation!
    private var mapPoint: CLLocationCoordinate2D!
    private let userModel = UserModel()
    private let api_url_owners = "http://54.191.229.14/spots/owners"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景を白に設定する.
        self.view.backgroundColor = UIColor.whiteColor()
        
        // 検索の背景作っちゃう
        let searchBarBg = UIView(frame: CGRectMake(0, 0, windowWidth(), 70))
        searchBarBg.backgroundColor = UIColorFromHex(0x00bfff) // TODO なんかいい感じのいろに
        let barLabel = UILabel(frame: CGRectMake(0, 30, windowWidth(), 30))
        
        barLabel.text = "勢力図"
        barLabel.textColor = UIColor.whiteColor()
        barLabel.textAlignment = NSTextAlignment.Center
        searchBarBg.addSubview(barLabel)
        
        mySearchBar = UISearchBar()
        MyMapView = MKMapView()
        mySearchBar.delegate = self
        mySearchBar.frame = CGRectMake(0, 70, windowWidth(), 30)
        
        //キャンセルボタンを有効
        mySearchBar.showsCancelButton = true
        mySearchBar.showsBookmarkButton = false
        mySearchBar.searchBarStyle = UISearchBarStyle.Default
        mySearchBar.placeholder = "ここに入力して下さい"
        mySearchBar.tintColor = UIColor.redColor()
        mySearchBar.showsSearchResultsButton = false
        
        MyMapView.frame = self.view.bounds
        MyMapView.delegate = self
        
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        
        //セキュリティ認証のステータスを取得
        let status = CLLocationManager.authorizationStatus()
        
        //まだ認証が済んでなければ確認ダイアログを表示
        if (status == CLAuthorizationStatus.NotDetermined) {
            
            self.myLocationManager.requestAlwaysAuthorization();
            
        }
        myLocationManager.distanceFilter = 100.0
        
        self.myLocationManager.startUpdatingLocation()
        
        
        self.view.addSubview(MyMapView)
        MyMapView.alpha = 0
        
        self.view.addSubview(mySearchBar)
        self.view.addSubview(searchBarBg)
        
        
        
        
        
        let myPointAnnotation: MKPointAnnotation = MKPointAnnotation()

        self.setup()
    }
    
    func setup() {
        let headers = ["Authorized-Token": userModel.getToken()]
        Alamofire.request(.GET, api_url_owners, headers:headers).responseJSON { (request, response, responseData, error) -> Void in
            println(request)
            println(response)
            println(responseData)
            println(request.allHTTPHeaderFields)
            if (response?.statusCode == 200) {
                let results = SwiftyJSON.JSON(responseData!)
                println(results)
                println(1)
                for (index: String, j: JSON) in results["response"] {
                    println(j)
                    if(j["spot"] == nil) {
                        continue
                    }
                    
                    // ピンを生成.
                    var pin: MKPointAnnotation = MKPointAnnotation()
                    // 座標を設定.
                    println(2)
                    println(j)
                    println(j["spot"]["lat"].doubleValue)
                    let lat: CLLocationDegrees = j["spot"]["lat"].doubleValue
//                    let lat: CLLocationDegrees = 35.56590
                    println(3)
                    let lng: CLLocationDegrees = j["spot"]["lng"].doubleValue
//                    let lng: CLLocationDegrees = 139.403
                    println(4)
                    println(lng)
                    pin.coordinate = CLLocationCoordinate2DMake(lat, lng)
                    println(5)
                    println(j["data"][0]["user"]["name"].stringValue)
                    // タイトルを設定.
                    pin.title = j["data"][0]["user"]["name"].stringValue
//
                    // サブタイトルを設定.
                    println(6)
                    pin.subtitle = j["data"][0]["sum"].stringValue
                    // MapViewにピンを追加.
                    println(7)
                    self.MyMapView.addAnnotation(pin)
                }
                println(10)
                
                
            }else {
                println(request.allHTTPHeaderFields)
                println(error)
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // キーボードを隠す
        
        mySearchBar.resignFirstResponder()
        
        // 目的地の文字列から座標検索
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mySearchBar.text, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            
            if let placemark = placemarks?[0] as? CLPlacemark {
                // 目的地の座標を取得
                self.destLocation = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude)
                //表示領域設定
                self.MyMapView.setCenterCoordinate(self.destLocation, animated: true)
                
                let MySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                let MyRegion: MKCoordinateRegion = MKCoordinateRegionMake(self.destLocation, MySpan)
                
                self.MyMapView.region = MyRegion
                
                // 現在地の取得を開始
                //                self.myLocationManager.startUpdatingLocation()
                
            }
        })
    }
    
    /*
    Cancelボタンが押された時に呼ばれる
    */
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        mySearchBar.text = ""
        mySearchBar.resignFirstResponder()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var userLocation = CLLocationCoordinate2DMake(manager.location.coordinate.latitude, manager.location.coordinate.longitude)
        
        var userLocAnnotation: MKPointAnnotation = MKPointAnnotation()
        
        userLocAnnotation.coordinate = userLocation
        userLocAnnotation.title = "現在地"
        
        //        MyMapView.addAnnotation(userLocAnnotation)
        
        MyMapView.alpha = 1.0
        
        let MySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let MyRegion: MKCoordinateRegion = MKCoordinateRegionMake(userLocation, MySpan)
        
        self.MyMapView.region = MyRegion
        //        self.view.addSubview(MyMapView)
        
    }
    
    
    // 位置情報取得に失敗した時に呼び出されるデリゲート.
    func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
        print("locationManager error")
    }
    
//    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//        if annotation === mapView.userLocation { // 現在地を示すアノテーションの場合はデフォルトのまま
//            return nil
//        } else {
//            let identifier = "annotation"
//            if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("annotation") { // 再利用できる場合はそのまま返す
//                return annotationView
//            } else { // 再利用できるアノテーションが無い場合（初回など）は生成する
//                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                annotationView.frame.size = CGSize(width: 10, height: 10)
//                annotationView.image = UIImage(named: "fountain_pen60")
//                return annotationView
//            }
//        }
//    }

    
    
}
