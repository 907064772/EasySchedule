//
//  Course.swift
//  EasySchedule
//
//  Created by 应吕鹏 on 16/4/17.
//  Copyright © 2016年 应吕鹏. All rights reserved.
//

import UIKit

class Course: NSObject,NSCoding {
    var courseName:String!
    var teacher:String!
    var classroom:String!
    var start:Int!
    var end:Int!
    var day:Int!
    var weekNum:[Int]!
    override init(){
        
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(self.courseName, forKey: "courseName")
        aCoder.encodeObject(self.teacher, forKey: "teacher")
        aCoder.encodeObject(self.classroom, forKey: "classroom")
        aCoder.encodeObject(self.start, forKey: "start")
        aCoder.encodeObject(self.end, forKey: "end")
        aCoder.encodeObject(self.day, forKey: "day")
        aCoder.encodeObject(self.weekNum, forKey: "weekNum")
        
    }
    required init?(coder aDecoder: NSCoder){
        super.init()
        self.courseName = aDecoder.decodeObjectForKey("courseName") as! String
        self.teacher = aDecoder.decodeObjectForKey("teacher") as! String
        self.classroom = aDecoder.decodeObjectForKey("classroom") as! String
        self.start = aDecoder.decodeObjectForKey("start") as! Int
        self.end = aDecoder.decodeObjectForKey("end") as! Int
        self.day = aDecoder.decodeObjectForKey("day") as! Int
        self.weekNum = aDecoder.decodeObjectForKey("weekNum") as! [Int]
        
        
    }
}
