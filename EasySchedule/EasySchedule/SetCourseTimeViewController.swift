//
//  SetCourseTimeViewController.swift
//  EasySchedule
//
//  Created by 应吕鹏 on 16/4/25.
//  Copyright © 2016年 应吕鹏. All rights reserved.
//

import UIKit

protocol SetCourseTimeViewControllerDelegate {
    func getSelectedResult(result:[Int]!)
}

class SetCourseTimeViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    let weekDayArray = ["周一","周二","周三","周四","周五","周六","周日"]
    let startArray = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    let endArray = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    
    var pickerView:UIPickerView?
    
    var dataArray:[AnyObject] = []//数据源
    var columns = 3//列数
    var layView:UIView?
    
    var selectedResult:[Int]?
    
    var delegate:SetCourseTimeViewControllerDelegate?
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .OverFullScreen
        self.view.backgroundColor = UIColor.clearColor()
        //初始化pickerView
        pickerView = UIPickerView(frame: CGRectMake(0,UIScreen.mainScreen().bounds.height-200,UIScreen.mainScreen().bounds.width,200))
        pickerView?.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(pickerView!)
        pickerView?.dataSource = self
        pickerView?.delegate = self
        dataArray.append(weekDayArray)
        dataArray.append(startArray)
        dataArray.append(endArray)
        
        //初始化选择器的状态栏
        let pickerBar = UIView(frame: CGRectMake(0,UIScreen.mainScreen().bounds.height - pickerView!.frame.size.height - 40,UIScreen.mainScreen().bounds.width,40))
        pickerBar.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.view.addSubview(pickerBar)
        let doneBtn = UIButton(type: .System)
        doneBtn.setTitle("完成", forState: .Normal)
        doneBtn.titleLabel?.font = UIFont.systemFontOfSize(17)
        doneBtn.frame = CGRectMake(pickerBar.frame.size.width - 50, 5, 40, 25)
        doneBtn.addTarget(self, action: #selector(self.doneBtnClicked), forControlEvents: .TouchUpInside)
        pickerBar.addSubview(doneBtn)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedResult = Array<Int>.init(count: self.columns, repeatedValue: 1)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        layView = UIView(frame: CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-240))
        layView?.backgroundColor = UIColor.blackColor()
        layView?.alpha = 0.2
        //为点击view添加tap动作
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.cancle))
        self.layView!.addGestureRecognizer(tap)
        self.layView!.userInteractionEnabled = true
        self.view.addSubview(layView!)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doneBtnClicked() {
        if let delegate = self.delegate {
            delegate.getSelectedResult(self.selectedResult)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancle() {
        self.layView?.hidden = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - UIPickerViewDataSource
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.dataArray[component].count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return columns
    }
    
    //MARK: - UIPickerViewDelegate
    
    //每行的高度
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    //每列的宽度
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.view.frame.width / CGFloat( columns )
    }
    
    //自定义列的每行的视图即指定每行视图的行为一致
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, var reusingView view: UIView?) -> UIView {
        if (view == nil) {
            view = UIView()
        }
        
        let label = UILabel(frame: CGRectMake(0,0,self.view.frame.width / CGFloat( columns ), 20 ))
        if component == 2 {
            label.text = "至" + (dataArray[component][row] as? String )!
        }else{
            label.text = dataArray[component][row] as? String
        }
        label.textAlignment = .Center
        view?.addSubview(label)
        return view!
        
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedResult![component] = row + 1
    }
    
    
    
    
}
