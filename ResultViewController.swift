//
//  ResultViewController.swift
//  focus
//
//  Created by  TakuyaOmura on 2015/07/18.
//  Copyright (c) 2015年 山口将平. All rights reserved.
//

import UIKit

protocol ResultDelegate{
    
    func resetTimer()
}

class ResultViewController: UIViewController {
    
    private var locationLabel: UILabel!
    private var timerLabel: UILabel!
    private var messageLabel: UILabel!
    private var _location: String!
    private var _timer: Int!
    private var againButton: UIButton!
    var delegate: ResultDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColorFromHex(0x00bfff)
        
        //timerLabel
        
        timerLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
        timerLabel.textColor = UIColor.whiteColor()
        timerLabel.textAlignment = NSTextAlignment.Center
        timerLabel.layer.position = CGPoint(x: windowWidth()/2, y: windowHeight()/2 - 100)
        
        //locationLabel
        
        locationLabel = UILabel(frame: CGRectMake(0, 0, windowHeight(), 50))
        locationLabel.textColor = UIColor.whiteColor()
        locationLabel.textAlignment = NSTextAlignment.Center
        locationLabel.layer.position = CGPoint(x: windowWidth()/2, y: windowHeight()/2 - 50)
        
        //messagelabel
        
        messageLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.text = "集中しました！"
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.layer.position = CGPoint(x: windowWidth()/2, y: windowHeight()/2)
        
        //againButton
        
        againButton = UIButton(frame: CGRectMake(0, 0, 200, 50))
        againButton.layer.cornerRadius = 20.0
        againButton.backgroundColor = UIColor.orangeColor()
        againButton.setTitle("もう一度？", forState: UIControlState.Normal)
        againButton.layer.position = CGPointMake(windowWidth()/2, windowHeight()/2 + 55)
        
        againButton.addTarget(self, action: "onAgainButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        timerLabel.text = "\(_timer)秒"
        locationLabel.text = "\(_location)で"
        
        self.view.addSubview(timerLabel)
        self.view.addSubview(locationLabel)
        self.view.addSubview(messageLabel)
        self.view.addSubview(againButton)
        
    }
    
    func setUpParameter(location: String?, timer: Int?) {
        
        self._location = location
        self._timer = timer
        
        println(_location)
        println(_timer)
        
    }
    
    func onAgainButtonClick(sender: UIButton){
        
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate.resetTimer()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

