//
//  HousingToolBar.swift
//  SecondsRent
//
//  Created by blueskyplan on 16/1/31.
//  Copyright © 2016年 LiJianhui. All rights reserved.
//

import UIKit

let LineColor = RGB(219,219,219)

protocol HousingToolBarDelegate {
    func didSelectButtonIndex(index: Int,selectButton:SelectButton)
}

class HousingToolBar: UIView {

    private var btnArray:Array<SelectButton> = []
    var delegate:HousingToolBarDelegate?
    var botView:UIView?
    private var w:CGFloat?
    
    init(frame: CGRect, btnTitles:Array<String>) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        var x:CGFloat = 0
        let y:CGFloat = 0
        w = (self.frame.size.width - CGFloat(btnTitles.count-1))/CGFloat(btnTitles.count)
        let h = self.frame.size.height
        
        for (index,title) in btnTitles.enumerate() {
            let btn = SelectButton(frame: CGRectMake(x, y, w!, h))
            btn.setTitle(title, forState: .Normal)
            btn.tag = 10000 + index
            btn.addTarget(self, action: #selector(self.action(_:)), forControlEvents: .TouchUpInside)
            self.addSubview(btn)
            btnArray.append(btn)
            
            x += w!+1
        }
        
        botView = UIView(frame: CGRectMake(0,h-1,w!,2))
        botView?.backgroundColor = THEME_COLOR
        botView?.hidden = true
        self.addSubview(botView!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func action(sender:SelectButton) {
        self.botView?.hidden = !sender.selected
        
        //点击的不是本身就关掉其他的状态
        for btn in btnArray {
            if (btn != sender) {
                btn.selected = false
            }
        }
        
        delegate?.didSelectButtonIndex(sender.tag-10000, selectButton: sender)

        UIView.animateWithDuration(0.15) { () -> Void in
            self.botView?.x = CGFloat(sender.tag - 10000) * (self.w!+1)
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        //获取画笔上下文
        let context = UIGraphicsGetCurrentContext()
        //抗锯齿设置
        CGContextSetAllowsAntialiasing(context, true)
        //画直线
        CGContextSetLineWidth(context, 0.5) //设置画笔宽度
        //设置画笔颜色
        CGContextSetStrokeColorWithColor(context, LineColor.CGColor)
        
        let h = rect.size.height
        var x:CGFloat = 0
        for (index,_) in btnArray.enumerate() {
            if (x > 0 && index < btnArray.count) {
                CGContextMoveToPoint(context, x, 8)
                CGContextAddLineToPoint(context, x, h-8)
            }
            x += w!+1
        }
        
        CGContextMoveToPoint(context, 0, h)
        CGContextAddLineToPoint(context, rect.size.width, h)
        CGContextStrokePath(context)
    }

}
