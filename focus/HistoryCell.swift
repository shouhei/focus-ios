//
//  HistoryCell.swift
//  focus
//
//  Created by  TakuyaOmura on 2015/07/26.
//  Copyright (c) 2015年 山口将平. All rights reserved.
//

import UIKit

class HistoryCell:  UITableViewCell{
    
    var placeLabel = UILabel()
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
        
        placeLabel = UILabel(frame: CGRectMake(10, 20, 300, 15));
        placeLabel.text = "";
        placeLabel.font = UIFont.systemFontOfSize(20)
        self.addSubview(placeLabel);
        
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

