//
//  TimeView.swift
//
//  Created by Richard Clark on 8/9/15.
//  Copyright (c) 2015 Richard Clark. All rights reserved.
//
//

import UIKit

/// Alignment - Fixed means that the colon and AM/PM label don't move
@objc enum TimeViewAlignment: Int, CustomStringConvertible {
    case Left, Center, Right, Fixed
    var description: String {
        get {
            switch self {
            case .Left:
                return ".Left"
            case .Center:
                return ".Center"
            case .Right:
                return ".Right"
            case .Fixed:
                return ".Fixed"
            }
        }
    }
}

/**
Cocoa Touch view that shows a time in 12-hour or 24-hour format. The time is formatted per
WWDC 2013 Session 223 — Using Fonts with Text Kit.
*/
@IBDesignable @objc class TimeView: UIView {
    
    /// Font for the hour, minute, and colon.
    var mainFont: UIFont = UIFont.systemFontOfSize(36) {
        didSet {
            mainFont = fontWithTimeAppearance(mainFont)
            fixedHourLabel.font = mainFont
            fixedMinuteLabel.font = mainFont
            hourAndMinuteLabel.font = mainFont
            layoutSubviews()
            invalidateIntrinsicContentSize()
        }
    }
    @IBInspectable var mainFontName: String = "Helvetica" {
        didSet {
            if mainFontName != oldValue {
                setMainFont()
            }
        }
    }
    @IBInspectable var mainFontSize: CGFloat = 36 {
        didSet {
            if mainFontSize != oldValue {
                setMainFont()
            }
        }
    }
    
    var sizeHour = CGSizeZero
    var maxSizeHour = CGSizeZero
    var sizeMinute = CGSizeZero
    var maxSizeMinute = CGSizeZero
    var sizeAmPm = CGSizeZero
    var maxSizeAmPm = CGSizeZero
    
    func computeSizeHour() -> CGSize {
        if let text = fixedHourLabel.text {
            let size = text.sizeWithAttributes([NSFontAttributeName:mainFont])
            return size
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func computeMaxSizeHour() -> CGSize {
        var maxSize = CGSize(width: 0, height: 0)
        var twoDigitHourBegin, twoDigitHourEnd: Int
        if !is24Hour {
            twoDigitHourBegin = 10
            twoDigitHourEnd = 12
        }
        else {
            twoDigitHourBegin = 20
            twoDigitHourEnd = 23
        }
        for i in twoDigitHourBegin...twoDigitHourEnd {
            let text = NSString(format: "%d", i)
            let size = text.sizeWithAttributes([NSFontAttributeName: mainFont])
            maxSize.width = max(size.width, maxSize.width)
            maxSize.height = max(size.height, maxSize.height)
        }
        return maxSize
    }
    
    func computeSizeMinute() -> CGSize {
        if let size = fixedMinuteLabel.text?.sizeWithAttributes([NSFontAttributeName: mainFont]) {
            return size;
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func computeMaxSizeMinute() -> CGSize {
        var maxSize = CGSize(width: 0, height: 0)
        for i in 20...60 {
            let size = String(format: ":%d", i).sizeWithAttributes([NSFontAttributeName: mainFont])
            maxSize.width = max(size.width, maxSize.width)
            maxSize.height = max(size.height, maxSize.height)
        }
        return maxSize
    }
    
    func computeSizeAmPm() -> CGSize {
        if let size = fixedAmPmLabel.text?.sizeWithAttributes([NSFontAttributeName: amPmFont]) {
            return size;
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func computeMaxSizeAmPm() -> CGSize {
        var maxSize = CGSize(width: 0, height: 0)
        let amString = amPmBelow ? "AM" : " AM"
        let pmString = amPmBelow ? "PM" : " PM"
        let sizeAm = String(amString).sizeWithAttributes([NSFontAttributeName: amPmFont])
        let sizePm = String(pmString).sizeWithAttributes([NSFontAttributeName: amPmFont])
        maxSize.width = max(sizeAm.width, sizePm.width)
        maxSize.height = max(sizeAm.height, sizePm.height)
        return maxSize
    }
    
    func setMainFont() {
        if let font = UIFont(name: mainFontName, size: mainFontSize) {
            mainFont = font
            if alignment == .Fixed {
                sizeHour = computeSizeHour()
                maxSizeHour = computeMaxSizeHour()
                sizeMinute = computeSizeMinute()
                maxSizeMinute = computeMaxSizeMinute()
            }

            inset = mainFont.ascender - mainFont.capHeight
            edgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    
            layoutSubviews()
            invalidateIntrinsicContentSize()
        }
    }
    
    /**
    Font for "AM" or "PM". TimeView does not render properly if this font is larger than the
    time font.
    */
    var amPmFont: UIFont = UIFont.systemFontOfSize(12) {
        didSet {
            fixedAmPmLabel.font = amPmFont
            amPmLabel.font = amPmFont
            if alignment == .Fixed {
                sizeAmPm = computeSizeAmPm()
                maxSizeAmPm = computeMaxSizeAmPm()
            }
            layoutSubviews()
            invalidateIntrinsicContentSize()
        }
    }
    @IBInspectable var amPmFontName: String = "Helvetica" {
        didSet {
            setAmPmFont()
        }
    }
    @IBInspectable var amPmFontSize: CGFloat = 18 {
        didSet {
            setAmPmFont()
        }
    }
    
    func setAmPmFont() {
        if let font = UIFont(name: amPmFontName, size: amPmFontSize) {
            amPmFont = font
        }
    }
    
    /// true if the AM/PM label should be below the time, otherwise to the right of the time
    @IBInspectable var amPmBelow: Bool = false {
        didSet {
            setTimeText()
            if alignment == .Fixed {
                sizeAmPm = computeSizeAmPm()
                maxSizeAmPm = computeMaxSizeAmPm()
            }
            layoutSubviews()
            invalidateIntrinsicContentSize()
        }
    }
    
    /// Offset for the AM/PM part of label, to adjust spacing and alignment.
    @IBInspectable var amPmOffset: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            layoutSubviews()
            invalidateIntrinsicContentSize()
        }
    }
    
    /// Alignment: left, center, right, or keep the colon and AM/PM label fixed
    var alignment: TimeViewAlignment = TimeViewAlignment.Center {
        didSet {
            if alignment != oldValue && alignment == .Fixed {
                sizeHour = computeSizeHour()
                maxSizeHour = computeMaxSizeHour()
                sizeMinute = computeSizeMinute()
                maxSizeMinute = computeMaxSizeMinute()
                sizeAmPm = computeSizeAmPm()
                maxSizeAmPm = computeMaxSizeAmPm()
            }
            layoutSubviews()
            invalidateIntrinsicContentSize()
        }
    }    
    @IBInspectable var alignmentType: String {
        get {
            switch alignment {
            case .Left:
                return "Left"
            case .Center:
                return "Center"
            case .Right:
                return "Right"
            case .Fixed:
                return "Fixed"
            }
        }
        set(newAlignmentType) {
            switch newAlignmentType.lowercaseString {
                case "left":
                    alignment = .Left
                case "center":
                    alignment = .Center
                case "right":
                    alignment = .Right
                case "fixed":
                    alignment = .Fixed
            default:
                alignment = .Center
            }
        }
    }
    
    /// true for 24-hour format (no AM/PM, hours 0 to 23).
    @IBInspectable var is24Hour: Bool = false {
        didSet {
            fixedAmPmLabel.hidden = is24Hour || alignment != .Fixed
            amPmLabel.hidden = is24Hour || alignment == .Fixed
            setTimeText()
            layoutSubviews()
            invalidateIntrinsicContentSize()
        }
    }
    
    /// Edge inset.
    private(set) var inset: CGFloat = 0.0
    
    // Externally visible edge insets
    private(set) var edgeInsets = UIEdgeInsetsZero
    
    /// Color of the time text.
    @IBInspectable var textColor: UIColor = UIColor.blackColor() {
        didSet {
            fixedHourLabel.textColor = textColor
            fixedMinuteLabel.textColor = textColor
            fixedAmPmLabel.textColor = textColor
            hourAndMinuteLabel.textColor = textColor
            amPmLabel.textColor = textColor
        }
    }
    
    /// The time to display.
    var time: NSDate? {
        didSet {
            setTimeText()
            layoutSubviews()
            invalidateIntrinsicContentSize()
        }
    }
    
    var timeIsValid: Bool = true {
        didSet {
            setTimeText()
            invalidateIntrinsicContentSize()
        }
    }
    
    /// Debug colors
    var debugColors: Bool = false {
        didSet {
            setBackgroundColors()
        }
    }
    func setBackgroundColors() {
        if debugColors {
            backgroundColor = UIColor.cyanColor()
            fixedHourLabel.backgroundColor = UIColor.magentaColor()
            fixedMinuteLabel.backgroundColor = UIColor.yellowColor()
            fixedAmPmLabel.backgroundColor = UIColor.orangeColor()
            hourAndMinuteLabel.backgroundColor = UIColor.yellowColor()
            amPmLabel.backgroundColor = UIColor.lightGrayColor()
        } else {
            backgroundColor = UIColor.clearColor()
            fixedHourLabel.backgroundColor = UIColor.clearColor()
            fixedMinuteLabel.backgroundColor = UIColor.clearColor()
            fixedAmPmLabel.backgroundColor = UIColor.clearColor()
            hourAndMinuteLabel.backgroundColor = UIColor.clearColor()
            amPmLabel.backgroundColor = UIColor.clearColor()
        }
    }
    
    private var contentSize: CGSize = CGSize(width: 0, height: 0)
    private let fixedHourLabel: UILabel = UILabel()
    private let fixedMinuteLabel: UILabel = UILabel()
    private let fixedAmPmLabel: InsetLabel = InsetLabel()
    private let hourAndMinuteLabel = ExactLabel()
    private let amPmLabel = ExactLabel()
    private let kLeftRightMargin: CGFloat = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init () {
        self.init(frame:CGRectZero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        setup()
    }
    
    override func intrinsicContentSize() -> CGSize {
        layoutSubviews()
        return contentSize
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    func setup() {
        setTimeText()
        
        setMainFont()
        setAmPmFont()
        
        fixedHourLabel.font = mainFont
        fixedHourLabel.textColor = textColor
        fixedHourLabel.textAlignment = .Right
        addSubview(fixedHourLabel)
        
        fixedMinuteLabel.font = mainFont
        fixedMinuteLabel.textColor = textColor
        fixedMinuteLabel.textAlignment = .Left
        addSubview(fixedMinuteLabel)
        
        fixedAmPmLabel.font = amPmFont
        fixedAmPmLabel.textColor = textColor
        fixedAmPmLabel.hidden = is24Hour || alignment != .Fixed
        // Need a left inset of 1, otherwise 'AM' can get clipped on the left
        fixedAmPmLabel.insets = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 0)
        addSubview(fixedAmPmLabel)
        
        hourAndMinuteLabel.font = mainFont
        hourAndMinuteLabel.textColor = textColor
        hourAndMinuteLabel.clipsToBounds = false
        hourAndMinuteLabel.leftRightMargin = kLeftRightMargin
        addSubview(hourAndMinuteLabel)
        
        amPmLabel.font = amPmFont
        amPmLabel.textColor = textColor
        amPmLabel.hidden = is24Hour || alignment == .Fixed
        amPmLabel.leftRightMargin = kLeftRightMargin
        addSubview(amPmLabel)
        
        setBackgroundColors()
    }
    
    override func layoutSubviews() {
        
        // Size the subviews
        
        let spaceWidth = " ".typographicWidth(amPmFont)
        
        if alignment == .Fixed {
            fixedHourLabel.size = sizeHour
            fixedMinuteLabel.size = sizeMinute
            fixedAmPmLabel.sizeToFit()
            fixedHourLabel.hidden = false
            fixedMinuteLabel.hidden = false
            fixedAmPmLabel.hidden = is24Hour
            hourAndMinuteLabel.hidden = true
            amPmLabel.hidden = true
        } else {
            hourAndMinuteLabel.sizeToFit()
            amPmLabel.sizeToFit()
            fixedHourLabel.hidden = true
            fixedMinuteLabel.hidden = true
            fixedAmPmLabel.hidden = true
            hourAndMinuteLabel.hidden = false
            amPmLabel.hidden = is24Hour
        }
        
        // Get the content size, allowing for the maximum size of the hour, minute, and AM/PM labels if the alignment is .Fixed
        
        var internalSize: CGSize = CGSizeZero
        if alignment == .Fixed {
            if is24Hour {
                internalSize.width = maxSizeHour.width + maxSizeMinute.width
                internalSize.height = max(maxSizeHour.height, maxSizeMinute.height)
            } else {
                if amPmBelow {
                    internalSize.width = max(maxSizeHour.width + maxSizeMinute.width, maxSizeAmPm.width)
                    internalSize.height = maxSizeHour.height + maxSizeAmPm.height + amPmOffset.y + amPmFont.descender + inset
                } else {
                    internalSize.width = maxSizeHour.width + maxSizeMinute.width + maxSizeAmPm.width + amPmOffset.x
                    internalSize.height = max(maxSizeHour.height, maxSizeMinute.height, maxSizeAmPm.height + amPmOffset.y)
                }
            }
        } else {
            if is24Hour {
                internalSize = hourAndMinuteLabel.size
            } else {
                if amPmBelow {
                    internalSize.width = max(hourAndMinuteLabel.width, amPmLabel.width)
                    internalSize.height = hourAndMinuteLabel.height + amPmLabel.height + amPmOffset.y + amPmFont.descender + inset
                } else {
                    internalSize.width = hourAndMinuteLabel.width + amPmLabel.width + amPmOffset.x + spaceWidth
                    internalSize.height = max(hourAndMinuteLabel.height, amPmLabel.height + amPmOffset.y)
                }
            }
        }
        let contentWidth = internalSize.width + 2 * inset
        contentSize = CGSize(width: contentWidth, height: internalSize.height)
        
        // Position the subviews

        fixedHourLabel.y = 0
        fixedMinuteLabel.y = 0
        hourAndMinuteLabel.y = 0
        
        if is24Hour {
            switch alignment {
            case .Left:
                hourAndMinuteLabel.x = inset - kLeftRightMargin
            case .Center:
                hourAndMinuteLabel.centerX = contentSize.width / 2
            case .Right:
                hourAndMinuteLabel.rightX = contentSize.width - inset + kLeftRightMargin
            case .Fixed:
                fixedHourLabel.x = inset + maxSizeHour.width - sizeHour.width
                fixedMinuteLabel.x = fixedHourLabel.rightX
            }
        } else {
            if amPmBelow {
                switch alignment {
                case .Left:
                    hourAndMinuteLabel.x = inset - kLeftRightMargin
                    amPmLabel.x = hourAndMinuteLabel.x
                    amPmLabel.y = hourAndMinuteLabel.bottomY + amPmOffset.y
                case .Center:
                    hourAndMinuteLabel.centerX = contentSize.width / 2
                    amPmLabel.centerX = contentSize.width / 2
                    amPmLabel.y = hourAndMinuteLabel.bottomY + amPmOffset.y
                case .Right:
                    hourAndMinuteLabel.rightX = contentSize.width - inset + kLeftRightMargin
                    amPmLabel.rightX = hourAndMinuteLabel.rightX
                    amPmLabel.y = hourAndMinuteLabel.bottomY + amPmOffset.y
                case .Fixed:
                    fixedHourLabel.x = inset + maxSizeHour.width - sizeHour.width
                    fixedAmPmLabel.centerX = contentSize.width / 2
                    fixedAmPmLabel.y = maxSizeHour.height + amPmOffset.y
                    fixedMinuteLabel.x = fixedHourLabel.rightX
                }
            } else {
                switch alignment {
                case .Left:
                    hourAndMinuteLabel.x = inset - kLeftRightMargin
                    amPmLabel.x = hourAndMinuteLabel.rightX + amPmOffset.x + spaceWidth
                    amPmLabel.y = hourAndMinuteLabel.y + mainFont.ascender - amPmFont.ascender + amPmOffset.y
                case .Center:
                    hourAndMinuteLabel.x = (contentSize.width - hourAndMinuteLabel.width - amPmOffset.x - amPmLabel.width - spaceWidth) / 2
                    amPmLabel.x = hourAndMinuteLabel.rightX + amPmOffset.x + spaceWidth
                    amPmLabel.y = hourAndMinuteLabel.y + mainFont.ascender - amPmFont.ascender + amPmOffset.y
                case .Right:
                    amPmLabel.rightX = contentSize.width - inset + kLeftRightMargin
                    hourAndMinuteLabel.rightX = amPmLabel.x - amPmOffset.x - spaceWidth
                    amPmLabel.y = hourAndMinuteLabel.y + mainFont.ascender - amPmFont.ascender + amPmOffset.y
                case .Fixed:
                    fixedHourLabel.x = inset + maxSizeHour.width - sizeHour.width
                    fixedMinuteLabel.x = fixedHourLabel.rightX
                    fixedAmPmLabel.x = fixedMinuteLabel.x + maxSizeMinute.width
                    fixedAmPmLabel.y = fixedMinuteLabel.y + mainFont.ascender - amPmFont.ascender + amPmOffset.y
                }
            }
        }
        
        bringSubviewToFront(fixedAmPmLabel)
        bringSubviewToFront(amPmLabel)
        size = contentSize
    }
    
    func setTimeText() {
        var hour = 0
        var minute = 0
        var am = true
        
        if timeIsValid {
            if let time = time {
                hour = NSCalendar.currentCalendar().components(.Hour, fromDate: time).hour
                minute = NSCalendar.currentCalendar().components(.Minute, fromDate: time).minute
                if !is24Hour {
                    am = hour < 12
                    if hour == 0 {
                        hour = 12
                    } else if hour > 12 {
                        hour -= 12
                    }
                }
            }
        }
        
        fixedHourLabel.text = String(format: "%d", hour)
        fixedMinuteLabel.text = String(format: ":%02d", minute)
        hourAndMinuteLabel.text = String(format: "%d:%02d", hour, minute)
        if !is24Hour {
            if am {
                fixedAmPmLabel.text = amPmBelow ? "AM" : " AM"
                amPmLabel.text = "AM"
            } else {
                fixedAmPmLabel.text = amPmBelow ? "PM" : " PM"
                amPmLabel.text = "PM"
            }
        }

        sizeHour = computeSizeHour()
        sizeMinute = computeSizeMinute()
        sizeAmPm = computeSizeAmPm()
        layoutSubviews()
    }
}

func fontWithTimeAppearance(font: UIFont) -> UIFont {
    let timeFeatureSettings = [
        [
            UIFontFeatureTypeIdentifierKey: kNumberSpacingType,
            UIFontFeatureSelectorIdentifierKey: kProportionalNumbersSelector
        ],
        [
            UIFontFeatureTypeIdentifierKey: kCharacterAlternativesType,
            UIFontFeatureSelectorIdentifierKey: 1
        ]
    ]
    let timeFontDescriptor = font.fontDescriptor().fontDescriptorByAddingAttributes([UIFontDescriptorFeatureSettingsAttribute: timeFeatureSettings])
    return UIFont(descriptor: timeFontDescriptor, size: font.pointSize)
}
