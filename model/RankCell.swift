//
//  RankCell.swift
//  focus
//
//  Created by  TakuyaOmura on 2015/07/27.
//  Copyright (c) 2015年 山口将平. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

class RankCell:  UITableViewCell{
    
    var nameLabel = UILabel()
    var timeLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        
        //First Call Super
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel = UILabel(frame: CGRectMake(10, 20, 300, 15));
        nameLabel.text = "";
        nameLabel.font = UIFont.systemFontOfSize(20)
        self.addSubview(nameLabel);
        
        timeLabel = UILabel(frame: CGRectMake(150, 20, 300, 15));
        timeLabel.text = "";
        timeLabel.font = UIFont.systemFontOfSize(22)
        self.addSubview(timeLabel);
        
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
}

