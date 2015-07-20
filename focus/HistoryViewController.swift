//
//  HistoryViewController.swift
//  focus
//
//  Created by  TakuyaOmura on 2015/07/18.
//  Copyright (c) 2015年 山口将平. All rights reserved.
//


import UIKit
import Alamofire

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let tableView = UITableView(frame: CGRectMake(0, 70, windowWidth(),windowHeight()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barBg = UIView(frame: CGRectMake(0, 0, windowWidth(), 70))
        barBg.backgroundColor = UIColorFromHex(0x00bfff) // TODO なんかいい感じのいろに
        let barLabel = UILabel(frame: CGRectMake(0, 30, windowWidth(), 30))
        
        barLabel.text = "集中履歴"
        barLabel.textColor = UIColor.whiteColor()
        barLabel.textAlignment = NSTextAlignment.Center
        barBg.addSubview(barLabel)
        
        Alamofire.request(.GET, "http://127.0.0.1:5000/example/migrateversion")
            .responseJSON {(request, response, JSON, error) in
                println(request)
                println(response)
                println(JSON)
        }
        
        self.view.addSubview(tableView)
        self.view.addSubview(barBg)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CELL_ID") as? UITableViewCell
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL_ID")
        }
        
        cell!.textLabel?.text = String(indexPath.row)
        
        
        return cell!
        
    }
}
