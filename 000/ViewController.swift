//
//  ViewController.swift
//  000
//
//  Created by hanchen on 16/5/6.
//  Copyright © 2016年 LiJianhui. All rights reserved.
//

import UIKit

private let screenSize = UIScreen.mainScreen().bounds.size

/// 屏幕宽度
let SCREEN_WIDTH = screenSize.width
/// 屏幕高度
let SCREEN_HEIGHT = screenSize.height

class ViewController: UIViewController , HousingToolBarDelegate,HouseFilterViewDelegate {
    
    
    @IBOutlet var naviView: UIView!
    var selectBarIndex = 100
    var filterView : HouseFilterView!
    var currentSelectButton : SelectButton!
    var housingToolBar : HousingToolBar!
    var datasourceArray = NSMutableArray()
    var detailArray = NSMutableArray()
    var listDic = NSMutableDictionary()//记录row
    var titleDic = NSMutableDictionary()//记录section
    var titleArray = ["地区","面积","价格","装修"]
    var listViewBtnTitle1 : String = "区域"
    var listViewBtnTitle4 : String = "装修"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setFilterView()
        setTooBar()
        self.view.backgroundColor = UIColor.brownColor()
        self.view.bringSubviewToFront(naviView)
    }
    func setTooBar() {
        housingToolBar = HousingToolBar.init(frame: CGRectMake(0, 64, self.view.bounds.size.width, 40), btnTitles: titleArray)
        housingToolBar.delegate = self
        self.view.addSubview(housingToolBar)
        
    }
    func setFilterView() {
        filterView = HouseFilterView.init(frame: CGRectMake(0, -SCREENHEIGHT, SCREEN_WIDTH , SCREENHEIGHT), dataSource: ["不限","南山区","龙华区","宝安区","福田区"] ,detailArray: [],btnTitleArray: ["区域","地铁"] )
        filterView.delegate = self
        filterView.selectRowAtIndexPath(0, row: 0)
        self.view.addSubview(filterView)
    }
    
    func reloadData(index:Int) {
        datasourceArray.removeAllObjects()
        detailArray.removeAllObjects()
        let section = titleDic.objectForKey("\(index)") as? Int        
        if (self.selectBarIndex == 0){
            filterView.btnArr = ["区域","地铁"]
            if listViewBtnTitle1 == "区域" {
                datasourceArray.addObjectsFromArray(["不限","南山区","龙华区","宝安区","福田区"])
                if(section == 1){
                    detailArray.addObjectsFromArray(["不限","龙华","西乡","淘净","天气安","是的","输的","大厦","装修"])
                }else if(section == 2){
                    detailArray.addObjectsFromArray(["不限","是的","输的","大厦","装修"])
                }else if(section == 3){
                    detailArray.addObjectsFromArray(["不限","西乡","淘净","输的","大厦","装修"])
                }else if(section == 4){
                    detailArray.addObjectsFromArray(["不限","西乡","装修"])
                }
                filterView.zoneBtn?.selected = true
                filterView.metroBtn.selected = false
            }else if listViewBtnTitle1 == "地铁"{
                datasourceArray.addObjectsFromArray(["jkdsgf","sdkufh","sdgj","afdjgh"])
                if(section == 1){
                    detailArray.addObjectsFromArray(["不限","龙华","西乡","淘净","天气安","是的","输的","大厦","装修"])
                }else if(section == 2){
                    detailArray.addObjectsFromArray(["不限","是的","输的","大厦","装修"])
                }else if(section == 3){
                    detailArray.addObjectsFromArray(["不限","西乡","淘净","输的","大厦","装修"])
                }else if(section == 4){
                    detailArray.addObjectsFromArray(["不限","西乡","装修"])
                }
                filterView.zoneBtn?.selected = false
                filterView.metroBtn.selected = true
            }
        }else if self.selectBarIndex == 1 {
            datasourceArray.addObjectsFromArray(["不限","0~100","100~200","200~300","300~400"])
            filterView.unitsText = "单位(㎡)"
            filterView.minPlaceText = "最小面积"
            filterView.maxPlaceText = "最大面积"
        }else if (self.selectBarIndex == 2){
            datasourceArray.addObjectsFromArray(["不限","0~100元","100~200元","200~300元","300~400元"])
            filterView.unitsText = "单位(元)"
            filterView.minPlaceText = "最小价位"
            filterView.maxPlaceText = "最大价位"
        }else{
            filterView.btnArr = ["装修","类型"]
            if listViewBtnTitle4 == "装修" {
                datasourceArray.addObjectsFromArray(["不限","简装","精装","毛坯"])
                filterView.zoneBtn?.selected = true
                filterView.metroBtn.selected = false
            }else if listViewBtnTitle4 == "类型"{
                datasourceArray.addObjectsFromArray(["不限","众创空间","商务中心","创意产业园","写字楼","工位"])
                filterView.zoneBtn?.selected = false
                filterView.metroBtn.selected = true
            }
            
        }
        filterView.reloadData(datasourceArray)
        filterView.reloadDetailData(detailArray)
        let row = listDic.objectForKey("\(index)") as? Int
        filterView.selectRowAtIndexPath(section, row: row)
        
    }
    //   ---    HousingToolBarDelegate  ---
    func didSelectButtonIndex(index: Int, selectButton: SelectButton) {
        currentSelectButton = selectButton
        self.selectBarIndex = index
        if index == 1 || index == 2 {
            filterView.btnView?.hidden = true
            filterView.tableView?.y = 0
            filterView.footerViewHeight = 60
        }else{
            filterView.btnView?.hidden = false
            filterView.tableView?.y = 45
            filterView.footerViewHeight = 0
        }
        if selectButton.selected {
            filterView.show()
            reloadData(index)
        }else{
           filterView.dismiss()
        }
        
    }
    
    //   ---   FilterViewDelegate  ---
    func dismissListView() {
        self.currentSelectButton.selected = false
        self.housingToolBar.botView?.hidden = true
    }
    func didSelectRow(row: Int, text: String) {
        if row != 0 {
            currentSelectButton?.setTitle(text, forState: .Normal)
        }else{
            currentSelectButton?.setTitle(titleArray[self.selectBarIndex], forState: .Normal)
        }
        filterView.selectRowAtIndexPath(row, row: 0)
        titleDic.setValue(row, forKey: "\(self.selectBarIndex)")
        listDic.setValue(0, forKey: "\(self.selectBarIndex)")
        reloadData(self.selectBarIndex)
    }
    func didSelectDetailRow(row: Int, text: String) {
        currentSelectButton.selected = false
        housingToolBar.botView?.hidden = true
        currentSelectButton?.setTitle(text, forState: .Normal)
        listDic.setValue(row, forKey: "\(self.selectBarIndex)")
    }
    func selectListViewBtnTitle(title:String) {
        if self.selectBarIndex == 0 {
            self.listViewBtnTitle1 = title
        }else if self.selectBarIndex == 3{
            self.listViewBtnTitle4 = title
        }
        
        titleDic.setValue(0, forKey: "\(self.selectBarIndex)")
        listDic.setValue(0, forKey: "\(self.selectBarIndex)")
        reloadData(self.selectBarIndex)
    }
    func customRange(minText: String, maxText: String) {
        titleDic.setValue(10000, forKey: "\(self.selectBarIndex)")
        if maxText != "" {
            if self.selectBarIndex == 1 {
                self.currentSelectButton.setTitle(minText + "-" + maxText + "㎡" , forState: .Normal)
            }else if self.selectBarIndex == 2{
                self.currentSelectButton.setTitle(minText + "-" + maxText + "元/m²·月" , forState: .Normal)
            }
        }else{
            if self.selectBarIndex == 1 {
                self.currentSelectButton.setTitle(minText + "㎡以上" , forState: .Normal)
            }else if self.selectBarIndex == 2{
                self.currentSelectButton.setTitle(minText + "元以上" , forState: .Normal)
            }
        }
        
    }
    

}

