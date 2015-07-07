//
//  AttendanceOverView.swift
//  iCamel
//
//  Created by Sayan Das on 04/07/15.
//  Copyright © 2015 Sayan Das. All rights reserved.
//

import UIKit

class AttendanceOverView: UIViewController {
    
    
    //MARK :- Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK :- Globals Variables
    var UserDetails = NSUserDefaults.standardUserDefaults().objectForKey("UserDetails") as! NSDictionary
    var AttendanceDetails: [evarsity.AttendanceDetails]!
    var evarsityDetails: evarsity = evarsity()
    
    //MARK :-  Cell ID
    private struct Storyboard{
        static let CellIndentifier = "AttendenceCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        evarsityDetails = evarsity(ID: UserDetails["RegisterNo"] as! String, Password: UserDetails["Password"] as! String)
        AttendanceDetails = evarsityDetails.fetchAndReturnData()
        
        NSLog("Sucessfully retrieved data from Evarsity.")
    }
    
    //MARK :- Set Status Bar Style as white
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}


extension AttendanceOverView: UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AttendanceDetails.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellIndentifier, forIndexPath: indexPath) as! AttendanceCell
        
        cell.data = AttendanceDetails[indexPath.item]
        return cell
    }
    
}

extension AttendanceOverView: UIScrollViewDelegate{
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout  = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpace = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.memory
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpace
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpace - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.memory = offset
    }
}

