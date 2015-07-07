//
//  AttendanceCell.swift
//  iCamel
//
//  Created by Sayan Das on 04/07/15.
//  Copyright © 2015 Sayan Das. All rights reserved.
//

import UIKit

class AttendanceCell: UICollectionViewCell {
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var subjectCode: UILabel!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var percantageView: UIView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var subjectView: UIView!
   
    
    var data: evarsity.AttendanceDetails!{
        didSet {
            updateUI()
        }
    }
    
    //MARK :- Common elements of the cell update
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        
        subjectView.layer.cornerRadius = 5.0
        subjectView.clipsToBounds = true
    }
    
    func updateUI(){
        subject.text = data.Subject as String
        subjectCode.text = data.subjectCode as String
        
        let progressBar = MCPercentageDoughnutView(frame: progressBarView.frame)
        
        progressBar.percentage = CGFloat(NSNumberFormatter().numberFromString(data.Total)!)/100
        progressBar.linePercentage = 0.15
        progressBar.animationDuration = 2.0
        progressBar.decimalPlaces = 2
        progressBar.showTextLabel = false
        progressBar.animatesBegining = true
        progressBar.fillColor = UIColor.orangeColor()
        progressBar.unfillColor = MCUtil.iOS7DefaultGrayColorForBackground()
        progressBar.textLabel.textColor = UIColor.blackColor()
        progressBar.gradientColor1 = UIColor.orangeColor()
        progressBar.gradientColor2 = MCUtil.iOS7DefaultGrayColorForBackground()
        progressBar.enableGradient = true
        progressBar.roundedBackgroundImage = UIImage(named: "rounded-shadowed-background")
        
        progressBar.frame.origin.x = 0
        progressBar.frame.origin.y = 0
        
        percentageLabel.text = data.Total + "%"
        
        progressBarView.addSubview(progressBar)
        progressBar.addSubview(percantageView)
        
        
    }
    
}
