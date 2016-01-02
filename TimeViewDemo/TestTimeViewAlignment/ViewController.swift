//
//  ViewController.swift
//  TestTimeViewAlignment
//
//  Created by Richard Clark on 10/10/15.
//  Copyright © 2015 Richard Clark. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timeView: TimeView = TimeView()
    @IBOutlet weak var fontSlider: UISlider?
    @IBOutlet weak var amPmPctSlider: UISlider?
    @IBOutlet weak var timeSlider: UISlider?
    @IBOutlet weak var alignmentChoice: UISegmentedControl?
    @IBOutlet weak var is24HourSwitch: UISwitch?
    @IBOutlet weak var amPmBelowSwitch: UISwitch?

    var startDate: NSDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(timeView)
        timeView.y = 20
        timeView.amPmBelow = true
        timeView.alignment = TimeViewAlignment.Left
//        timeView.debugColors = true
        timeView.backgroundColor = UIColor.darkGrayColor()
        timeView.textColor = UIColor.cyanColor()
        timeView.mainFontName = "HelveticaNeue-Thin"
        timeView.amPmFontName = "HelveticaNeue-Thin"
        timeView.timeIsValid = false
        fontSlider!.value = Float(timeView.mainFontSize)
        amPmPctSlider?.value = Float(timeView.amPmFontSize / timeView.mainFontSize)
        is24HourSwitch?.on = timeView.is24Hour
        amPmBelowSwitch?.on = timeView.amPmBelow
        let comps = NSDateComponents()
        comps.hour = 0
        comps.minute = 0
        startDate = NSCalendar.currentCalendar().dateFromComponents(comps)!
    }

    override func viewDidLayoutSubviews() {
        switch timeView.alignment {
        case .Left:
            timeView.x = 20
        case .Center, .Fixed:
            timeView.centerX = view.width / 2
        case .Right:
            timeView.rightX = view.width - 20
        }
    }
    
    @IBAction func fontSliderValueChanged(sender: UISlider) {
        timeView.mainFontSize = CGFloat(fontSlider!.value)
        timeView.amPmFontSize = CGFloat(amPmPctSlider!.value) * timeView.mainFontSize
        viewDidLayoutSubviews()
    }
    
    @IBAction func amPmPctSliderValueChanged(sender: UISlider) {
        timeView.amPmFontSize = CGFloat(amPmPctSlider!.value) * timeView.mainFontSize
        viewDidLayoutSubviews()
    }
    
    @IBAction func timeSliderValueChanged(sender: UISlider) {
        timeView.time = startDate.dateByAddingTimeInterval(60 * NSTimeInterval(timeSlider!.value))
        timeView.timeIsValid = true
        viewDidLayoutSubviews()
    }
    
    @IBAction func alignmentChoiceChanged(sender: UISegmentedControl) {
        switch alignmentChoice!.selectedSegmentIndex {
        case 0:
            timeView.alignment = TimeViewAlignment.Left
        case 1:
            timeView.alignment = TimeViewAlignment.Center
        case 2:
            timeView.alignment = TimeViewAlignment.Right
        case 3:
            timeView.alignment = TimeViewAlignment.Fixed
        default:
            break;
        }
        viewDidLayoutSubviews()
    }
    
    @IBAction func is24HourSwitchFlipped() {
        timeView.is24Hour = is24HourSwitch!.on
        viewDidLayoutSubviews()
    }
    
    @IBAction func amPmBelowSwitchFlipped() {
        timeView.amPmBelow = amPmBelowSwitch!.on
        viewDidLayoutSubviews()
    }
}

