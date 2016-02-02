//
//  ViewController.swift
//  tip-calculator
//
//  Created by Satoru Sasozaki on 1/20/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit
import FontAwesome_swift
import UIColor_Hex_Swift
class TCMainViewController: UIViewController, UITextFieldDelegate {
    
    var billField: UITextField?
    var tipField: UITextField?
    var totalField: UITextField?
    var percentageSelection: UISegmentedControl?
    var tipRatio: Double?
    var readArray: [Double]?
    var ud: NSUserDefaults?
    var percentageKey: String?
    var userInputKey: String?
    var tipAmountKey: String?
    var totalAmountKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        ud = NSUserDefaults.standardUserDefaults()
        percentageKey = "percentage"
        userInputKey = "userInput"
        tipAmountKey = "tipAmount"
        totalAmountKey = "totalAmount"
        self.configureLabels()
        self.configureSettingButton()
        self.configureTipPercentages()
        
    }

    func configureSettingButton() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let cogButton = UIBarButtonItem()
        cogButton.target = self
        cogButton.action = "settingButtonTapped"
        self.navigationItem.rightBarButtonItem = cogButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(25)] as Dictionary!
        self.navigationItem.rightBarButtonItem!.setTitleTextAttributes(attributes, forState: .Normal)
        self.navigationItem.rightBarButtonItem!.title = String.fontAwesomeIconWithName(.Cog)
    }
    
    func settingButtonTapped(){
        ud!.setObject(billField!.text, forKey: userInputKey!)
        ud!.setObject(tipField!.text, forKey: tipAmountKey!)
        ud!.setObject(totalField!.text, forKey: totalAmountKey!)
        let settingViewController = TCSettingViewController()
        self.navigationController?.pushViewController(settingViewController, animated: true)
        self.view.endEditing(true)
    }
    
    func configureLabels() {
        billField = UITextField()
        billField?.textAlignment = NSTextAlignment.Right
        billField?.font = UIFont(name: "Verdana", size: 75)
        billField?.minimumFontSize = 1
        billField?.adjustsFontSizeToFitWidth = true
        billField?.contentVerticalAlignment = UIControlContentVerticalAlignment.Bottom
        self.view.addSubview(billField!)
        billField!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(
                item: billField!,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1,
                constant: 64),
            NSLayoutConstraint(
                item: billField!,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.Width,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: billField!,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.Height,
                multiplier: 1,
                constant: 100)
            ]
        )
        
        billField!.backgroundColor = UIColor(rgba: "#247BA0")
        billField?.addTarget(self, action: "billFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        billField?.keyboardType = UIKeyboardType.DecimalPad
        billField?.becomeFirstResponder()
        let previousInput = ud!.objectForKey(userInputKey!) as? String
        billField?.text = previousInput
        
        tipField = UITextField()
        tipField?.userInteractionEnabled = false
        tipField?.textAlignment = NSTextAlignment.Right
        tipField?.font = UIFont(name: "Verdana", size: 30)
        tipField?.minimumFontSize = 1
        tipField?.adjustsFontSizeToFitWidth = true
        tipField?.contentVerticalAlignment = UIControlContentVerticalAlignment.Bottom
        tipField!.backgroundColor = UIColor(rgba: "#70C1B3")
        let previousTipAmount = ud!.objectForKey(tipAmountKey!) as? String
        tipField?.text = previousTipAmount
        self.view.addSubview(tipField!)
        
        tipField!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(
                item: tipField!,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.billField,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: tipField!,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.Width,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: tipField!,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.Height,
                multiplier: 1,
                constant: 50)]
        )
        
        totalField = UITextField()
        totalField?.userInteractionEnabled = false
        totalField?.textAlignment = NSTextAlignment.Right
        totalField?.font = UIFont(name: "Verdana", size: 75)
        totalField?.minimumFontSize = 1
        totalField?.adjustsFontSizeToFitWidth = true
        totalField?.contentVerticalAlignment = UIControlContentVerticalAlignment.Bottom
        totalField?.backgroundColor = UIColor(rgba: "#FF1654")
        let previousTotalAmount = ud!.objectForKey(totalAmountKey!) as? String
        totalField?.text = previousTotalAmount
        
        self.view.addSubview(totalField!)
        totalField!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(
                item: totalField!,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.tipField,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: totalField!,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.Width,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: totalField!,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.Height,
                multiplier: 1,
                constant: 100)
            ]
        )
    }
    
    func setTipRatio(segmentedControl:UISegmentedControl) {
        tipRatio = readArray![segmentedControl.selectedSegmentIndex]
        billFieldDidChange(billField!)
    }
    
    func configureTipPercentages() {
        readArray = ud!.objectForKey(percentageKey!) as? [Double]
        let min:String = String(format: "%.0f%%", readArray![0]*100)
        let mid:String = String(format: "%.0f%%", readArray![1]*100)
        let max:String = String(format: "%.0f%%", readArray![2]*100)
        let percentagesToDisplay = [min, mid, max]

        tipRatio = readArray![1] // by default
        percentageSelection = UISegmentedControl(items: percentagesToDisplay)
        percentageSelection!.selectedSegmentIndex = 1
        percentageSelection!.addTarget(self, action: "setTipRatio:", forControlEvents: .ValueChanged);

        self.view.addSubview(percentageSelection!)
        percentageSelection!.tintColor = UIColor.blackColor()
        percentageSelection?.translatesAutoresizingMaskIntoConstraints = false
 
        self.view.addConstraints([
            NSLayoutConstraint(
                item: percentageSelection! ,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.totalField,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1,
                constant: 20),
            NSLayoutConstraint(
                item: percentageSelection!,
                attribute: NSLayoutAttribute.Left,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.Left,
                multiplier: 1,
                constant: 20),
            NSLayoutConstraint(
                item: percentageSelection!,
                attribute: NSLayoutAttribute.Right,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.Right,
                multiplier: 1,
                constant: -20),
            NSLayoutConstraint(
                item: percentageSelection!,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.Height,
                multiplier: 1,
                constant: 50)
            ])
    }
    
    func billFieldDidChange(textField: UITextField) {
        let billAmount = ((billField?.text)! as NSString).doubleValue
        let tip = billAmount * tipRatio!
        let total = billAmount + tip
        tipField?.text = "\(tip)"
        totalField?.text = "\(total)"
    }
}

