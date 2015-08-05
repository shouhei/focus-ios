//
//  ResultViewController.swift
//  focus
//
//  Created by  TakuyaOmura on 2015/07/18.
//  Copyright (c) 2015年 山口将平. All rights reserved.
//

import UIKit
import Social

protocol ResultDelegate{
    
    func resetTimer()
}

class ResultViewController: UIViewController {
    
    private var locationLabel: UILabel!
    private var timerLabel: UILabel!
    private var rankLabel: UILabel!
    private var messageLabel: UILabel!
    private var _location: String!
    private var _timer: Int!
    private var _rank: Int!
    private var againButton: UIButton!
    private var myTwitterButton: UIButton!

    private var myComposeView : SLComposeViewController!
    var delegate: ResultDelegate!
    private let userModel = UserModel()
    
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

        //ranklabel

        rankLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
        rankLabel.textColor = UIColor.whiteColor()
        rankLabel.text = "現在\(_rank!.description)位です！"
        rankLabel.textAlignment = NSTextAlignment.Center
        rankLabel.layer.position = CGPoint(x: windowWidth()/2, y: windowHeight()/2 + 50)
        
        //againButton
        againButton = UIButton(frame: CGRectMake(0, 0, 200, 50))
        againButton.layer.cornerRadius = 20.0
        againButton.backgroundColor = UIColor.orangeColor()
        againButton.setTitle("もう一度？", forState: UIControlState.Normal)
        againButton.layer.position = CGPointMake(windowWidth()/2, windowHeight()/2 + 105)
        
        againButton.addTarget(self, action: "onAgainButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)


        myTwitterButton = UIButton()
        myTwitterButton.frame = CGRectMake(0,0,50,50)
        myTwitterButton.setImage(UIImage(named: "twitter_logo"), forState: .Normal)
        myTwitterButton.setTitle("Twitter", forState: UIControlState.Normal)
        myTwitterButton.layer.position = CGPoint(x: windowWidth()/2 - 50, y: windowHeight()/2 + 210)
        myTwitterButton.addTarget(self, action: "postToTwitter:", forControlEvents: .TouchUpInside)

        // buttonをviewに追加.
        self.view.addSubview(myTwitterButton)

        timerLabel.text = "\(_timer)秒"
        locationLabel.text = "\(_location)で"
        self.view.addSubview(timerLabel)
        self.view.addSubview(rankLabel)
        self.view.addSubview(locationLabel)
        self.view.addSubview(messageLabel)
        self.view.addSubview(againButton)
    }
    
    func setUpParameter(location: String?, timer: Int?, rank: Int?) {
        self._location = location
        self._timer = timer
        self._rank = rank
//        setLabel()
    }

    func postToTwitter(sender : AnyObject) {
        // SLComposeViewControllerのインスタンス化.
        // ServiceTypeをTwitterに指定.
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)

        // 投稿するテキストを指定.
        myComposeView.setInitialText("\(userModel.getName())さんは\(_location)で\(_timer)秒集中しました！ #FOCUS")

        // myComposeViewの画面遷移.
        self.presentViewController(myComposeView, animated: true, completion: nil)
    }


    func onAgainButtonClick(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate.resetTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

