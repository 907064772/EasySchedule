//
//  SetWeekViewController.swift
//  EasySchedule
//
//  Created by 应吕鹏 on 16/4/20.
//  Copyright © 2016年 应吕鹏. All rights reserved.
//

import UIKit

protocol SetWeekViewControllerDelegate {
    func didSetWeek(week:[Int])
}

class SetWeekViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var weekCV: UICollectionView!
    var selectedWeek:[Int] = Array.init(count: 25, repeatedValue: 0)
    let selecedColor = UIColor(red: 128/288, green: 169/255, blue: 1/255, alpha: 1)
    let unselectedColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    var layView:UIView?
    var delegate:SetWeekViewControllerDelegate?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.modalPresentationStyle = .OverFullScreen
        self.view.backgroundColor = UIColor.clearColor()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        layView = UIView(frame: CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-240))
        layView?.backgroundColor = UIColor.blackColor()
        layView?.alpha = 0.2
        self.view.addSubview(layView!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(SetWeekViewController.cancle))
        layView?.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("weekCell", forIndexPath: indexPath) as! SetWeekCell
        cell.weekNumLabel.text = "\(indexPath.row + 1)"
        return cell
        
    }
    
    //MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let currentCell = collectionView.cellForItemAtIndexPath(indexPath) as! SetWeekCell
        if !currentCell.choosen {
            currentCell.contentView.backgroundColor = selecedColor
            self.selectedWeek[indexPath.row] = 1
        }else{
            currentCell.contentView.backgroundColor = unselectedColor
            self.selectedWeek[indexPath.row] = 0
        }
        currentCell.choosen = !currentCell.choosen
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let height:CGFloat = collectionView.frame.size.height/5
        let width = collectionView.frame.size.width/5
        return CGSizeMake(width, height)
    }
    //MARK - Custom Function
    @IBAction func doneBtnClicked(sender: AnyObject) {
        self.delegate?.didSetWeek(self.selectedWeek)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancle(){
        self.layView?.hidden = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
