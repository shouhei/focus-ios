//
//  SelectLocationViewController.swift
//  focus
//
//  Created by  TakuyaOmura on 2015/07/15.
//  Copyright (c) 2015年 山口将平. All rights reserved.
//
import UIKit
import SwiftyJSON

protocol SelectLocationDelegate{
    
    func locationSelect(locationName: String, locationId: String)
    func backbutton()
    
}

class SelectLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var _json: JSON!
    let tableView = UITableView(frame: CGRectMake(0, 70, windowWidth(),windowHeight()))
    var delegate: SelectLocationDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barBg = UIView(frame: CGRectMake(0, 0, windowWidth(), 70))
        barBg.backgroundColor = UIColorFromHex(0xC2B49A) // TODO なんかいい感じのいろに
        let barLabel = UILabel(frame: CGRectMake(0, 30, windowWidth(), 30))
        
        barLabel.text = "場所候補"
        barLabel.textColor = UIColor.whiteColor()
        barLabel.textAlignment = NSTextAlignment.Center
        let backButton = UIButton()
        backButton.addTarget(self, action: "backButtonTapped:", forControlEvents:.TouchUpInside)
        let image = UIImage(named: "arrow18")
        barBg.addSubview(backButton)
        
        backButton.setImage(image, forState: UIControlState.Normal)
        backButton.frame = CGRectMake(5, 30, 30, 30)
        
        barBg.addSubview(barLabel)
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(barBg)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CELL_ID") as? UITableViewCell
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL_ID")
        }
        
        
        cell!.textLabel!.text = self._json["response"]["venues"][indexPath.row]["name"].string
        
        cell?.textLabel?.font = UIFont(name:"Menlo-BoldItalic", size: 15)
        
        return cell!

    }
    
    func backButtonTapped(Sender: UIButton) {
        
        delegate.backbutton()
//        self.modalTransitionStyle = UIModalTransitionStyle.
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var location: String = self._json["response"]["venues"][indexPath.row]["name"].string!
        var id: String = self._json["response"]["venues"][indexPath.row]["id"].string!
        
        println(location)
        
        delegate.locationSelect(location, locationId: id)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func setUpParameter(json: JSON){
        
        self._json = json
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


