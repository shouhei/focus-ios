//
//  UserModel.swift
//  user_register_sample
//
//  Created by syouhei on 2015/07/20.
//  Copyright (c) 2015年 syouhei. All rights reserved.
//

import Foundation

class TimerModel {
    
    let _table_name = "timers"
    
    init() {
//        SD.deleteTable("timers")
        let (tb, err) = SD.existingTables()
        
        if !contains(tb, _table_name) {
            if let err = SD.createTable(_table_name, withColumnNamesAndTypes: ["datetime":.StringVal, "start_time":.StringVal, "flag":.IntVal, "place":.StringVal, "lat":.DoubleVal, "lng":.DoubleVal]) {
                println("Database Error: Failed to create table.")
            } else {
                println("Succeeded to create table.")
            }
        }
        println(SD.databasePath())
    }
    
    func add(datetime:String, start_time:String, place:String, lat:Double, lng:Double) -> Int? {
        var result:Int? = nil
        let flag: Int = 0
        if let err = SD.executeChange("INSERT INTO timers (datetime, start_time, flag, place, lat, lng) VALUES (?,?,?,?,?,?)", withArgs: [datetime, start_time, flag, place, lat, lng]) {
            println("Failed to add.");
        }
        return 1
    }
    
    func get() -> NSDictionary? {
        var result: NSDictionary? = nil
        //        let (resultSeat, erar) = SD.executeQuery("DELETE FROM users")
        let flag: Int = 0
        let (resultSet, err) = SD.executeQuery("SELECT * FROM timers WHERE flag = ?", withArgs: [flag])
        if err != nil {
            println("Database Error")
            return result
        }
        if resultSet.isEmpty {
            return result
        }
        var row = resultSet[0]
        if let id = row["ID"]?.asInt() {
            let datetime = row["datetime"]?.asString()!
            let start_time = row["start_time"]?.asString()!
            let place = row["place"]?.asString()!
            let lat = row["lat"]?.asDouble()!
            let lng = row["lng"]?.asDouble()!
            
            result = ["datetime":datetime!, "start_time":start_time!, "place":place!, "lat":lat!, "lng":lng!]
        }
        return result!

    }
    
    func delete() {
        SD.executeQuery("DELETE FROM timers")
    }
}