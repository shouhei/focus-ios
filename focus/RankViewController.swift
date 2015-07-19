//
//  RankViewController.swift
//  focus
//
//  Created by  TakuyaOmura on 2015/07/18.
//  Copyright (c) 2015年 山口将平. All rights reserved.
//



import UIKit

class RankViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let tableView = UITableView(frame: CGRectMake(0, 70, windowWidth(),windowHeight()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
