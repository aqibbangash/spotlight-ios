//
//  CustomCountryPickView.swift
//  CustomCountryPickView
//
//  Created by Chad on 10/16/15.
//  Copyright © 2015 Chad. All rights reserved.
//
import UIKit

@objc class CustomCountryPickView: UIView {
    
    let countryData:CountryData
    var bg:UIView!
    var flagImageView:UIImageView!
    var countryNameLabel:UILabel!
    
    
    init(countryData:CountryData) {
        
        
        
        
        self.countryData = countryData
        super.init(frame: CGRectZero)
        
        bg = UIView(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        
        self.addSubview(bg)
        
        
        flagImageView = UIImageView()
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let resouceBundle = NSBundle(forClass: self.classForCoder)
        flagImageView.image =  UIImage(named: "FlagImage.bundle/"+countryData.countryCode, inBundle: resouceBundle, compatibleWithTraitCollection: nil)
        addSubview(flagImageView)
        
        let flagImageCenterYConstraint = NSLayoutConstraint.init(item: flagImageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
        self.addConstraint(flagImageCenterYConstraint)
        
        countryNameLabel = UILabel()
        countryNameLabel.textColor = UIColor.whiteColor()
        countryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        countryNameLabel.text = countryData.name
        addSubview(countryNameLabel)
        
        let countryNameCenterYConstraint = NSLayoutConstraint.init(item: countryNameLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
        self.addConstraint(countryNameCenterYConstraint)
        
        
        let variableBindings = [ "flagImageView": flagImageView,"countryNameLabel":countryNameLabel]
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-30-[flagImageView(30)]-10-[countryNameLabel]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: variableBindings)
        self.addConstraints(horizontalConstraints)
        
        let flagImageHeightConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[flagImageView(30)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: variableBindings)
        self.addConstraints(flagImageHeightConstraints)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init error")
    }
    
    
    
}
