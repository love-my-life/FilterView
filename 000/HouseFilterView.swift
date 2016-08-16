//
//  SearchCriteriaView.swift
//  SecondsRent
//
//  Created by blueskyplan on 16/1/31.
//  Copyright © 2016年 LiJianhui. All rights reserved.
//  筛选

import UIKit

/// RGB颜色
func RGB(r:CGFloat,_ g:CGFloat,_ b:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}
/// 主题色
let THEME_COLOR = RGB(85,165,221)

@objc protocol HouseFilterViewDelegate {
    func didSelectRow(row:Int,text:String)
    func dismissListView()
    func selectListViewBtnTitle(title:String)
    func customRange(minText:String,maxText:String)
    optional func didSelectDetailRow(row:Int,text:String)//点击二级菜单
}

class HouseFilterView: UIView, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    var tableView:UITableView?
    var detailTableView : UITableView?
    
    private let rowHeight:CGFloat = 44
    private var btnTitleArr = NSMutableArray()
    
    var line1 : UILabel!
    var line2 : UILabel!
    
    var dataSource = NSMutableArray()
    var detailArray = NSMutableArray()
    
    var zoneBtn : UIButton?
    var metroBtn : UIButton!
    var btnView : UIView!
    var delegate:HouseFilterViewDelegate?
    var footerViewHeight:CGFloat = 0
    var minText : UITextField!
    var maxText : UITextField!
    var unitsText : String = "单位(元)"
    var minPlaceText : String = "最小价格"
    var maxPlaceText : String = "最大价格"
    
    
    init(frame: CGRect, dataSource: NSArray ,detailArray:NSArray, btnTitleArray:NSArray) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.4)
        let view = UIView.init(frame: frame)
        self.addSubview(view)
        
        guard dataSource.count >= 0 else {
            return
        }
        if btnTitleArray.count != 0 {
            self.btnTitleArr.removeAllObjects()
            self.btnTitleArr.addObjectsFromArray(btnTitleArray as [AnyObject])
        }
        self.dataSource.addObjectsFromArray(dataSource as [AnyObject])
        setupTableView()
        addBtn()
        if detailArray.count != 0 {
            self.detailArray.addObjectsFromArray(detailArray as [AnyObject])
            tableView?.backgroundColor = UIColor.groupTableViewBackgroundColor()
        }
        setDetailTableView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
    }
    var btnArr : NSMutableArray! {
        willSet(newValue) {
            self.btnTitleArr = newValue
            print(btnTitleArr[0])
        }
        didSet {
            zoneBtn?.setTitle(btnTitleArr[0] as? String, forState: .Normal)
            metroBtn.setTitle(btnTitleArr[1] as? String, forState: .Normal)
            zoneBtn?.setTitle(btnTitleArr[0] as? String, forState: .Selected)
            metroBtn.setTitle(btnTitleArr[1] as? String, forState: .Selected)
        }
    }
    func addBtn() {
        btnView = UIView()
        btnView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45)
        btnView.backgroundColor = UIColor.whiteColor()
        zoneBtn = getBtn(0,text: btnTitleArr[0] as! String)
        metroBtn = getBtn(self.width/2,text: btnTitleArr[1] as! String)
        btnView.addSubview(zoneBtn!)
        btnView.addSubview(metroBtn)
        line1 = getLine(CGRectMake(0, 44.5, SCREEN_WIDTH, 0.5))
        line2 = getLine(CGRectMake(SCREEN_WIDTH/2, 0, 0.5, 45))
        zoneBtn?.selected = true
        btnView.addSubview(line1)
        btnView.addSubview(line2)
        self.addSubview(btnView)
    }
    func getBtn(x:CGFloat,text:String) -> UIButton {
        
        let btn = UIButton(type: .Custom)
        btn.frame = CGRectMake(x, 0, self.width/2, self.btnView.height)
        btn.backgroundColor = UIColor.whiteColor()
        btn.setBackgroundImage(UIImage(named: ""), forState: .Selected)
        btn.titleLabel?.text = "区域"
        btn.setTitle(text, forState: .Normal)
        btn.setTitle(text, forState: .Selected)
        btn.tintColor = UIColor.darkGrayColor()
        btn.titleLabel?.font = UIFont.systemFontOfSize(14)
        btn.setTitleColor(THEME_COLOR, forState: .Selected)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: ""), forState: .Normal)
        btn.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: .TouchUpInside)
        return btn
    }
    func btnAction(sender:UIButton) {
        zoneBtn?.selected = false
        metroBtn.selected = false
        sender.selected = true
        self.delegate?.selectListViewBtnTitle((sender.titleLabel?.text)!)
    }
    func getLine(frame:CGRect) -> UILabel {
        let label = UILabel()
        label.frame = frame
        label.backgroundColor = LineColor
        return label
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     *  设置TalbeView
     */
    
    private func setupTableView() {
        
        tableView = UITableView()
        layout()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = rowHeight
        tableView?.separatorColor = THEME_COLOR
        tableView?.backgroundColor = UIColor.whiteColor()
        tableView?.userInteractionEnabled = true
        self.addSubview(tableView!)
    }
    private func setDetailTableView() {
        
        detailTableView = UITableView()
        detailTableView?.frame = CGRectMake(self.width/3, 45, self.width * 2/3, 280)
        detailTableView?.delegate = self
        detailTableView?.dataSource = self
        detailTableView?.rowHeight = rowHeight
        detailTableView?.separatorColor = THEME_COLOR
        detailTableView?.backgroundColor = UIColor.whiteColor()
        detailTableView?.userInteractionEnabled = true
        
        self.addSubview(detailTableView!)
    }
    
    /// 刷新数据调用这个方法
    func reloadData(data:NSMutableArray) {
        dataSource.removeAllObjects()
        if data.count != 0 {
            dataSource.addObjectsFromArray(data as [AnyObject])
        }
        tableView?.reloadData()
        
    }
    //刷新二级菜单列表
    func reloadDetailData(detailData:NSMutableArray) {
        detailArray.removeAllObjects()
        if detailData.count != 0 {
            detailArray.addObjectsFromArray(detailData as [AnyObject])
            self.tableView!.backgroundColor = UIColor.groupTableViewBackgroundColor()
            self.tableView?.width = self.width/3
            self.detailTableView?.width = self.width*2/3
        }else{
            self.tableView?.width = self.width
            self.detailTableView?.width = 0
            self.tableView!.backgroundColor = UIColor.whiteColor()
        }
        detailTableView?.reloadData()
    }
    
    /// 选中某一行
    func selectRowAtIndexPath(section:Int?, row: Int?) {
        let fistIndexPath = NSIndexPath(forRow: row==nil ? 0 : row!, inSection: 0)
        let secoundIndexPath = NSIndexPath(forRow: section==nil ? 0 : section!, inSection: 0)
        
        tableView?.selectRowAtIndexPath(secoundIndexPath, animated: true, scrollPosition: .None)
        detailTableView?.selectRowAtIndexPath(fistIndexPath, animated: true, scrollPosition: .None)
        
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return dataSource.count
        }else{
            return detailArray.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId = "SearchCriteriaCell1"
        if tableView == self.tableView {
            cellId = "SearchCriteriaCell1"
        }else{
            cellId = "SearchCriteriaCell2"
        }
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? SearchCriteriaCell
        if (cell == nil) {
            cell = SearchCriteriaCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellId)
        }
        if tableView == self.tableView {
            cell?.textLabel?.text = dataSource[indexPath.row] as? String
            cell?.textLabel?.textAlignment = .Center
            if detailArray.count != 0  {
                cell?.textLabel?.textColor = THEME_COLOR
            }
            
        }else{
            cell?.textLabel?.text = detailArray[indexPath.row] as? String
            let view = UIView.init(frame: cell!.frame)
            view.backgroundColor = UIColor.whiteColor()
            cell!.selectedBackgroundView = view
            
            cell!.frame.origin.x = self.width
            UIView.animateWithDuration(0.2) {
                cell!.frame.origin.x = self.width/3*2
            }
        }
        
        return cell!
    }
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.tableView {
            self.delegate?.didSelectRow(indexPath.row, text: dataSource[indexPath.row] as! String)
        }else{
            self.delegate?.didSelectDetailRow!(indexPath.row, text: detailArray[indexPath.row] as! String)
            dismiss()
        }
        if self.detailArray.count == 0 {
            dismiss()
        }
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.footerViewHeight
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = RGB(240, 240, 240)
        var space : CGFloat = 10
        var btnWidth : CGFloat = 80
        if IS_IPHONE_5 {
            space = 5
            btnWidth = 60
        }else if IS_IPHONE_6{
            space = 10
            btnWidth = 80
        }else if IS_IPHONE_6P{
            space = 15
            btnWidth = 95
        }
        
        let label = UILabel.init(frame: CGRectMake(space, 10, 60, 20))
        label.text = "自定义"
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(14)
        view.addSubview(label)
        let label1 = UILabel.init(frame: CGRectMake(space, 30, 60, 20))
        label1.textColor = UIColor.lightGrayColor()
        label1.font = UIFont.systemFontOfSize(14)
        label1.text = unitsText
        view.addSubview(label1)
        let view1 = UIView.init(frame: CGRectMake(space * 2 + 60, 12, 80, 36))
        view1.backgroundColor = UIColor.whiteColor()
        view1.cornerRadius = 4
        minText = UITextField.init(frame: CGRectMake(10, 0, 70, 36))
        minText.font = UIFont.systemFontOfSize(14)
        minText.placeholder = minPlaceText
        minText.keyboardType = .PhonePad
        view1.addSubview(minText)
        view.addSubview(view1)
        let label2 = UILabel.init(frame: CGRectMake(space * 3 + 140, 20, 10, 20))
        label2.textColor = UIColor.lightGrayColor()
        label2.text = "~"
        view.addSubview(label2)
        let view2 = UIView.init(frame: CGRectMake(space * 4 + 150, 12, 80, 36))
        view2.backgroundColor = UIColor.whiteColor()
        view2.cornerRadius = 4
        maxText = UITextField.init(frame: CGRectMake(10, 0, 70, 36))
        maxText.font = UIFont.systemFontOfSize(14)
        maxText.placeholder = maxPlaceText
        maxText.keyboardType = .PhonePad
        view2.addSubview(maxText)
        view.addSubview(view2)
        let btn = UIButton.init(type: .System)
        btn.backgroundColor = THEME_COLOR
        btn.tintColor = UIColor.whiteColor()
        btn.frame = CGRectMake(space * 5 + 230, 12, btnWidth, 36)
        btn.setTitle("确定", forState: .Normal)
        btn.cornerRadius = 4
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(self.okBtnAction(_:)), forControlEvents: .TouchUpInside)
        return view
    }
    
    func layout() {
        if self.detailArray.count != 0 {
            tableView?.frame = CGRectMake(0, 45, self.width/3, 280)
        }else{
            tableView?.frame = CGRectMake(0, 45, self.width, 280)
        }
    }
    
    /// 关闭筛选条件列表
    func dismiss() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.y = -SCREENHEIGHT
            }) { (finish) -> Void in
                
        }
        self.delegate?.dismissListView()
    }
    
    ///显示筛选列表
    func show() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.y = 104
        }) { (finish) -> Void in
        }
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        print("\(touch.view!.classForCoder)")
        self.endEditing(true)
        if ("\(touch.view!.classForCoder)" == "HouseFilterView") {
            return true
        } else {
            return false
        }
    }
    func okBtnAction(sender:UIButton) {
        if self.maxText.text?.deleteSpace == "" && self.minText.text?.deleteSpace == "" {
            //请输入最小值最大值
            return
        }
        if self.minText.text?.deleteSpace == "" && self.maxText.text?.deleteSpace != "" {
            self.minText.text = "0"
        }
        if self.minText.text?.deleteSpace != "" && self.maxText.text?.deleteSpace == "" {
            self.maxText.text = ""
        }
        self.dismiss()
        self.delegate?.customRange(self.minText.text!, maxText: self.maxText.text!)
    }
    
    deinit {
        print("销毁对象")
    }
}

// 搜索列表Cell
class SearchCriteriaCell: UITableViewCell {
    
    private var selectImageView:UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.detailTextLabel?.hidden = true
        self.textLabel?.textColor = UIColor.lightGrayColor()
        self.textLabel?.font = UIFont.systemFontOfSize(14)
        self.selectionStyle = .Blue
        self.backgroundColor = UIColor.clearColor()
        let view = UIView.init(frame: self.frame)
        view.backgroundColor = UIColor.whiteColor()
        self.selectedBackgroundView = view
        
        selectImageView = UIImageView(image: UIImage(named: "choose"))
        self.contentView.addSubview(selectImageView!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        selectImageView?.hidden = !selected
        let color = UIColor.lightGrayColor()
        
        self.textLabel?.textColor = (!selected) ? color : THEME_COLOR
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectImageView?.frame = CGRectMake(self.contentView.width - 8 - 20, (self.contentView.height-20)/2, 20, 20)
    }
    
}
