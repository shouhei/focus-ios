//
//  HistoryViewController.swift
//  focus
//
//  Created by  TakuyaOmura on 2015/07/18.
//  Copyright (c) 2015年 山口将平. All rights reserved.
//


import UIKit
import Alamofire
import Alamofire
import SwiftyJSON

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let tableView = UITableView(frame: CGRectMake(0, 70, windowWidth(),windowHeight()))
    var placeItems: NSArray = ["daison","dada"]
    var timeItems: NSArray = ["1時間", "2時間"]
    var _json: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barBg = UIView(frame: CGRectMake(0, 0, windowWidth(), 70))
        barBg.backgroundColor = UIColorFromHex(0x00bfff) // TODO なんかいい感じのいろに
        let barLabel = UILabel(frame: CGRectMake(0, 30, windowWidth(), 30))
        
        barLabel.text = "集中履歴"
        barLabel.textColor = UIColor.whiteColor()
        barLabel.textAlignment = NSTextAlignment.Center
        barBg.addSubview(barLabel)
        
        
        tableView.registerClass(HistoryCell.self, forCellReuseIdentifier: "customCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        self.view.addSubview(barBg)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return placeItems.count
    
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50.0
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        println("1")
        
        var token = UserModel().getToken()
        
        println(token)
        
        connection(token)
        
        var cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as! HistoryCell
        
        println(self._json["response"][indexPath.row]["spot"]["name"].string)
        
        cell.placeLabel.text = self._json["response"][indexPath.row]["spot"]["name"].string
        cell.timeLabel.text = self._json["response"][indexPath.row]["result_time"].string
        
        var myImageView = UIImageView(frame: CGRectMake(0,0,25,25))
        
        let crownimage = UIImage(named: "crown")
        
        myImageView.image = crownimage
        
        cell.accessoryView = myImageView
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    
        let rankViewController: RankViewController = RankViewController()
//        rankViewController.setUpParameter()
        rankViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        self.presentViewController(rankViewController, animated: true, completion: nil)
        println(indexPath.row)
    
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
    
        println(indexPath.row)
    
    }
    
    
    func connection(token: String) -> Void {
        
        println("2")
        
        Alamofire.request(.GET, "http://54.191.229.14/users/", parameters: ["Authorized_Token": token]).responseJSON{ (request, response, data, error) in
            
            println("request")
            
            if (response?.statusCode == 200) {
                
                self._json = SwiftyJSON.JSON(data!)
                
            }else {
                //TODO エラー処理
                println(error)
            }
            
        }
        
    }
    
}
