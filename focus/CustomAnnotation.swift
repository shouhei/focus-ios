//
//  CustomAnnotation.swift
//  focus
//
//  Created by  TakuyaOmura on 2015/07/28.
//  Copyright (c) 2015年 山口将平. All rights reserved.
//
import UIKit
import MapKit


class CustomAnnotation: NSObject, MKAnnotation, MKMapViewDelegate {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var initialize: Int!
    
    init(_coordinate: CLLocationCoordinate2D) {
        coordinate = _coordinate
    }
    
}
