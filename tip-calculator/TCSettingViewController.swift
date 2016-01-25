//
//  TCSettingViewController.swift
//  tip-calculator
//
//  Created by Satoru Sasozaki on 1/21/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
class TCSettingViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    var percentageKey: String?
    var tipPercentages: [Double]?
    var tableView: UITableView?
    var testValue: Double?
    var minValue: Double?
    var midValue: Double?
    var maxValue: Double?
    var ud: NSUserDefaults?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width:UIScreen.mainScreen().bounds.width , height: UIScreen.mainScreen().bounds.height), style: UITableViewStyle.Grouped)
        tableView!.scrollEnabled = false
        tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "data")
        tableView!.dataSource = self
        tableView!.delegate = self
        tableView!.allowsSelection = false
        self.view.addSubview(tableView!)
        
        ud = NSUserDefaults.standardUserDefaults()
        percentageKey = "percentage"
        tipPercentages = ud!.objectForKey(percentageKey!) as? [Double]
        
        minValue = tipPercentages![0]*100
        midValue = tipPercentages![1]*100
        maxValue = tipPercentages![2]*100
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipPercentages!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("data", forIndexPath: indexPath) as UITableViewCell

        if (indexPath.row == 0) {
            let minStepper = UIStepper (frame:CGRectMake(250, 8, 0, 0))
            minStepper.tintColor = UIColor.blackColor()
            minStepper.wraps = true
            minStepper.autorepeat = true
            minStepper.minimumValue = 0
            minStepper.maximumValue = 100
            minStepper.stepValue = 1
            minStepper.value = minValue!
            minStepper.addTarget(self, action: "minValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
            cell.addSubview(minStepper)
            cell.textLabel?.text = String(format: "Min: %.0f%%", minStepper.value)
        } else if (indexPath.row == 1) {
            let midStepper = UIStepper (frame:CGRectMake(250, 8, 0, 0))
            midStepper.tintColor = UIColor.blackColor()
            midStepper.wraps = true
            midStepper.autorepeat = true
            midStepper.minimumValue = 0
            midStepper.maximumValue = 100
            midStepper.stepValue = 1
            midStepper.value = midValue!
            midStepper.addTarget(self, action: "midValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
            cell.addSubview(midStepper)
            testValue = midStepper.value
            cell.textLabel?.text = String(format: "Mid: %.0f%%", testValue!)
        } else {
            let maxStepper = UIStepper (frame:CGRectMake(250, 8, 0, 0))
            maxStepper.tintColor = UIColor.blackColor()
            maxStepper.wraps = true
            maxStepper.autorepeat = true
            maxStepper.minimumValue = 0
            maxStepper.maximumValue = 100
            maxStepper.stepValue = 1
            maxStepper.value = maxValue!
            maxStepper.addTarget(self, action: "maxValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
            cell.addSubview(maxStepper)
            cell.textLabel?.text = String(format: "Max: %.0f%%", maxStepper.value)
        }
        return cell
    }

    func minValueChanged(stepper:UIStepper) {
        minValue = stepper.value
        self.tableView?.reloadData()
    }
    
    func midValueChanged(stepper:UIStepper) {
        midValue = stepper.value
        self.tableView?.reloadData()
    }
    
    func maxValueChanged(stepper:UIStepper) {
        maxValue = stepper.value
        self.tableView?.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let newTipPercentages = [minValue!/100, midValue!/100, maxValue!/100]
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(newTipPercentages, forKey: percentageKey!)
        defaults.synchronize()
        
        let vControllers = self.navigationController?.viewControllers
        let VCindex = vControllers?.count
        
        let prevVC = vControllers![VCindex!-1]
        prevVC.loadView()
        prevVC.viewDidLoad()
    }
}

