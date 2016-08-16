

import UIKit

extension String {
    
    
    /// 获取字符串Rect
    ///
    /// - parameter fontSize: 字体大小
    /// - parameter width: 显示的宽度
    /// - returns:  CGRect
    func rectWithFontSize(fontSize:CGFloat, width:CGFloat) -> CGRect {
        let font = UIFont.systemFontOfSize(fontSize)
        let size = CGSizeMake(width,CGFloat.max)
       
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        let  attributes = [
            NSFontAttributeName:font,
            NSParagraphStyleAttributeName:paragraphStyle.copy()
        ]
        
        let text = self as NSString
        let rect = text.boundingRectWithSize(
            size,
            options: .UsesLineFragmentOrigin,
            attributes: attributes,
            context:nil)
        
        return rect
    }
    
    /**
     * 获取字符串的大小
     **/
    func textSizeWithFont(font: UIFont, constrainedToSize size:CGSize) -> CGSize {
        var textSize:CGSize!
        if CGSizeEqualToSize(size, CGSizeZero) {
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            textSize = self.sizeWithAttributes(attributes as? [String : AnyObject])
        } else {
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            let stringRect = self.boundingRectWithSize(size, options: option, attributes: attributes as? [String : AnyObject], context: nil)
            textSize = stringRect.size
        }
        return textSize
    }


    
    /// 时间戳转String
    ///
    /// - parameter  format: 时间格式
    /// - returns:   时间
    func stringWithTimestamp(format: String) -> String {
        let fmt = NSDateFormatter()
        fmt.dateFormat = format
        
        let date = NSDate(timeIntervalSince1970 : self.double!)
        
        return  fmt.stringFromDate(date)
    }
    
    /**
    时间戳转几零后
    
    :returns:  "xx后"
    */
    func yStringWithTimestamp() -> String
    {
        let ts = NSString(string: self).doubleValue
        
        let date = NSDate(timeIntervalSince1970 : ts)
        let dateStr = dateFormat("yyyy年").stringFromDate(date)
        return "\(NSString(string: dateStr).substringWithRange(NSMakeRange(2, 1)))0后"
    }
    
    /**
    几零后转时间戳
    
    :returns:  时间戳
    */
    func timestampWithYString() -> Int {
        let y = NSString(string: self).substringWithRange(NSMakeRange(0, 2))
        
        var yearStr: NSString!
        if y.substringToIndex(1) == "0" {
            yearStr = "20\(y)"
        } else {
            yearStr = "19\(y)"
        }
        
        let date = dateFormat("yyyy").dateFromString("\(yearStr)")!
        let tamp: NSTimeInterval = date.timeIntervalSince1970
        
        return Int(tamp)
    }
    
    /**
    时间戳转时间
    
    :returns:  NSDate
    */
    var date: NSDate {
        let date = NSDate(timeIntervalSince1970: self.double!)
        
        return date
    }
    
    /**
    分隔字符串
    
    :returns:  分割后的字符串数组
    */
    func stringArrWithChar(char: String) -> NSArray {
        return self.componentsSeparatedByString(char)
    }
    
    /// sql字符串
    var sqlString: String {
       return "'"+self+"'"
    }
    
    /// 判断是否是Number
    var isNumber: Bool {
        guard !self.isEmpty && (Int(self) != nil || Double(self) != nil) else {
            return false
        }
   
        return true
    }
    
    var double: Double? {
        guard !self.isEmpty && Double(self) != nil else {
            return nil
        }
        return Double(self)!
    }
    
    var float: Float? {
        guard !self.isEmpty && Float(self) != nil else {
            return nil
        }
        return Float(self)!
    }
    
    var int: Int? {
        guard !self.isEmpty && Int(self) != nil else {
            return nil
        }
        return Int(self)!
    }
    
    /// 计算长度
    var length: Int {
        return self.characters.count
    }
    
    /// 字符串去空格
    var deleteSpace: String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    /// 去类型名
    func typeNameFromClass(aClass:AnyClass) -> String {
        let name = NSStringFromClass(aClass)
        let demangleName = _stdlib_demangleName(name)
        return demangleName.componentsSeparatedByString(".").last!
    }
    
    /// 字符串截取
    func substringToIndex(index:Int) -> String? {
        guard index > 0 else {
            return nil
        }
        return self.substringToIndex(self.startIndex.advancedBy(index))
    }
    /// 字符串截取
    func substringFromIndex(index:Int) -> String? {
        guard index > 0 else {
            return nil
        }
        return self.substringFromIndex(self.startIndex.advancedBy(index))
    }
    /// 字符串截取
    func substringWithRange(range:Range<Int>) -> String {
        let start = self.startIndex.advancedBy(range.startIndex)
        let end = self.startIndex.advancedBy(range.endIndex)
        
        return self.substringWithRange(start..<end)
    }
    
    /// 字符串截取区间子字符串
    ///
    /// :param: 起始位置
    /// :param: 结束位置
    /// :returns: 子字符串
    func substringWithRange(startIndex: Int, endIndex: Int) -> String {
        let start = self.startIndex.advancedBy(startIndex)
        let end = self.startIndex.advancedBy(endIndex)
        
        return self.substringWithRange(start..<end)
    }
//
//    subscript(index:Int) -> Character{
//        return self[advance(self.startIndex, index)]
//    }
//    
//    subscript(subRange:Range<Int>) -> String {
//        return self[advance(self.startIndex, subRange.startIndex)..<advance(self.startIndex, subRange.endIndex)]
//    }
//    
//    // MARK: - 字符串修改 RangeReplaceableCollectionType
//    mutating func insert(newElement: Character, atIndex i: Int) {
//        insert(newElement, atIndex: advance(self.startIndex,i))
//    }
//    
//    mutating func splice(newValues: String, atIndex i: Int) {
//        splice(newValues, atIndex: advance(self.startIndex,i))
//    }
//    
    func replaceRange(startIndex:Int,endIndex:Int, with newValues: String) -> String {
        let start = self.substringFromIndex(startIndex)
        let end = start!.substringToIndex(endIndex)
        let str = self.stringByReplacingOccurrencesOfString(end!, withCharacter: newValues)
        
        return str
    }
//
//    mutating func removeAtIndex(i: Int) -> Character {
//        return removeAtIndex(advance(self.startIndex,i))
//    }
//    
//    mutating func removeRange(subRange: Range<Int>) {
//        let start = advance(self.startIndex, subRange.startIndex)
//        let end = advance(self.startIndex, subRange.endIndex)
//        removeRange(start..<end)
//    }
    
    func separatedByCharacters(separators: String) -> [String] {
        return self.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: separators))
    }
    
    // MARK: - 字符替换
    /// 字符串替换字符
    ///
    /// :param: 旧字符
    /// :param: 新字符
    /// :returns: 新字符串
    func stringByReplacingOccurrencesOfString(oldCharacter: String, withCharacter: String) -> String {
        return self.stringByReplacingOccurrencesOfString(oldCharacter, withString: withCharacter, options: .LiteralSearch, range: nil)
    }
    
    /// 十六进制颜色 #
    var colorWithHexColorString: UIColor? {
        return self.colorWithHexColorString(self, alpha: 1.0)
    }
    
    /// 十六进制颜色  带alpha值
    func colorWithHexColorString(hexColorString: String, alpha: CGFloat) -> UIColor? {
        guard hexColorString.characters.count > 5 else {
            return nil
        }
        
        guard hexColorString.hasPrefix("0x") || hexColorString.hasPrefix("#") else {
            return nil
        }
        var cString: String!
        
        if hexColorString.hasPrefix("0x") {
            cString = hexColorString.substringFromIndex(2)
        } else if hexColorString.hasPrefix("#") {
            cString = hexColorString.substringFromIndex(1)
        }
        
        guard cString.characters.count == 6 else {
            return nil
        }
        
        //r
        let rString = cString.substringWithRange(0..<2)
        
        //g
        let gString = cString.substringWithRange(2..<4)
        
        //b
        let bString = cString.substringWithRange(4..<6)
        
        var red: UInt32 = 0, green: UInt32 = 0, blue: UInt32 = 0
        
        NSScanner(string: rString).scanHexInt(&red)
        NSScanner(string: gString).scanHexInt(&green)
        NSScanner(string: bString).scanHexInt(&blue)
        
        return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: alpha)
    }
    
    /// 设置时间样式
    ///
    /// - returns:  NSDateFormatter
    private func dateFormat(format:String) -> NSDateFormatter {
        let fmt = NSDateFormatter()
        fmt.dateFormat = format
        
        return fmt
    }
    
    
   


}
