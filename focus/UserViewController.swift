//
//  UserViewController.swift
//  user_register_sample
//
//  Created by syouhei on 2015/07/20.
//  Copyright (c) 2015年 syouhei. All rights reserved.
//

import UIKit
import Alamofire

class UserViewController: UIViewController, UITextFieldDelegate {
    
    private let api_url_user_add = "http://focus.com/user/add"
    
    private let userModel = UserModel()
    private var nameTextField: UITextField!
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var passwordVerifyTextField: UITextField!
    private var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 登録済みだったら次の画面に遷移
        if (isRegisterd()) {
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("goToNextView"), userInfo: nil, repeats: false)
        } else {
            // 未登録ならユーザー登録
            self.view.backgroundColor = UIColor.whiteColor()
            
            setRegisterButton()
            setNameTextField()
            setEmailTextField()
            setPasswordTextField()
            setPasswordVerifyTextField()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isRegisterd() -> Bool {
        var user = userModel.getMe()
        if (user == nil) {
            return false
        } else {
            return true
        }

    }
    
    func goToNextView() {
        
        let firstTab: UIViewController = ViewController()
        let secondTab: UIViewController = HistoryViewController()
        let thirdTab: UIViewController = TerritoryViewController()
        
        firstTab.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Bookmarks, tag: 1)
        secondTab.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.History, tag: 2)
        thirdTab.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.TopRated, tag: 3)
        
        let tabs = NSArray(objects: firstTab, secondTab, thirdTab)
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(tabs as [AnyObject], animated: false)
        
        self.presentViewController(tabBarController, animated: true, completion: nil)
    }
    
    func register(name:String, email:String, password:String) {
        userModel.add(nameTextField.text, email: emailTextField.text, password: passwordTextField.text)
        let user = userModel.getMe()
        println(user)
    }
    
    //TODO: ちゃんとかく
    func request_api(name:String, email:String, password:String) {
        let param = ["name": name, "email": email, "password": password]
        Alamofire.request(.GET, api_url_user_add, parameters: param)
            .response { (request, response, data, error) in
                println(request)
                println(response)
                println(error)
        }
    }
    
    func setRegisterButton() {
        registerButton = UIButton(frame: CGRectMake(0, 0, 200, 50))
        registerButton.layer.cornerRadius = 20.0
        registerButton.backgroundColor = UIColor.orangeColor()
        registerButton.setTitle("登録", forState: UIControlState.Normal)
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
        registerButton.layer.position = CGPoint(x: self.view.bounds.width/2, y: 400)
        registerButton.addTarget(self, action: "onClickRegisterButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(registerButton)
    }
    
    func onClickRegisterButton(sender: UIButton) {
        println("register")
        
        var name = nameTextField.text
        var email = emailTextField.text
        var password = passwordTextField.text
        
        register(name, email: email, password: password)
        request_api(name, email: email, password: password)
        goToNextView()
    }
    
    func setNameTextField() {
        let myLabel: UILabel = UILabel(frame: CGRectMake(0,0,200,50))
        myLabel.layer.cornerRadius = 20.0
        myLabel.text = "名前"
        myLabel.textAlignment = NSTextAlignment.Center
        myLabel.layer.position = CGPoint(x: self.view.bounds.width/2 - 85,y: 70)
        self.view.addSubview(myLabel)
    
        nameTextField = UITextField(frame: CGRectMake(0,0,200,30))
        nameTextField.text = ""
        nameTextField.delegate = self
        nameTextField.borderStyle = UITextBorderStyle.RoundedRect
        nameTextField.layer.position = CGPoint(x:self.view.bounds.width/2,y:100);
        self.view.addSubview(nameTextField)
    }
    
    func setEmailTextField() {
        let myLabel: UILabel = UILabel(frame: CGRectMake(0,0,200,50))
        myLabel.layer.cornerRadius = 20.0
        myLabel.text = "メールアドレス"
        myLabel.textAlignment = NSTextAlignment.Center
        myLabel.layer.position = CGPoint(x: self.view.bounds.width/2 - 45,y: 140)
        self.view.addSubview(myLabel)
        
        emailTextField = UITextField(frame: CGRectMake(0,0,200,30))
        emailTextField.delegate = self
        emailTextField.borderStyle = UITextBorderStyle.RoundedRect
        emailTextField.layer.position = CGPoint(x:self.view.bounds.width/2,y:170);
        self.view.addSubview(emailTextField)
    }
    
    func setPasswordTextField() {
        let myLabel: UILabel = UILabel(frame: CGRectMake(0,0,200,50))
        myLabel.layer.cornerRadius = 20.0
        myLabel.text = "パスワード"
        myLabel.textAlignment = NSTextAlignment.Center
        myLabel.layer.position = CGPoint(x: self.view.bounds.width/2 - 60,y: 210)
        self.view.addSubview(myLabel)
        
        passwordTextField = UITextField(frame: CGRectMake(0,0,200,30))
        passwordTextField.delegate = self
        passwordTextField.borderStyle = UITextBorderStyle.RoundedRect
        passwordTextField.layer.position = CGPoint(x:self.view.bounds.width/2,y:240);
        passwordTextField.secureTextEntry = true
        self.view.addSubview(passwordTextField)
    }

    func setPasswordVerifyTextField() {
        let myLabel: UILabel = UILabel(frame: CGRectMake(0,0,200,50))
        myLabel.layer.cornerRadius = 20.0
        myLabel.text = "パスワード（確認）"
        myLabel.textAlignment = NSTextAlignment.Center
        myLabel.layer.position = CGPoint(x: self.view.bounds.width/2 - 27,y: 280)
        self.view.addSubview(myLabel)
        
        passwordVerifyTextField = UITextField(frame: CGRectMake(0,0,200,30))
        passwordVerifyTextField.delegate = self
        passwordVerifyTextField.borderStyle = UITextBorderStyle.RoundedRect
        passwordVerifyTextField.layer.position = CGPoint(x:self.view.bounds.width/2,y:310);
        passwordVerifyTextField.secureTextEntry = true
        self.view.addSubview(passwordVerifyTextField)
    }
    
    // UITextFieldが編集された直後に呼ばれるデリゲートメソッド.
    func textFieldDidBeginEditing(textField: UITextField){
    }
    
    // UITextFieldが編集終了する直前に呼ばれるデリゲートメソッド.
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    // 改行ボタンが押された際に呼ばれるデリゲートメソッド.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}