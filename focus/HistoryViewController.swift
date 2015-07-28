//
//  HistoryViewController.swift
//  focus
//
//  Created by  TakuyaOmura on 2015/07/18.
//  Copyright (c) 2015年 山口将平. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private var myActivityIndicator: UIActivityIndicatorView!
    let tableView = UITableView(frame: CGRectMake(0, 70, windowWidth(),windowHeight()))
    var _json: JSON!
    let histoyUrl: String = "http://54.191.229.14/users/"
    private let userModel = UserModel()
    private let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        // インジケータを作成する.
        myActivityIndicator = UIActivityIndicatorView()
        myActivityIndicator.frame = CGRectMake(0, 0, 50, 50)
        myActivityIndicator.center = self.view.center
        
        // アニメーションが停止している時もインジケータを表示させる.
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        
        // アニメーションを開始する.
        myActivityIndicator.startAnimating()
        
        // インジケータをViewに追加する.
        self.view.addSubview(myActivityIndicator)
        
        var token = userModel.getToken()
        
        connection(token)
        
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
        
        self.view.addSubview(barBg)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self._json == nil{
            
            return 0
            
        } else {
            
            return _json["response"].count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50.0
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as! HistoryCell
        
        
        if self._json == nil {
            
            cell.placeLabel.text = ""
            cell.timeLabel.text = ""
            var myImageView = UIImageView(frame: CGRectMake(0,0,25,25))
        
            let crownimage = UIImage(named: "crown")
        
            myImageView.image = crownimage
        
            cell.accessoryView = myImageView
        
        } else {
            
            cell.placeLabel.text = self._json["response"][indexPath.row]["spot"]["name"].string
            cell.timeLabel.text = self._json["response"][indexPath.row]["result_time"].string
            
            var myImageView = UIImageView(frame: CGRectMake(0,0,25,25))
            
            let crownimage = UIImage(named: "crown")
            
            myImageView.image = crownimage
            
            cell.accessoryView = myImageView
            self.indicator.stopAnimating()
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    
        let rankViewController: RankViewController = RankViewController()
        rankViewController.setUpParameter(self._json["response"][indexPath.row]["spot"]["id"].int!)
        rankViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        self.presentViewController(rankViewController, animated: true, completion: nil)
        println("indexpath:\(indexPath.row)")
    
    }
    
//    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
//    
//        println(indexPath.row)
//    
//    }
    
    
    func connection(token: String) -> Void {
        
        var headers = ["Authorized-Token": token]
        
        Alamofire.request(.GET, histoyUrl, headers: headers).responseJSON{ (request, response, data, error) in
            
            println(request)
            
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
    
}
