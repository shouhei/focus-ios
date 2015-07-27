//
//  RankViewController.swift
//  focus
//
//  Created by  TakuyaOmura on 2015/07/18.
//  Copyright (c) 2015年 山口将平. All rights reserved.
//



import UIKit
import Alamofire
import SwiftyJSON


class RankViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let tableView = UITableView(frame: CGRectMake(0, 70, windowWidth(),windowHeight()))
    var _json: JSON!
    var placeId: Int!
    private let userModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var token = UserModel().getToken()
        
        println(token)
        
        connection(token)
        
        let barBg = UIView(frame: CGRectMake(0, 0, windowWidth(), 70))
        barBg.backgroundColor = UIColorFromHex(0x00bfff) // TODO なんかいい感じのいろに
        let barLabel = UILabel(frame: CGRectMake(0, 30, windowWidth(), 30))
        
        barLabel.text = "ランキング"
        barLabel.textColor = UIColor.whiteColor()
        barLabel.textAlignment = NSTextAlignment.Center
        barBg.addSubview(barLabel)
        
        tableView.registerClass(RankCell.self, forCellReuseIdentifier: "customCell")
        
        tableView.delegate = self
        tableView.dataSource = self
    
        
        self.view.addSubview(barBg)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if _json == nil{
            
            return 0
            
        } else {
            
            return _json["response"]["data"].count
        
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        println("1")
        
        var cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as! RankCell
        
        if _json == nil{
            
            cell.nameLabel.text = ""
            cell.timeLabel.text = ""

            
        } else{
            println(self._json["response"][indexPath.row]["spot"]["name"].string)
            
            cell.nameLabel.text = self._json["response"]["data"][indexPath.row]["user"]["name"].string
            cell.timeLabel.text = self._json["response"]["data"][indexPath.row]["sum"].string
        }
        
        
        var myImageView = UIImageView(frame: CGRectMake(0,0,25,25))
        
        let crownimage = UIImage(named: "crown")
        
        myImageView.image = crownimage
        
        cell.accessoryView = myImageView
        
        return cell
        
    }
    
    func connection(token: String) -> Void {
        
        println("2")
//        var request = NSMutableURLRequest(URL:NSURL(string: rankUrl)!, cachePolicy:.ReloadIgnoringLocalCacheData, timeoutInterval:4.0)
//        request.HTTPMethod = "GET"
//        request.addValue(token, forHTTPHeaderField: "Authorized_Token")
        
        println(token)
        
        let rankUrl: String = "http://54.191.229.14/spots/\(self.placeId)"
        
        var headers = ["Authorized-Token": token]
        
        Alamofire.request(.GET, rankUrl, headers: headers).responseJSON{ (request, response, data, error) in
            
            println(request)
            println(response)
            
            if (response?.statusCode == 200) {
                
                self._json = SwiftyJSON.JSON(data!)
                
                
                println(self._json)
                self.tableView.reloadData()
                
                self.view.addSubview(self.tableView)
                
            }else {
                //TODO エラー処理
                println(error)
            }
            
        }
        
    }
    
    func setUpParameter(placeid: Int) {
        
        self.placeId = placeid
        
    }
    
}
