//
//  Utilities.swift
//  TradeInYourLease
//
//  Created by Sourabh Sharma on 10/4/17.
//  Copyright © 2017 Ajay Vyas. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import AVFoundation

struct PlatformUtils {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

class Utilities: NSObject {
    
    typealias completionBlockImageType = (Bool) ->Void
    class func checkCameraPermission(completion:@escaping completionBlockImageType){
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for:cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied:
            completion(false)
            break
        case .authorized:
            completion(true)
            break
        case .restricted:
            completion(false)
            break
            
        case .notDetermined:
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    print("Granted access to \(cameraMediaType)")
                    completion(true)
                    
                } else {
                    print("Denied access to \(cameraMediaType)")
                    
                    completion(false)
                }
            }
        }
    }
    
    
    class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    class func validate(password: String) -> Bool {
        
        let capitalLetterRegExSmall  = ".*[a-z]+.*"
        let texttestSmall = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegExSmall)
        guard texttestSmall.evaluate(with: password) else { return false }
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        guard texttest.evaluate(with: password) else { return false }
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        guard texttest1.evaluate(with: password) else { return false }
        
        //        let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
        //        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        //        guard texttest2.evaluate(with: password) else { return false }
        
        return true
    }
    
    
    class func setImage(url : String,imageview:UIImageView) {
        Alamofire.request(url).responseImage { response in
            debugPrint(response)
            debugPrint(response.result)
            if let image = response.result.value {
                imageview.image = image
            }
        }
    }
    
    class  func setRightViewIcon(icon: UIImage,field:UITextField) {
        let height = field.frame.height
        let imageview = UIImageView(frame: CGRect(x: 15, y: 0, width: (height * 0.25), height: (height * 0.25)))
        imageview.image = icon
        imageview.contentMode = .center
        field.rightViewMode = .always
        field.rightView = imageview
        
        
        
        
        
    }
    class  func setleftViewIcon(name: String,field:UITextField) {
        
        field.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        let height = 20
        let width = 20
        
        print(field.frame.height/2 + 5)
        
        let h = field.frame.height
        
        let view = UIView(frame: CGRect(x: 10, y:0, width: 50, height: h))
        
        let imageview = UIImageView(frame: CGRect(x: 16, y:Int(Int(h/2 ) - Int(height/2)), width: width, height: height))
        imageview.contentMode = .scaleAspectFit
        imageview.backgroundColor = .clear
        
        view.addSubview(imageview)
        field.leftViewMode = .always
        field.leftView = view
        imageview.image = UIImage(named: name)
//        Alamofire.request(url).responseImage { response in
//            debugPrint(response)
//            debugPrint(response.result)
//            if let image = response.result.value {
//                imageview.image = image
//            }
//        }
    }
    
    class  func setRightInfoIcon(field:UITextField,buttton : UIButton) {
        
        buttton.frame = CGRect(x: 0, y: 0, width: 35, height:35)
        buttton.setImage(UIImage(named:"question_icon"), for: .normal)
        
        field.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        field.rightViewMode = .always
        field.rightView = buttton
    }
    
    
    class func saveImageToDisk(pickedimage :UIImage , name : String) {
        
        let imageData = NSData(data:pickedimage.pngData()!)
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let docs: String = paths[0]
        let fullPath = docs  + "/" + name
        imageData.write(toFile: fullPath, atomically: true)
    }
    
    class func getImageFromDisk(name : String) -> UIImage? {
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let docs: String = paths[0]
        let fullPath = docs + "/" + name
        return UIImage(contentsOfFile: fullPath)
    }
    
    
    class func setPresentationStyleForSelfController(_ selfController: UIViewController, presenting presentingController: UIViewController) {
        // if Double(UIDevice.current.systemVersion)! >= 8.0 {
        presentingController.providesPresentationContextTransitionStyle = true
        presentingController.definesPresentationContext = true
        presentingController.modalPresentationStyle = .overCurrentContext
        //        }
        //        else {
        //            selfController.modalPresentationStyle = .currentContext
        //            selfController.navigationController!.moda/2)lPresentationStyle = .currentContext
        //        }
    }
    class func initWith(nibName: String, myself: NSObject) -> Any? {
        let bundle = Bundle.main.loadNibNamed(nibName, owner: myself, options: nil)
        for temp_object: Any in bundle! {
            let object = temp_object as! NSObject
            if (object == myself) {
                return object
            }
        }
        return nil
    }
    /*
     class func leftPadding(myTextField : UITextField) {
     
     let paddingView = UIView(frame: CGRect(0, 0, 10, myTextField.frame.size.width))
     myTextField.leftView = paddingView
     paddingView.backgroundColor = UIColor.clear
     myTextField.leftViewMode = UITextFieldViewMode.always
     }
     
     
     */
    
    
    class func border(myTextField : UITextField) {
        myTextField.cornerRadius = 5.0
        myTextField.borderWidth1 = 1
    }
    
    
   class func getCurrentTime() -> String {

        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let string = dateFormatter.string(from: today as Date)
       // print(string)
        return string
    
    }
    
    class func getCurrentDate() -> String {

         let today = NSDate()
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         let string = dateFormatter.string(from: today as Date)
        // print(string)
         return string
     
     }
    
   class func getCurrentTimeZone() -> String{
        return TimeZone.current.identifier
    }

    
    class func convertToUTC_Date (dateString: String, dateFormat : String) -> Date {
        
        let dateFormater = DateFormatter()
        dateFormater.timeZone = NSTimeZone.system
        dateFormater.dateFormat = dateFormat
        
        let date = dateFormater.date(from: dateString)
        let dateStr = dateFormater.string(from: date!)
        
        dateFormater.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
        dateFormater.dateFormat = dateFormat
        
        let utcdate = dateFormater.date(from: dateStr)
        
        
        return utcdate!
    }
    
    class func convertToUTC_Timestamp (dateString: String, dateFormat : String) -> TimeInterval {
        
        let dateFormater = DateFormatter()
        dateFormater.timeZone = NSTimeZone.system
        dateFormater.dateFormat = dateFormat
        
        let date = dateFormater.date(from: dateString)
        
        let str = dateFormater.string(from: date!)
        
        dateFormater.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
        dateFormater.dateFormat = dateFormat
        
        let utcdate = dateFormater.date(from: str)
        return utcdate!.timeIntervalSince1970
    }
    
    class func convertToDate (date: Date, formatIn : String) -> Date {
        let dateFormater = DateFormatter()
        dateFormater.timeZone = NSTimeZone.system
        dateFormater.dateFormat = formatIn
        let timeStr = dateFormater.string(from: date)
        
        return dateFormater.date(from: timeStr)!
    }
    
    /*Tested working fine*/
    class func convertToDate (dateString: String, formatIn : String) -> Date {
        
        let dateFormater = DateFormatter()
        dateFormater.timeZone = NSTimeZone.system
        dateFormater.dateFormat = formatIn
        let date = dateFormater.date(from: dateString)
        
        return date!
    }
    
    class func convertToString (date: Date, formatOut : String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.timeZone = NSTimeZone.system
        dateFormater.dateFormat = formatOut
        let timeStr = dateFormater.string(from: date as Date)
        return timeStr
    }
    
    /*Tested working fine*/
    class func convertToString (dateString: String, formatIn : String,formatOut : String) -> String {
        
        print(dateString)
        
        let dateFormater = DateFormatter()
        dateFormater.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
        dateFormater.locale = Locale(identifier: "en_US_POSIX")
        dateFormater.dateFormat = formatIn
        let date = dateFormater.date(from: dateString)
        
        dateFormater.timeZone = NSTimeZone.system
        
        dateFormater.dateFormat = formatOut
        let timeStr = dateFormater.string(from: date!)
        print(timeStr)
        return timeStr
    }
    
    class func dateToUTC(date:Date)-> Date {
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?        // or as local time
        formatter.dateFormat = DateFormat_yyyy_mm_dd_hh_mm_ss_sss
        let str = formatter.string(from: date as Date)
        return formatter.date(from: str)!
    }
    
    class func timestampToDate(timeValue : Double) -> Date?{
        return Date(timeIntervalSince1970: timeValue)
    }
    
    class func timeAgoSinceDate(timestamp : Double, numericDates:Bool) -> String {
        
        let date:NSDate =  self.timestampToDate(timeValue:timestamp)! as NSDate
        let calendar = Calendar.current
        
        //  let unitFlags = Calendar.Component.day | Calendar.Component.hour | Calendar.Component.day  | Calendar.Component.second
        let unitFlags = Set<Calendar.Component>([.day, .minute, .second, .hour])
        
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        
        let components:DateComponents =  calendar.dateComponents(unitFlags, from: earliest, to: latest as Date)
        
        if (components.day! >= 2) {
            let str = Utilities.timestampToDate(timestamp: timestamp) + " " + Utilities.timestampToTime(timestamp: timestamp)
            //show date nd time
            return str
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday " + Utilities.timestampToTime(timestamp: timestamp)
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "1 minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    class func timestampToDate(timestamp : Double) -> String{
        let date = Date(timeIntervalSince1970: timestamp)
        
        let str = convertToString(date: date, formatOut:
        AppHelper.getStringForKey(ServiceKeys.dateFormat))
        return str
        
    }
    
    class func timestampToTime(timestamp : Double) -> String{
        let date = Date(timeIntervalSince1970: timestamp)
        
        let str = convertToString(date: date, formatOut: AppHelper.getStringForKey(ServiceKeys.timeFormat))
        return str
    }
    
    
    func geTimeStamp(_ someDate: Date) -> TimeInterval {
        // time interval since 1970
        return someDate.timeIntervalSince1970
    }
    
    
   class func getTimeHoursDataBetweenTwoTimes() -> String {
        let loginTime = Date()
        let loginInterval = -loginTime.timeIntervalSinceNow
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        formatter.allowedUnits = [.hour, .minute]
        
        // Use the configured formatter to generate the string.
        let userLoginTimeString = formatter.string(from: loginInterval) ?? ""
        print("user was logged in for \(userLoginTimeString)")
        return userLoginTimeString
    }
    
    class func getTimeDifference() {
        
        let startDate = "23:51"
        let endDate = "00:01"
        
        let startArray = startDate.components(separatedBy: ":")// ["23", "51"]
        let endArray = endDate.components(separatedBy: ":") // ["00", "01"]
        
        let startHours = Int(startArray[0])! * 60 // 1380
        let startMinutes = Int(startArray[1])! + startHours // 1431
        
        let endHours = Int(endArray[0])! * 60 // 0
        let endMinutes = Int(endArray[1])! + endHours // 1
        
        var timeDifference = endMinutes - startMinutes // -1430
        
        let day = 24 * 60 // 1440
        
        if timeDifference < 0 {
            timeDifference += day // 10
        }
        
    }
    
   class func timeRemainingString(date:NSDate) -> String {
        let secondsFromNowToFinish = date.timeIntervalSinceNow
        let hours = Int(secondsFromNowToFinish / 3600)
        let minutes = Int((secondsFromNowToFinish - Double(hours) * 3600) / 60)
        let seconds = Int(secondsFromNowToFinish - Double(hours) * 3600 - Double(minutes) * 60 + 0.5)
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    class func cardValidation(testStr:String) -> String {
        let visaRegEx = "^4[0-9]{6,}$"
        let visaTest = NSPredicate(format:"SELF MATCHES %@", visaRegEx)
        let visaResult = visaTest.evaluate(with: testStr)
        
        let masterRegEx = "^5[1-5][0-9]{5,}|222[1-9][0-9]{3,}|22[3-9][0-9]{4,}|2[3-6][0-9]{5,}|27[01][0-9]{4,}|2720[0-9]{3,}$"
        let masterTest = NSPredicate(format:"SELF MATCHES %@", masterRegEx)
        let masterResult = masterTest.evaluate(with: testStr)
        
        let amexRegEx = "^3[47][0-9]{5,}$"
        let amexTest = NSPredicate(format:"SELF MATCHES %@", amexRegEx)
        let amexResult = amexTest.evaluate(with: testStr)
        
        let discoverRegEx = "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        let discoverTest = NSPredicate(format:"SELF MATCHES %@", discoverRegEx)
        let discoverResult = discoverTest.evaluate(with: testStr)
        
        if visaResult {
            
            return "img_cardVisa"
        }
        else if masterResult {
            return "img_cardMaster"
        }
        else if amexResult {
            return "img_cardAMEX"
        }
        else if discoverResult {
            return "img_cardDiscover"
        }
        else {
            return ""
        }
        
    }
    
    
    class func isValidName(testStr:String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
            if regex.firstMatch(in: testStr, options: [], range: NSMakeRange(0, testStr.count)) != nil {
                return false
                
            } else {
                return true
            }
        }
        catch {
            return true
        }
    }
    
    class func isValidPhoneNumber(value: String) -> Bool {
        let PHONE_REGEX = "^\\+?\\d[\\d -]{8,12}\\d"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    class func attributedStrings(str1:String,str2:String) -> NSMutableAttributedString {
        let text = NSMutableAttributedString(string: str1)
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 88/255, green: 88/255, blue: 88/255, alpha: 1.0), range: NSMakeRange(0, text.length))
        //        for fontFamilyName in UIFont.familyNames{
        //            for fontName in UIFont.fontNames(forFamilyName: fontFamilyName){
        //                print("Family: \(fontFamilyName)     Font: \(fontName)")
        //            }
        //        }
        
        text.addAttribute(NSAttributedString.Key.font, value:UIFont(name: "Yantramanav-Light", size: 16)!, range: NSMakeRange(0, text.length))
        
        let text2 = NSMutableAttributedString(string: str2)
        text2.addAttribute(NSAttributedString.Key.foregroundColor, value: CustomColor.appThemeColor, range: NSMakeRange(0, text2.length))
        text2.addAttribute(NSAttributedString.Key.font, value:UIFont(name: "Teko-Light", size: 22)!, range: NSMakeRange(0, text2.length))
        text.append(text2)
        
        return text
    }
    
    class func attributedStringsCarsList(str1:String,str2:String) -> NSMutableAttributedString {
        let text = NSMutableAttributedString(string: str1)
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 88.0/255, green: 88.0/255, blue: 88.0/255, alpha: 1.0), range: NSMakeRange(0, text.length))
        //        for fontFamilyName in UIFont.familyNames{
        //            for fontName in UIFont.fontNames(forFamilyName: fontFamilyName){
        //                print("Family: \(fontFamilyName)     Font: \(fontName)")
        //            }
        //        }
        
        text.addAttribute(NSAttributedString.Key.font, value:UIFont(name: "Teko-Medium", size: 25)!, range: NSMakeRange(0, text.length))
        
        let text2 = NSMutableAttributedString(string: str2)
        text2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 198/255, green: 40/255, blue: 72/255, alpha: 1.0), range: NSMakeRange(0, text2.length))
        text2.addAttribute(NSAttributedString.Key.font, value:UIFont(name: "Teko-Light", size: 25)!, range: NSMakeRange(0, text2.length))
        text.append(text2)
        
        return text
    }
    
    class func attributedStringsFavouriteCarsList(str1:String,str2:String) -> NSMutableAttributedString {
        let text = NSMutableAttributedString(string: str1)
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 255.0/255, green: 0/255, blue: 0/255, alpha: 1.0), range: NSMakeRange(0, text.length))
        //        for fontFamilyName in UIFont.familyNames{
        //            for fontName in UIFont.fontNames(forFamilyName: fontFamilyName){
        //                print("Family: \(fontFamilyName)     Font: \(fontName)")
        //            }
        //        }
        
        text.addAttribute(NSAttributedString.Key.font, value:UIFont(name: "Teko-Medium", size: 25)!, range: NSMakeRange(0, text.length))
        
        let text2 = NSMutableAttributedString(string: str2)
        text2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 88/255, green: 88/255, blue: 88/255, alpha: 1.0), range: NSMakeRange(0, text2.length))
        text2.addAttribute(NSAttributedString.Key.font, value:UIFont(name: "Teko-Light", size: 25)!, range: NSMakeRange(0, text2.length))
        text.append(text2)
        
        return text
    }
    
    
    class func attributedStringsSubs(str1:String,str2:String) -> NSMutableAttributedString {
        if(str1.contains(":")) {
            let words = str1.components(separatedBy: ":")
            let text = NSMutableAttributedString(string: words[0])
            text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 160/255, green: 29/255, blue: 33/255, alpha: 1.0), range: NSMakeRange(0, text.length))
            
            
            text.addAttribute(NSAttributedString.Key.font, value:UIFont(name: "Museo100-Regular", size: 42)!, range: NSMakeRange(0, text.length))
            
            let dot = NSMutableAttributedString(string: ".")
            dot.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 160/255, green: 29/255, blue: 33/255, alpha: 1.0), range: NSMakeRange(0, dot.length))
            
            
            dot.addAttribute(NSAttributedString.Key.font, value:UIFont(name: "Museo100-Regular", size: 42)!, range: NSMakeRange(0, dot.length))
            
            text.append(dot)
            
            let text1 = NSMutableAttributedString(string: words[1])
            text1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 160/255, green: 29/255, blue: 33/255, alpha: 1.0), range: NSMakeRange(0, text1.length))
            
            
            text1.addAttribute(NSAttributedString.Key.font, value:UIFont(name: "Museo100-Regular", size: 22)!, range: NSMakeRange(0, text1.length))
            text.append(text1)
            
            let text2 = NSMutableAttributedString(string: str2)
            text2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 160/255, green: 29/255, blue: 33/255, alpha: 1.0), range: NSMakeRange(0, text2.length))
            text2.addAttribute(NSAttributedString.Key.font, value:UIFont(name: "MuseoSans-500", size: 14)!, range: NSMakeRange(0, text2.length))
            text.append(text2)
            
            return text
            
        }
            
        else {
            let text = NSMutableAttributedString(string: str1)
            text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 160/255, green: 29/255, blue: 33/255, alpha: 1.0), range: NSMakeRange(0, text.length))
            //        for fontFamilyName in UIFont.familyNames{
            //            for fontName in UIFont.fontNames(forFamilyName: fontFamilyName){
            //                print("Family: \(fontFamilyName)     Font: \(fontName)")
            //            }
            //        }
            
            text.addAttribute(NSAttributedString.Key.font, value:UIFont(name: "Museo100-Regular", size: 42)!, range: NSMakeRange(0, text.length))
            
            let text2 = NSMutableAttributedString(string: str2)
            text2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 160/255, green: 29/255, blue: 33/255, alpha: 1.0), range: NSMakeRange(0, text2.length))
            text2.addAttribute(NSAttributedString.Key.font, value:UIFont(name: "MuseoSans-500", size: 14)!, range: NSMakeRange(0, text2.length))
            text.append(text2)
            
            return text
        }
        
    }
    
    class func attributedStringTwo(str1:String,str1Color:UIColor,str2:String,str2Color:UIColor,isUnderline:Bool,strSize:Float,alignment:NSTextAlignment) -> NSMutableAttributedString {
        var underline = 0
        
        if isUnderline{
            underline=1
        }
        let text = NSMutableAttributedString(string: str1)
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: str1Color, range: NSMakeRange(0, text.length))
        text.addAttribute(NSAttributedString.Key.font, value:UIFont(name: "Montserrat-SemiBold", size: CGFloat(strSize))!, range: NSMakeRange(0, text.length))
        text.addAttribute(NSAttributedString.Key.underlineStyle, value: underline, range: NSMakeRange(0,text.length))
        text.addAttribute(NSAttributedString.Key.underlineColor, value: str1Color, range: NSMakeRange(0, text.length))
        let selectablePart = NSMutableAttributedString(string: str2)
        
        // Add an underline to indicate this portion of text is selectable (optional)
        selectablePart.addAttribute(NSAttributedString.Key.underlineStyle, value: underline, range: NSMakeRange(0,selectablePart.length))
        selectablePart.addAttribute(NSAttributedString.Key.underlineColor, value: str2Color, range: NSMakeRange(0, selectablePart.length))
        
        selectablePart.addAttribute(NSAttributedString.Key.font, value:UIFont(name: "Montserrat-SemiBold", size: CGFloat(strSize))!, range: NSMakeRange(0, selectablePart.length))
        // Add an NSLinkAttributeName with a value of an url or anything else
        selectablePart.addAttribute(NSAttributedString.Key.link, value: "signin", range: NSMakeRange(0,selectablePart.length))
        selectablePart.addAttribute(NSAttributedString.Key.foregroundColor, value: str2Color, range: NSMakeRange(0, selectablePart.length))
        text.append(selectablePart)
        // Center the text (optional)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        text.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.length))
        return text
    }
    
    // MARK: - Navigation Controller Method
    
    class func clearNavigationBackgroundColor(navigation:UINavigationController) {
        navigation.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigation.navigationBar.shadowImage = UIImage()
        navigation.navigationBar.isTranslucent = true
        navigation.view.backgroundColor = .clear
        navigation.navigationBar.isHidden=false
    }
    
    // MARK: - Set Background Image Method
    
    class func setBackgroundImageWithAspectFit(view:UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        UIImage(named: "splash_background")?.draw(in: view.bounds)
        let patternImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        view.backgroundColor = UIColor(patternImage: patternImage)
    }
    
    
    
    class func verifyUrl (string: String?) -> Bool {
        guard let urlString = string else {return false}
        guard let url = NSURL(string: urlString) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
        
        //
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
    
    
    class func setDictionary(data:[String : JSON]) -> [String : String] {
        var emptyDict = [String:String]()
        //        for var i in 0..<data.count {
        //            var key : String = data.keys[i]
        //        }
        for dict in data {
            let key :String = dict.key
            var str:String = ""
            
            if (data[key]?.string) != nil {
                str = (data[key]?.string!)!
            }
            emptyDict[key] = str
        }
        return emptyDict
    }
    
    class func addShadowRoundImage(view:UIView,image:UIImageView,cornerRadius:CGFloat) {
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: cornerRadius).cgPath
        view.addSubview(image)
        view.backgroundColor = .clear
    }
    
    class func addShadowRoundView(view:UIView,mainView:UIView,cornerRadius:CGFloat) {
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: cornerRadius).cgPath
        view.addSubview(mainView)
        view.backgroundColor = .clear
    }
    
    
//    class func addBlackOverlay(imageView : UIImageView) {
//        removeSubview(view: imageView)
//        let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
//        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
//        overlay.tag = 100
//        imageView.addSubview(overlay)
//    }
    
    
    
    class func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if !key.isEqualToString(find: ServiceKeys.KeyPushNotificationDeviceToken) {
                defaults.removeObject(forKey: key)
            }
            
        }
        defaults.synchronize()
    }
    
    class func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    
    class func addShadow(imageView:UIImageView) {
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowRadius = 1
        imageView.clipsToBounds = false
    }
    
    class func addShadow(imageView:UIButton) {
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowRadius = 1
        imageView.clipsToBounds = false
    }
    
    class func addShadowView(view:UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 1
        view.clipsToBounds = false
    }
    
    class func snapToNearestCell(_ collectionView: UICollectionView,collectionViewFlowLayout:UICollectionViewFlowLayout) {
        for i in 0..<collectionView.numberOfItems(inSection: 0) {
            
            let itemWithSpaceWidth = collectionViewFlowLayout.itemSize.width + collectionViewFlowLayout.minimumLineSpacing
            let itemWidth = collectionViewFlowLayout.itemSize.width
            
            if collectionView.contentOffset.x <= CGFloat(i) * itemWithSpaceWidth + itemWidth / 2 {
                let indexPath = IndexPath(item: i, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
                break
            }
        }
    }
    
    
    class func addShadowCell(cell: UICollectionViewCell) {
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowOpacity = 0.7
        cell.layer.shadowRadius = 1
        cell.clipsToBounds = false
        
    }
    
    
    
    
}


