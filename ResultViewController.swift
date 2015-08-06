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
    private var twitterButton: UIButton!
    var delegate: ResultDelegate!
    private var resultImage = CIImage(image: UIImage(named: "focus_result.png"))
    private var regretafulImage = CIImage(image: UIImage(named: "focus_regretful.png"))
    var myComposeView : SLComposeViewController!
    private var myImageView = UIImageView(frame: CGRectMake(0, 0, 350, 600))
    private var _resultBool = true
    let userModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if _resultBool {
            myImageView.image = UIImage(CIImage: resultImage)
            self.view.addSubview(myImageView)
            
            timerLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
            timerLabel.textAlignment = NSTextAlignment.Center
            timerLabel.font = UIFont(name: "GillSans-Bold", size: 23)
            timerLabel.textColor = UIColorFromHex(0xFFF9E0)
            timerFormat(_timer)
            timerLabel.layer.position = CGPoint(x: windowWidth()/2, y: windowHeight()/2 - 100)
            //locationLabel
            
            locationLabel = UILabel(frame: CGRectMake(0, 0, windowHeight(), 50))
            locationLabel.textAlignment = NSTextAlignment.Center
            locationLabel.font = UIFont(name: "GillSans-Bold", size: 18)
            locationLabel.textColor = UIColorFromHex(0xFFF9E0)
            locationLabel.text = "\(_location)で"
            locationLabel.layer.position = CGPoint(x: windowWidth()/2, y: windowHeight()/2 - 50)
            
            //messagelabel
            
            messageLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
            messageLabel.font = UIFont(name: "GillSans-Bold", size: 18)
            messageLabel.textColor = UIColorFromHex(0xFFF9E0)
            messageLabel.text = "集中しました！"
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.layer.position = CGPoint(x: windowWidth()/2, y: windowHeight()/2)
            
            //againButton
            
            var retryImage = UIImage(named: "retrybutton.png")
            againButton = UIButton(frame: CGRectMake(0, 0, 200, 50))
            againButton.setImage(retryImage, forState: UIControlState.Normal)
            againButton.layer.position = CGPointMake(windowWidth()/2, windowHeight()/2 + 55)
            againButton.addTarget(self, action: "onAgainButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
            
            //twitterButton
            var twitterImage = UIImage(named: "twitterbutton.png")
            twitterButton = UIButton(frame: CGRectMake(0, 0, 200, 50))
            twitterButton.setImage(twitterImage, forState: UIControlState.Normal)
            twitterButton.layer.position = CGPointMake(windowWidth()/2, windowHeight()/2 + 113)
            twitterButton.addTarget(self, action: "onPostToTwitter:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(locationLabel)

        } else {
            myImageView.image = UIImage(CIImage: regretafulImage)
            self.view.addSubview(myImageView)
            //timerLabel
            
            timerLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
            timerLabel.textAlignment = NSTextAlignment.Center
            timerLabel.font = UIFont(name: "GillSans-Bold", size: 23)
            timerLabel.textColor = UIColor.blackColor()
            timerFormat(_timer)
            timerLabel.layer.position = CGPoint(x: windowWidth()/2 + 10, y: windowHeight()/2 - 70)
            
            
            //messagelabel
            
            messageLabel = UILabel(frame: CGRectMake(0, 0, 250, 50))
            messageLabel.font = UIFont(name: "GillSans-Bold", size: 18)
            messageLabel.textColor = UIColorFromHex(0xFFF9E0)
            messageLabel.text = "次はもっと集中しましょう"
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.layer.position = CGPoint(x: windowWidth()/2, y: windowHeight()/2 + 40)
            
            //againButton
            
            var retryImage = UIImage(named: "retrybutton.png")
            againButton = UIButton(frame: CGRectMake(0, 0, 200, 50))
            againButton.setImage(retryImage, forState: UIControlState.Normal)
            againButton.layer.position = CGPointMake(windowWidth()/2, windowHeight()/2 + 95)
            againButton.addTarget(self, action: "onAgainButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
            
            //twitterButton
            var twitterImage = UIImage(named: "twitterbutton.png")
            twitterButton = UIButton(frame: CGRectMake(0, 0, 200, 50))
            twitterButton.setImage(twitterImage, forState: UIControlState.Normal)
            twitterButton.layer.position = CGPointMake(windowWidth()/2, windowHeight()/2 + 153)
            twitterButton.addTarget(self, action: "onPostToTwitter:", forControlEvents: UIControlEvents.TouchUpInside)

        }
        
        self.view.addSubview(timerLabel)
        self.view.addSubview(messageLabel)
        self.view.addSubview(againButton)
        self.view.addSubview(twitterButton)
        
    }
    
    func setUpParameter(location: String?, timer: Int?, resultbool: Bool, rank: Int?) {
        
        self._location = location
        self._timer = timer
        self._resultBool = resultbool
        self._rank = rank
        
        println(_location)
        println(_timer)
        println(_resultBool)
    }
    
    func setUpParameter(location: String?, timer: Int?, rank: Int?) {
        self._location = location
        self._timer = timer
        self._rank = rank
    }


    func onAgainButtonClick(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate.resetTimer()
    }
    
    func onPostToTwitter(sender : UIButton) {
        
        // SLComposeViewControllerのインスタンス化.
        
        // ServiceTypeをTwitterに指定.
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        // 投稿するテキストを指定.
        myComposeView.setInitialText("\(userModel.getName())さんは\(_location)で\(_timer)秒集中しました！ #FOCUS")
        
        // myComposeViewの画面遷移.
        self.presentViewController(myComposeView, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func timerFormat(timerint: Int) -> Void {
        let h = timerint / 3600
        let m = timerint / 60
        let s = timerint % 60
        
        timerLabel.text = String(format: "%02d時間%02d分%02d秒", h, m, s)
    }
}

