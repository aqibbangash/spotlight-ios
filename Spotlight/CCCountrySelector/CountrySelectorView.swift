//
//  CountrySelectorView.swift
//  CCCountrySelector
//
//  Created by Chad on 10/16/15.
//  Copyright © 2015 Chad. All rights reserved.
//

import UIKit

@objc public protocol CountrySelectorViewDelegate:class {
    func layoutPickView(myPickerView:UIPickerView)
    func showPickInView()->UIView
    func phoneCodeDidChange(myPickerView:UIPickerView,phoneCode:String)
}

@objc public class CountrySelectorView: UIView,UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    var flagImageView: UIImageView
    var phoneCodeLabel: UILabel
    public weak var delegate: CountrySelectorViewDelegate?
    
    var countryDataList:[CountryData] = []
    
    var pickerView: UIPickerView
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        flagImageView = UIImageView.init()
        phoneCodeLabel = UILabel.init()
        pickerView = UIPickerView.init()
        super.init(frame: frame)
        setup()
        pickerView.backgroundColor = UIColor.clearColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        flagImageView = UIImageView.init()
        phoneCodeLabel = UILabel.init()
        
        phoneCodeLabel.hidden = true
        pickerView = UIPickerView.init()
        super.init(coder: aDecoder)
        setup()
    }
    
    
    private func setup() {
        
        do {
            let resouceBundle = NSBundle(forClass: self.classForCoder)
            let path = resouceBundle.pathForResource("diallingcode", ofType: "json")
            
            let dataStr = try NSString(contentsOfFile: path!,
                encoding: NSUTF8StringEncoding)
            
            
            let jsonData: AnyObject = try! NSJSONSerialization.JSONObjectWithData(
                dataStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!,
                options: [])
            
            var tempCountrylist:[CountryData] = []
            
            if let jsonItems = jsonData as? NSArray {
                for itemDesc in jsonItems {
                    let item: CountryData = CountryData.init(name: itemDesc["name"] as! String!, countryCode: itemDesc["code"] as! String!, phoneCode: (itemDesc["dial_code"] as! String!))
                    
                    tempCountrylist.append(item)
                }
                
            }
            
            countryDataList = tempCountrylist
            
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.userInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action:Selector("showPicker"))
        self.addGestureRecognizer(tapGesture)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        updateView(0)
        
        
        
        phoneCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneCodeLabel.textAlignment = .Left
        self.addSubview(phoneCodeLabel)
        phoneCodeLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Horizontal)
        
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        flagImageView.contentMode = .ScaleAspectFit
        self.addSubview(flagImageView)
        flagImageView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: UILayoutConstraintAxis.Horizontal)
        
        
        let variableBindings = ["flagImageView": flagImageView, "phoneCodeLabel": phoneCodeLabel]
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[flagImageView]-10-[phoneCodeLabel]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: variableBindings)
        self.addConstraints(horizontalConstraints)
        
        
        
        
        let phoneCodeLabelImageViewVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[phoneCodeLabel]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: variableBindings)
        self.addConstraints(phoneCodeLabelImageViewVerticalConstraints)
        
        let flagImageViewVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[flagImageView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: variableBindings)
        self.addConstraints(flagImageViewVerticalConstraints)
        
        
    }
    
    public func setDefaultCountry(country:String) {
        
        let indexToSelect = countryDataList.indexOf({$0.countryCode == country})
        
        if let indexToSelect = indexToSelect {
            pickerView.selectRow(indexToSelect, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: indexToSelect, inComponent: 0)
        }
    }
    
    public func setFrequentCountryList(countryList:[String]) {
        
        let currentSelectCountry = countryDataList[pickerView.selectedRowInComponent(0)]
        
        for frequestCountryCode in countryList.reverse() {
            let indexAtFound = countryDataList.indexOf({$0.countryCode == frequestCountryCode})
            if let indexAtFound = indexAtFound {
                countryDataList.insert(countryDataList[indexAtFound], atIndex: 0)
            }
        }
        
        
        if let foundIndex = countryDataList.indexOf({$0.countryCode == currentSelectCountry.countryCode})
        {
            pickerView.selectRow(foundIndex, inComponent: 0, animated: false)
        }
        
    }
    
    
    func updateView(selectRow:Int) {
        let countryData = countryDataList[selectRow]
        // self.phoneCodeLabel.text =  countryData.phoneCode
        self.phoneCodeLabel.textColor = UIColor.whiteColor()
        
        let resouceBundle = NSBundle(forClass: self.classForCoder)
        self.flagImageView.image =  UIImage(named: "FlagImage.bundle/"+countryData.countryCode.lowercaseString, inBundle: resouceBundle, compatibleWithTraitCollection: nil)  }
    
    func showPicker(){
        delegate?.showPickInView().addSubview(pickerView);
        delegate?.layoutPickView(pickerView)
    }
    
    
    func hidePicker(){
        pickerView.removeFromSuperview()
    }
    
    
    //MARK: UIPickerView Delegate & DataSource
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryDataList.count;
    }
    
    
    public func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        var customCountryPickView = view as? CustomCountryPickView
        
        let countryData = countryDataList[row]
        customCountryPickView = CustomCountryPickView(countryData: countryData)
        
        return customCountryPickView!
    }
    
    
    public func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 44.0
        
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let countryData = countryDataList[row]
        delegate?.phoneCodeDidChange(pickerView, phoneCode: countryData.phoneCode)
        updateView(row)
        //hidePicker()
    }
    
    
    
    
}
