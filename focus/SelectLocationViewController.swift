//
//  SelectLocationViewController.swift
//  focus
//
//  Created by  TakuyaOmura on 2015/07/15.
//  Copyright (c) 2015年 山口将平. All rights reserved.
//
import UIKit
import SwiftyJSON

class SelectLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var _json: JSON!
    let tableView = UITableView(frame: CGRectMake(0, 0, windowWidth(),windowHeight()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CELL_ID") as? UITableViewCell
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL_ID")
        }
        
        
        cell!.textLabel!.text = self._json["response"]["venues"][indexPath.row]["name"].string
        
        cell?.textLabel?.font = UIFont(name:"Menlo-BoldItalic", size: 15)
        
        
//        cell!.tag = dic["id"]!.integerValue!
//        cell?.backgroundColor = UIColor.lightGrayColor()
        return cell!

    }
    
    func setUpParameter(json: JSON){
        
        self._json = json
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


