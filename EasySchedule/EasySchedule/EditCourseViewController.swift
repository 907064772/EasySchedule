//
//  EditCourseViewController.swift
//  EasySchedule
//
//  Created by 应吕鹏 on 16/4/17.
//  Copyright © 2016年 应吕鹏. All rights reserved.
//

import UIKit
protocol EditCourseViewControllerDelegate {
    func didSetCourse(course:Course)
    func didEditCourse(course:Course,tag:Int)
    func didDeleteCourse(course:Course,tag:Int)
}

class EditCourseViewController: UITableViewController,SetCourseTimeViewControllerDelegate,SetWeekViewControllerDelegate {
    var stateTag = 0 //0代表添加课程，1代表修改课程信息
    
    var course:Course?
    var layView:UIView?
    var timeInfo:[Int]!
    var weekNum:[Int]!
    var delegate:EditCourseViewControllerDelegate?
    var courseTag:Int!
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var courseNameTF: UITextField!
    @IBOutlet weak var teacherNameTF: UITextField!
    @IBOutlet weak var classroomTF: UITextField!
    @IBOutlet weak var courseNumLabel: UILabel!
    @IBOutlet weak var weekNumLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if stateTag == 0{
            self.course = Course()
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadCourseInfo()
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 自定义方法
    func loadCourseInfo(){
        if stateTag == 1 {
            if let course = course {
                self.courseNameTF.text = course.courseName
                self.teacherNameTF.text = course.teacher
                self.classroomTF.text = course.classroom
                self.weekNumLabel.text = "共\(self.getWeekNum())周"
                self.courseNumLabel.text = "周\(course.day)第\(course.start)至\(course.end)节"
                self.weekNum = course.weekNum
                self.timeInfo = [course.day,course.start,course.end]
                self.title = "修改课程信息"
            }
        }else{
            self.deleteBtn.hidden = true
        }
    }
    func getWeekNum() -> Int {
        var count = 0
        for item in self.course!.weekNum {
            if item == 1 {
                count += 1
            }
        }
        return count
    }

    @IBAction func deleteCourse(sender: AnyObject) {
        
        confirmDelete()
    }
    
    @IBAction func doneBtnClicked(sender: AnyObject) {
        if courseNameTF.text?.isEmpty == false && teacherNameTF.text?.isEmpty == false && classroomTF.text?.isEmpty == false
        {
            //如果是添加课程则初始化一个新课程
            
            course?.courseName = self.courseNameTF.text
            course?.teacher = self.teacherNameTF.text
            course?.classroom = self.classroomTF.text
            course?.day = self.timeInfo[0]
            course?.start = self.timeInfo[1]
            course?.end = self.timeInfo[2]
            course?.weekNum = self.weekNum
            if self.stateTag == 0{
                self.delegate?.didSetCourse(self.course!)
            }else{
                self.delegate?.didEditCourse(self.course!,tag: courseTag)
            }
            
            self.navigationController?.popViewControllerAnimated(true)
            
        }else{
            let alert = UIAlertController(title: "无法提交", message: "信息不能为空", preferredStyle: .Alert)
            let action = UIAlertAction(title: "好的", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func confirmDelete(){
        let alertController = UIAlertController(title: "删除提示", message: "是否删除这门课程", preferredStyle: .Alert)
        let cancleAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "删除", style: .Destructive) { (action) in
            self.delegate?.didDeleteCourse(self.course!, tag: self.courseTag)
            self.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(cancleAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.selected = false
            switch indexPath.row {
            case 0:
                let picker = SetCourseTimeViewController()
                picker.delegate = self
                self.presentViewController(picker, animated: true, completion: nil)
                break
            case 1:
                let weekPicker = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SetWeekViewController") as! SetWeekViewController
                weekPicker.delegate = self
                weekPicker.modalPresentationStyle = .OverCurrentContext
                self.presentViewController(weekPicker, animated: true, completion: nil)
                break
            default:
                break
            }
        }
    }
    
    //MARK: - SetCourseTimeViewControllerDelegate
    func getSelectedResult(result: [Int]!) {
        self.courseNumLabel.text = "周\(result[0])第\(result[1])至\(result[2])节"
        self.timeInfo = result
    }
    //MARK: - SetWeekViewControllerDelegate
    func didSetWeek(week: [Int]) {
        self.weekNum = week
        var weekNum = 0
        for item in week {
            if item == 1{
                weekNum += 1
            }
        }
        self.weekNumLabel.text = "共\(weekNum)周"
    }
}
