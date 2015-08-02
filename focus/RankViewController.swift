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
    var placeName: String!
    private let userModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var token = UserModel().getToken()
        
        connection(token)
        
        let barBg = UIView(frame: CGRectMake(0, 0, windowWidth(), 70))
        barBg.backgroundColor = UIColorFromHex(0x00bfff) // TODO なんかいい感じのいろに
        let barLabel = UILabel(frame: CGRectMake(0, 30, windowWidth(), 30))

        barLabel.text = self.placeName
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
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if _json == nil{
            return 0
        } else {
            return _json["response"]["data"].count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as! RankCell
        if _json == nil {
            cell.nameLabel.text = ""
            cell.timeLabel.text = ""
            
        } else {
            if (indexPath.row == 0){
                cell.nameLabel.text = self._json["response"]["data"][indexPath.row]["user"]["name"].string
                cell.timeLabel.text = self._json["response"]["data"][indexPath.row]["sum"].string
                var rankImage: UIImage = UIImage(named:"rank_oukan")!
                cell.rankImage = rankImage
                cell.rankview.image = rankImage
            } else {
                cell.nameLabel.text = self._json["response"]["data"][indexPath.row]["user"]["name"].string
                cell.timeLabel.text = self._json["response"]["data"][indexPath.row]["sum"].string
            }
        }
        
        return cell
    }
    
    func connection(token: String) -> Void {
        let rankUrl: String = "http://54.191.229.14/spots/\(self.placeId)"
        println(token)
        var headers = ["Authorized-Token": token]
        Alamofire.request(.GET, rankUrl, headers: headers).responseJSON{ (request, response, data, error) in
            if (response?.statusCode == 200) {
                self._json = SwiftyJSON.JSON(data!)
            } else {
                //TODO エラー処理
            }
            self.tableView.reloadData()
            self.view.addSubview(self.tableView)
        }
    }
    
    func setUpParameter(placeid: Int, placename: String) {
        self.placeId = placeid
        self.placeName = placename
    }
}
