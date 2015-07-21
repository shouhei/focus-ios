//
//  UserModel.swift
//  user_register_sample
//
//  Created by syouhei on 2015/07/20.
//  Copyright (c) 2015年 syouhei. All rights reserved.
//

import Foundation

class UserModel {
    
    let _table_name = "users"
    
    init() {
        let (tb, err) = SD.existingTables()
        if !contains(tb, _table_name) {
            
            if let err = SD.createTable(_table_name, withColumnNamesAndTypes: ["name":.StringVal, "email":.StringVal, "password":.StringVal]) {
                println("Database Error: Failed to create table.")
            } else {
                println("Succeeded to create table.")
            }
        }
        println(SD.databasePath())
    }
    
    func add(name:String, email:String, password:String) -> Int? {
        
        var result:Int? = nil
        if let err = SD.executeChange("INSERT INTO users (name,email,password) VALUES (?,?,?)", withArgs: [name,email,password]) {
            println("Failed to add.");
        } else {
            let (id, err) = SD.lastInsertedRowID()
            if err != nil {
                println("Database Error: Failed to add.");
                return nil
            }else{
                //TODO: lastInsertedRowID()が0しか返ってこない
                result = Int(id)
            }
        }
        return result!
    }
    
    func getAll() -> NSMutableArray {
        var result = NSMutableArray()
        // 新しい番号から取得する場合は "SELECT * FROM sample_table_001 ORDER BY ID DESC" を使う
        let (resultSet, err) = SD.executeQuery("SELECT * FROM users")
        if err != nil {
        } else {
            for row in resultSet {
                if let id = row["ID"]?.asInt() {
                    let name = row["name"]?.asString()!
                    let email = row["email"]?.asString()!
                    
                    let dic = ["id":id, "name":name!, "email":email!]
                    result.addObject(dic)
                }
            }
        }
        return result
    }
    
    func getMe() -> NSDictionary? {
        var result: NSDictionary? = nil
//        let (resultSeat, erar) = SD.executeQuery("DELETE FROM users")
        let (resultSet, err) = SD.executeQuery("SELECT * FROM users")
        if err != nil {
            println("Database Error")
            return result
        }
        if resultSet.isEmpty {
            return result
        }
        var row = resultSet[0]
        if let id = row["ID"]?.asInt() {
            let name = row["name"]?.asString()!
            let email = row["email"]?.asString()!
            
            result = ["id":id, "name":name!, "email":email!]
        }
        return result!
    }
}