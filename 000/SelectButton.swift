//
//  SelectButtom.swift
//  SecondsRent
//
//  Created by blueskyplan on 16/1/31.
//  Copyright © 2016年 LiJianhui. All rights reserved.
//

import UIKit

class SelectButton: UIButton {
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        let titleX:CGFloat = 0
        let titleY:CGFloat = 0
        let titleW:CGFloat = contentRect.size.width
        let titleH:CGFloat = contentRect.size.height
        
        return CGRectMake(titleX, titleY, titleW, titleH)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.setImage(UIImage(named: "btn_down"), forState: .Normal)
        
        self.setTitleColor(THEME_COLOR, forState: .Selected)
        self.setImage(UIImage(named: "btn_up"), forState: .Selected)
        
        self.addTarget(self, action: #selector(SelectButton.select as (SelectButton) -> () -> ()), forControlEvents: .TouchUpInside)
        
        // 高亮的时候不用自动调整图标
        self.adjustsImageWhenHighlighted = false
        
        self.imageView!.contentMode = .Center;
        self.titleLabel!.font = UIFont.systemFontOfSize(14)
        self.titleLabel!.textAlignment = .Center
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func select() {
        self.selected = !self.selected
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageY:CGFloat = 2
        let imageW:CGFloat = 20
        let imageH:CGFloat = self.frame.size.height
        let textW = self.titleLabel?.text?.rectWithFontSize(14, width: self.frame.size.width).width
        if let w = textW {
            let imgX = (self.frame.size.width - w)/2 + w
            
            if imgX + 20 >= self.frame.width {
                self.titleLabel?.frame.size.width = self.frame.size.width-20
                self.imageView?.frame = CGRectMake(self.frame.size.width-20, imageY, imageW, imageH)
            } else {
                self.imageView?.frame = CGRectMake(imgX-5, imageY, imageW, imageH)
                self.titleLabel?.frame.origin.x = -5
            }
        }
    }

}
