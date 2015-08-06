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

    var spot_id: Int
    var spot_name: String

    var image :UIImage?
    
    init(_coordinate: CLLocationCoordinate2D, _spot_id: Int, _spot_name: String) {
        coordinate = _coordinate
        self.spot_id = _spot_id
        self.spot_name = _spot_name
    }
    
}
