//
//  ViewController.swift
//  EasySchedule
//
//  Created by 应吕鹏 on 16/4/16.
//  Copyright © 2016年 应吕鹏. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height
let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("courses")

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,EditCourseViewControllerDelegate {
    @IBOutlet weak var weekCV: UICollectionView!
    @IBOutlet weak var mainCV: UICollectionView!
    var showCount = 0
    var weekItems = ["周一", "周二", "周三", "周四", "周五","周六","周日"]
    var currentSelected:NSIndexPath?
    var imageView = UIImageView()
    
    var courseCellSize:CGSize!
    
    let courseColor = UIColor(red: 74/255, green: 187/255, blue: 230/255, alpha: 1)
    
    var courseArray = [Course]()
    var courseLabelArray = [UILabel]()
    
    lazy var editVC:EditCourseViewController = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EditCourseViewController") as! EditCourseViewController
        vc.delegate = self
        return  vc
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let bgImageView = UIImageView(frame: self.view.frame)
        bgImageView.image = UIImage(named: "bg")
        self.view.insertSubview(bgImageView, belowSubview: weekCV)
        
        weekCV.registerNib(UINib(nibName: "WeekDayCell", bundle: nil), forCellWithReuseIdentifier: "WeekDayCell")
        mainCV.registerNib(UINib(nibName: "WeekDayCell", bundle: nil), forCellWithReuseIdentifier: "WeekDayCell")
        mainCV.registerNib(UINib(nibName: "CourseCell", bundle: nil), forCellWithReuseIdentifier: "CourseCell")
        
        weekCV.alpha = 0.5
        mainCV.alpha = 0.5
        self.automaticallyAdjustsScrollViewInsets = false
        mainCV.reloadData()
        loadCourse()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if showCount == 0{
            for courseItem in self.courseArray {
                drawCourse(courseItem)
            }
            self.showCount += 1
        }
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        var number = 0
        if collectionView == self.weekCV{
            number = 1
        }else if collectionView == self.mainCV {
            number = 1
        }
        return number
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.weekCV {
            return weekItems.count + 1
        }else if collectionView == self.mainCV {
            return ( (self.weekItems.count+1) * 12 )
        }
        return 0
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.weekCV {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WeekDayCell", forIndexPath: indexPath) as! WeekDayCell

            if indexPath.row == 0 {
                cell.dayLabel.text = ""
            }else{
                cell.dayLabel.text = self.weekItems[indexPath.row-1]
                
            }
            return cell

        }else {
            if indexPath.row % 8 == 0 {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WeekDayCell", forIndexPath: indexPath) as! WeekDayCell
                cell.dayLabel.text = "\(indexPath.row / (self.weekItems.count + 1) + 1)"
                return cell
            }else{
                let courseCell = collectionView.dequeueReusableCellWithReuseIdentifier("CourseCell", forIndexPath: indexPath) as! CourseCell
                courseCell.courseLabel.text = ""
                return courseCell
            }

        }
        
        
        
    }

    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView == self.weekCV {
            if (indexPath.row == 0) {
                return CGSizeMake(30, 30)
            }
            else
            {
                return CGSizeMake((SCREEN_WIDTH - 30) / 7, 30)
            }

        }else if collectionView == self.mainCV {
            let rowHeight = CGFloat((SCREEN_HEIGHT - 64  - 30)/12)
            if (indexPath.row % 8 == 0) {
                return CGSizeMake(30, rowHeight)
            }
            else
            {
                self.courseCellSize = CGSizeMake((SCREEN_WIDTH - 30) / 7, rowHeight)
                return self.courseCellSize
            }

        }

        return CGSizeMake(0, 0)
    }
    
    
    //MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == self.mainCV && indexPath.row % (self.weekItems.count + 1) != 0{
            var cell:CourseCell?
            if let currentSelected = currentSelected {
                cell = collectionView.cellForItemAtIndexPath(currentSelected) as? CourseCell
                cell?.contentView.backgroundColor = UIColor.clearColor()
                for item in cell!.contentView.subviews { item.removeFromSuperview() }
            }
            //点击出现加号
            self.currentSelected = indexPath
            cell = collectionView.cellForItemAtIndexPath(currentSelected!) as? CourseCell
            cell?.contentView.backgroundColor = UIColor.lightGrayColor()
            
            imageView.contentMode = .ScaleAspectFit
            imageView.center = cell!.contentView.center
            imageView.bounds.size = CGSizeMake(20, 20)
            imageView.image = UIImage(named: "plus")
            cell?.contentView.addSubview(imageView)
            
            //为加号添加事件
            let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.addCourse))
            imageView.addGestureRecognizer(tap)
            imageView.userInteractionEnabled = true
            
            
        }
    }
    
    //MARK: - 自定义方法
    
    func addCourse(){
        let selectedCell = self.mainCV.cellForItemAtIndexPath(currentSelected!)
        self.imageView.removeFromSuperview()
        selectedCell?.contentView.backgroundColor = UIColor.clearColor()
        currentSelected = nil
        let addCourseVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EditCourseViewController") as! EditCourseViewController
        addCourseVC.delegate = self

        self.navigationController?.pushViewController(addCourseVC, animated: true)
    }
    
    func editCourse(recognizer:UITapGestureRecognizer) {
        let label = recognizer.view as! UILabel
        editVC.stateTag = 1
        editVC.course = self.courseArray[label.tag]
        editVC.courseTag = label.tag
        self.navigationController?.pushViewController(editVC, animated: true)

    }
    func drawCourse(course:Course){
        //计算要画的位
//        let index = 8*(course.start) + course.day
//        let startRowIndexPath = NSIndexPath(forRow: index, inSection: 0)
//        
//        let startCell = self.mainCV.cellForItemAtIndexPath(startRowIndexPath)
        
        
        let rowNum = course.end - course.start + 1
        let width = courseCellSize.width
        let height = courseCellSize.height * CGFloat(rowNum)
        let x = CGFloat(30) + CGFloat(course.day - 1 ) * courseCellSize.width
        let y = CGFloat(30 + 64) + CGFloat(course.start - 1) * courseCellSize.height
        let courseView = UIView(frame: CGRectMake(x, y, width, height))
//        courseView.backgroundColor = courseColor
        courseView.alpha = 0.8
        self.view.insertSubview(courseView, aboveSubview: self.mainCV)
        
        let courseInfoLabel = UILabel(frame: CGRectMake(0,2,courseView.frame.size.width-2,courseView.frame.size.height-2))
        courseInfoLabel.numberOfLines = 5
        courseInfoLabel.font = UIFont.systemFontOfSize(12)
        courseInfoLabel.textAlignment = .Left
        courseInfoLabel.textColor = UIColor.whiteColor()
        courseInfoLabel.text = "\(course.courseName)@\(course.classroom)"
        courseInfoLabel.tag = self.courseArray.indexOf(course)!
        courseInfoLabel.layer.cornerRadius = 5
        courseInfoLabel.layer.masksToBounds = true
        courseInfoLabel.backgroundColor = courseColor
        courseView.addSubview(courseInfoLabel)
        
        self.courseLabelArray.append(courseInfoLabel)
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.editCourse(_:)))
        courseInfoLabel.addGestureRecognizer(tap)
        courseInfoLabel.userInteractionEnabled = true

        
        
    }
    
    
    //MARK: - EditCourseViewControllerDelegate
    func didSetCourse(course: Course) {
        courseArray.append(course)
        saveCourse()
        drawCourse(course)
        
        
    }
    func didEditCourse(course: Course,tag:Int) {
        self.courseArray[tag] = course
        saveCourse()
        let courseLabel = self.courseLabelArray[tag]
        courseLabel.text = "\(course.courseName)@\(course.classroom)"
        self.courseArray[tag] = course
        saveCourse()
    }
    
    func didDeleteCourse(course:Course,tag:Int){
        let courseView = self.courseLabelArray[tag].superview
        courseView?.removeFromSuperview()
        self.courseArray.removeAtIndex(tag)
        self.courseLabelArray.removeAtIndex(tag)
        saveCourse()
    }
    
    
    //MARK: - 数据持久化
    func saveCourse() {
        let data = NSMutableData()
        //申明一个归档处理对象
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        //将lists以对应Checklist关键字进行编码
        archiver.encodeObject(self.courseArray, forKey: "courses")
        //编码结束
        archiver.finishEncoding()
        //数据写入
        data.writeToFile(ArchiveURL.path!, atomically: true)
    }
    
    func loadCourse(){
        //获取本地数据文件地址
        let path = ArchiveURL.path
        //声明文件管理器
        let defaultManager = NSFileManager()
        
        //通过文件地址判断数据文件是否存在
        if defaultManager.fileExistsAtPath(path!) {
            //读取文件数据
            let data = NSData(contentsOfFile: path!)
            //解码器
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)
            //通过归档时设置的关键字Checklist还原lists
            self.courseArray = unarchiver.decodeObjectForKey("courses") as! Array
            //结束解码
            unarchiver.finishDecoding()
            for item in courseArray {
                print(item.courseName)
            }
        }

    }

    
    
        
}

