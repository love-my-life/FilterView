
import UIKit

@IBDesignable extension UIView {
    
    /// x坐标
    var x: CGFloat  {
        set {
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
        get {
            return self.frame.origin.x
        }
    }
    
    /// y坐标
    var y: CGFloat  {
        set {
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
        get {
            return self.frame.origin.y
        }
    }
    
    /// 宽度
    var width: CGFloat {
        set {
            var rect = self.frame
            if (newValue < 0) {
                rect.size.width = 0
            } else {
                rect.size.width = newValue
            }
            self.frame = rect
        }
        get {
            return self.frame.size.width
        }
    }
    
    /// 高度
    var height: CGFloat {
        set {
            var rect = self.frame
            if (newValue < 0) {
                rect.size.height = 0
            } else {
                rect.size.height = newValue
            }
            self.frame = rect
        }
        get {
            return self.frame.size.height
        }
    }
    
    /// 坐标
    var point: CGPoint {
        set {
            var rect = self.frame
            rect.origin.x = newValue.x
            rect.origin.y = newValue.y
            self.frame = rect
        }
        get {
            return self.frame.origin
        }
    }
    
    /// 大小
    var size: CGSize {
        set {
            var rect = self.frame
            if (newValue.width < 0) {
                rect.size.width = 0
            } else {
                rect.size.width = newValue.width
            }
            if (newValue.height < 0) {
                rect.size.height = 0
            } else {
                rect.size.height = newValue.height
            }
            self.frame = rect
        }
        get {
            return self.frame.size
        }
    }
    
    /// 中心点x坐标
    var centerX: CGFloat { return self.center.x }
    
    /// 中心点y坐标
    var centerY: CGFloat { return self.center.y }
    
    /// 右间距
    var rightSpacing: CGFloat { return self.frame.origin.x + self.frame.size.width }
    
    /// 底部间距
    var bottomSpacing: CGFloat { return self.frame.origin.y + self.frame.size.height }
    

    
    /// 设置中心点x坐标
    func setCenterX(centerX: CGFloat) {
        var point = self.center
        point.x = centerX
        self.center = point
    }
    
    /// 设置中心点y坐标
    func setCenterY(centerY: CGFloat) {
        var point = self.center
        point.y = centerY
        self.center = point
    }
    
    /// setRight
    func setRight(right: CGFloat) {
        var rect = self.frame
        rect.origin.x = right - rect.size.width
        self.frame = rect
    }
    
    /// setBottom
    func setBottom(bottom: CGFloat) {
        var rect = self.frame
        rect.origin.y = bottom - rect.size.height
        self.frame = rect
    }
    
    /// 设置圆角
    @IBInspectable var cornerRadius:CGFloat {
        set {
            if (newValue < 0) {
                self.layer.cornerRadius = 0
            } else {
                self.layer.cornerRadius = newValue
            }
            self.layer.masksToBounds = true
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.mainScreen().scale
        }
        get {
            return self.cornerRadius
        }
    }
    @IBInspectable var borderWidth:CGFloat {
        set {
            if (newValue < 0) {
                self.layer.borderWidth = 0
            } else {
                self.layer.borderWidth = newValue
            }
        }
        get {
            return self.borderWidth
        }
    }
    @IBInspectable var borderColor:UIColor {
        set {
            self.layer.borderColor = newValue.CGColor
        }
        get {
            return self.borderColor
        }
    }
  
    /// 设置阴影
    ///
    /// - parameter   color: 阴影颜色
    /// - parameter   offset: 阴影偏移，默认(0, -3),这个跟radius配合使用
    /// - parameter   radius: 阴影半径，默认3
    /// - parameter   opacity: 阴影透明度，默认0
    func shadow(color: UIColor, offset: CGSize?, radius: CGFloat?, opacity: Float?) {
        self.layer.shadowColor = color.CGColor
        if offset != nil {
            self.layer.shadowOffset = offset!
        }
        if radius != nil {
            self.layer.shadowRadius = radius!
        }
        if opacity != nil {
            self.layer.shadowOpacity = opacity!
        }
    }
    
    /// 设置边框和颜色
    func borderWidthAndColor(borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.CGColor
    }
    
    /// 键盘弹起
    func viewScrollUP(dx: CGFloat,_ dy: CGFloat) {
        guard dy != 0 else {
            return
        }
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(0.3)
        self.frame.offsetInPlace(dx: dx, dy: dy)
        UIView.commitAnimations()
    }
    /// 键盘收回
    func viewScrollDonw() {
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(0.3)
        self.frame = self.bounds
        UIView.commitAnimations()
    }
    
    
}
