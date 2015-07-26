//
//  TimeInterval.swift
//  focus
//
//  Created by  TakuyaOmura on 2015/07/26.
//  Copyright (c) 2015年 山口将平. All rights reserved.
//

import UIKit

extension NSDate {
    func stringForTimeIntervalSinceCreated() -> String {
        
        return stringForTimeIntervalSinceCreated(nowDate:NSDate())
    
    }
    
    func stringForTimeIntervalSinceCreated(#nowDate:NSDate) -> String {
    
    var MinInterval  :Int = 0
    var HourInterval :Int = 0
    var DayInterval  :Int = 0
    var DayModules   :Int = 0
    let interval = abs(Int(self.timeIntervalSinceDate(nowDate)))
    HourInterval = interval/3600
    var HourIntervalresult = String(HourInterval) + " hours"
    MinInterval = interval/60
    var MinIntervalresult =  String(MinInterval) + " minutes"
    var SecIntervarresult =  String(interval) + " sec"
        
}

extension NSDate {
    func toString(#format:String, localeIdentifier:String = "ja_JP") -> String? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        formatter.locale = NSLocale(localeIdentifier: localeIdentifier)
        let dateStr = formatter.stringFromDate(self)
        return dateStr
    }
}

extension String {
    func toDate(#format:String, localeIdentifier:String = "ja_JP") -> NSDate? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        formatter.locale = NSLocale(localeIdentifier: localeIdentifier)
        let date = formatter.dateFromString(self)
        return date
    }
}

