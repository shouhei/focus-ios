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


class TerritoryViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    private var MyMapView : MKMapView!
    private var myLocationManager: CLLocationManager!
    private var mySearchBar: UISearchBar!
    private var userLocation: CLLocationCoordinate2D!
    private var destLocation: CLLocationCoordinate2D!
    
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
        
        self.view.addSubview(MyMapView)
        MyMapView.alpha = 0
        
        self.view.addSubview(mySearchBar)
        self.view.addSubview(searchBarBg)
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
