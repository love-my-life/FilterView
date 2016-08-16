//
//  SearchBar.swift
//  SecondsRent
//
//  Created by blueskyplan on 16/1/31.
//  Copyright © 2016年 LiJianhui. All rights reserved.
//

import UIKit

class SearchBar: UITextField {

    var iconView:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let font = UIFont.systemFontOfSize(14)
        self.font = font
        
        self.backgroundColor = RGB(79,156,210)
        self.cornerRadius = 4
        
        let attrs = [NSForegroundColorAttributeName:UIColor.whiteColor(),NSFontAttributeName:font]
        self.attributedPlaceholder = NSAttributedString(string: "搜索大厦的名称", attributes: attrs)
        
        iconView = UIImageView(image: UIImage(named: "search_icon"))
        iconView?.frame = CGRectMake(0, 0, 30, 30)
        iconView?.contentMode = .Center
        self.leftView = iconView
        self.leftViewMode = .Always
        
        self.returnKeyType = UIReturnKeyType.Done
//        self.enablesReturnKeyAutomatically = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.leftView?.frame = CGRectMake(0, 0, 30, self.frame.size.height)
    }
    
    func showIcon(show:Bool) {
        if (!show) {
            self.leftView = nil
        }
    }

}
