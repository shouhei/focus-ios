//
//  PenAnnotation.swift
//  focus
//
//  Created by  TakuyaOmura on 2015/07/28.
//  Copyright (c) 2015年 山口将平. All rights reserved.
//


import MapKit

class PenAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D!
    var senderTag: Int!
    var title: String?
    var subtitle: String?
    var image :UIImage?
    
    
     init() {
        
        super.init()
        
    }
}
