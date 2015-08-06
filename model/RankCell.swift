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
    var rankview: UIImageView!
    var rankImage = UIImage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel = UILabel(frame: CGRectMake(50, 20, 300, 15));
        nameLabel.text = "";
        nameLabel.font = UIFont(name: "IowanOldStyle-Italic", size: 20)
        self.addSubview(nameLabel);
        
        timeLabel = UILabel(frame: CGRectMake(200, 20, 300, 15));
        timeLabel.text = "";
        timeLabel.font = UIFont(name: "IowanOldStyle-Italic", size: 20)
        self.addSubview(timeLabel);
        
        rankview = UIImageView(frame: CGRectMake(10, 10, 20, 20))
        rankview.image = rankImage
        self.addSubview(rankview);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

