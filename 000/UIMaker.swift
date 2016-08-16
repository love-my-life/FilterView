

import Foundation
import UIKit



/// 屏幕的宽
let SCREENWIDTH = UIScreen.mainScreen().bounds.width
/// 屏幕的高
let SCREENHEIGHT = UIScreen.mainScreen().bounds.height

let IS_IPHONE = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone
let IS_IPHONE_6P = IS_IPHONE && SCREENHEIGHT == 736
let IS_IPHONE_6 = IS_IPHONE && SCREENHEIGHT == 667
let IS_IPHONE_5 = IS_IPHONE && SCREENHEIGHT == 568
let IS_IPHONE_4_4s = IS_IPHONE && SCREENHEIGHT == 480


//自动适配缩放比例
var autoSizeScaleX:CGFloat! = 1.0
var autoSizeScaleY:CGFloat! = 1.0

func CGRectAutoMake(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
    var rect = CGRect()
    rect.origin.x = x * autoSizeScaleX
    rect.origin.y = y * autoSizeScaleY
    rect.size.width = width * autoSizeScaleX
    rect.size.height = height * autoSizeScaleY
    
    return rect
}

func storyBoradAutoLay(allView:UIView){
     for view:UIView in allView.subviews {
        view.frame = CGRectAutoMake(view.frame.origin.x,
        y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height)
  
        for temp1:UIView in view.subviews {
            temp1.frame = CGRectAutoMake(
                temp1.frame.origin.x,
                y: temp1.frame.origin.y,
                width: temp1.frame.size.width,
                height: temp1.frame.size.height
            )
        }
    }
}

class UIMaker: NSObject {
    class func shareInstance()->UIMaker{
        
        struct qzSingle{
            static var predicate:dispatch_once_t = 0
            static var instance:UIMaker? = nil
        }
        
        //实例化一次
        dispatch_once(&qzSingle.predicate,{
            
            qzSingle.instance = UIMaker()
        
            if(SCREENHEIGHT > 480){
                autoSizeScaleX = SCREENWIDTH/320;
                autoSizeScaleY = SCREENHEIGHT/568;
            }else{
                autoSizeScaleX = 1.0
                autoSizeScaleY = 1.0
            }
        })
        
        return qzSingle.instance!
    }
}

func getWindow() ->UIWindow {
    if let delegate = UIApplication.sharedApplication().delegate {
        if let window = delegate.window {
            return window!
        }
    }
    
    return UIApplication.sharedApplication().keyWindow!
}
