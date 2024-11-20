//
//  Defines.swift
//  Panther
//
//  Created by Manish Jangid on 7/27/17.
//  Copyright © 2017 Manish Jangid. All rights reserved.
//

import Foundation
import UIKit




// MARK : GLOBAL Functions
func print_debug <T> (_ object:T)
{
    print(object)
}

let DateFormat_yyyy_mm_dd_hh_mm_ss_sss = "yyyy-MM-dd HH:mm:ss"

let DateFormat_yyyy_mm_dd_hh_mm_ss_0000 = "yyyy-MM-dd HH:mm:ss +0000"
let output_format_HH_mm_ss = "HH:mm:ss  MMM dd yyy"
let DateFormat_dd_mm_yyyy = "dd/MM/yyyy"
let DateFormat_dd_amm_yyyy = "dd-MM-yyyy"
let DateFormat_mm_yy = "MM/yy"
let DateFormat_dd_MM_yyyy = "yyyy-MM-dd"
let time_Format = "HH:mm"
let time_Format_S = "hh:mm:ss"
let kDateFormate2          =  "dd MMM yyyy"
let kDateFormateAPI       =  "yyyy-MM-dd"
let kUTC_time_zone_format = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
let kDateFormate3          =  "dd MMM yyyy HH:mm"
let appDelegate = UIApplication.shared.delegate as! AppDelegate



//MARK:- Service Keys

struct ServiceKeys{
    
    static let user_id = "user_id"
    static let vendor_id = "vendor_id"
    
    static let device_token = "device_token"
    static let token = "token"
    static let user_name = "user_name"
    static let first_name = "first_name"
    static let last_name = "last_name"
    static let email = "email"
    
    static let profile_image = "profile_image"
    static let phone_no = "phone_no"
    
    static let accout_type = "accout_type"
    static let dateFormat = "dateFormat"
    static let  timeFormat = "timeFormat"
    
    static let dob = "dob"
    static let title = "title"
    static let  address1 = "address1"
    static let  address2 = "address2"
    static let  town = "town"
    static let  postal = "postal"
    static let gender = "gender"
    static let county = "county"

    
    static let keyContactNumber = "contact_number"
    static let keyProfileImage = "image_url"
   
    static let keyErrorCode = "errorCode"
    static let keyErrorMessage = "errMessage"
    static let keyUserType = "user_type"
    
   
    static let keySubscriptionStatus =  "subscriptionstatus"

  
    static let keyStatus =  "status"
    static let KeyAccountName = "account_name"
    static let KeyPushNotificationDeviceToken = "KeyPushNotificationDeviceToken"
   

}

struct ServiceUrls
{

    static let baseUrl = "https://www.belilli.co.uk/api.php?" //"http://18.216.18.237:3001/"
    static let baseUrlOld = "https://www.thetncard.com/"
    static let baseUrlImage = "https://belilli.co.uk"

    static let enterregistrationcode = "patient/enter_registration_code"
    static let createpassword = "function=resetpassword"
    static let forgot_password = "function=forgotpassword"
    static let verifyaccount = "patient/verify_account"
    static let login = "function=login"
    static let register = "function=register"
    static let getbusinessesformap = "api/getbusinessesformap"

    static let getrecommendedbusinesses = "api/getrecommendedbusinesses"
    static let getbusinesse = "function=getbusinesses"
    static let getcategories = "function=getcategories"
    static let readallnotifications = "api/readallnotifications"
    static let getgetfeaturedbusinesses = "function=getfeaturedbusinesses"
    static let addtofavourite = "function=addtofavourite"
    static let getbusinessesDetails = "function=getbusinessdetail"
    static let getFavList = "function=getuserfavourites"
    static let deletefavourite = "function=deletefavourite"
    static let getActivityList = "function=getactivityhistory"
    static let getSearchBuList = "function=searchbusinesses"

    
    static let getbusinesses = "function=getbusinesses"
    static let fav_business = "api/addtofavourite"
    static let getnotifications = "api/getnotifications"
    static let getbusinessurl = "function=redeemoffer"
    static let updatecurrentlocation = "api/updatecurrentlocation"

    static let getrewardhistory = "api/getrewardhistory"

    
    static let getevents = "api/getevents"
    static let updatepreferences = "api/updatepreferences"
    static let getuserpreferences = "api/getuserpreferences"
    static let getuserfavourites = "api/getuserfavourites"
    static let getevent = "api/getevent"
    static let updateprofile = "function=updateprofile"
    static let getplan  = "api/getplan"
    static let getsubscriptiondetail = "function=getuserdetail"
    static let updatesubscription = "function=updatesubscription"
    static let updateprofilephoto = "api/updateprofilephoto"
    static let logout_api = "function=logout"
    static let change_password     = "api/resetpassword"
    
    
    static let get_state    = "get_state"
    static let get_address  = "get_address"
    static let create_request  = "create_request"
    
    static let get_vendor_details = "get_vendor_details"
    static let upload_user_files = "upload_user_files"
    static let update_profile_image = "update_profile_data"
    
    static let update_notification_logs = "update_notification_logs"
     static let list_notification_logs = "list_notification_logs"
    static let create_gift_request   = "create_gift_request"
    static let get_gift_request = "get_gift_request?"
    static let create_invitation = "create_invitation"
    static let create_planner_request = "create_planner_request"
    static let create_support_ticket = "create_support_ticket"
    static let share_app_via_sms = "share_app_via_sms"

}
struct ErrorCodes
{
    static let    errorCodeInternetProblem = -1 //Unable to update use
    
    static let    errorCodeSuccess = 1 // 'Process successfully.'
    static let    errorCodeFailed = 2 // 'Process failed.
}


struct CustomColor{
   
    static let blackThemeColor = UIColor(red: 1.0/255.0, green: 5.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    static let selectedTabbarColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    static let lightGrayColor = UIColor(red: 157.0/255.0, green: 173.0/255.0, blue: 162.0/255.0, alpha: 0.5)
    static let blackBgColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
    static let appThemeColor = UIColor(hexString: "#050043")//UIColor(red: 122.0/255.0, green: 134.0/255.0, blue: 126.0/255.0, alpha: 1.0)
    static let appTabBarTintColor = UIColor(red: 77.0/255.0, green: 64.0/255.0, blue: 250.0/255.0, alpha: 1.0)

    static let backgroundColorTheme = UIColor(red: 96.0/255.0, green: 126.0/255.0, blue: 140.0/255.0, alpha: 1.0)
    static let pageTitleColor = UIColor(red: 26/255.0, green: 26.0/255.0, blue: 26.0/255.0, alpha: 0.8)
    static let text_Color_White = UIColor.white
       static let nav_color = UIColor.white
    static let redColor = UIColor(hexString: "#9D4720")
    
    static let lightColor = UIColor(hexString: "##F8F9FA") //#F8F8F8
}


struct CustomFont {
    static let boldfont13 = UIFont(name: "GlacialIndifference-Bold", size: 13)!
    static let boldfont18 =  UIFont(name: "GlacialIndifference-Bold", size: 18)!
    static let boldfont14 =  UIFont(name: "GlacialIndifference-Bold", size: 14)!
    static let regularfont17 =  UIFont(name: "GlacialIndifference-Regular", size: 17)!
    static let regularfont16 =  UIFont(name: "GlacialIndifference-Regular", size: 16)!
    static let regularfont14 =  UIFont(name: "GlacialIndifference-Regular", size: 14)!
    static let regularfont18 =  UIFont(name: "GlacialIndifference-Regular", size: 18)!
    static let regularfont15 =  UIFont(name: "GlacialIndifference-Regular", size: 15)!
    static let boldfont15 =  UIFont(name: "GlacialIndifference-Bold", size: 15)!
}


enum Categories {
    
    case hardAndWork
    
    var name: String {
        switch self {
        case .hardAndWork: return " HardAndValues"
        
        }
    }
}

enum ExploreColor: String {
    
    case For_Kids = "For Kids"
    case food_and_drink = "Food &amp; Drink"
    case hair_and_beauty = "Hair &amp; Beauty"
    case Health_and_Fitness = "Health &amp; Fitness"
    case Leisure = "Leisure"
    case Professional = "Professional"
    case Shopping = "Shopping"
    case Makers = "Makers"
    case Events = "Events"
    case Services = "Services"
    case Other = "Other"
    
    func getColor() -> String? {
        
        switch self {
        case .For_Kids:
            return "#F90404"
        case .food_and_drink :
            return "#F98D04"
        case .hair_and_beauty:
            return "#29F904"
        case .Health_and_Fitness:
            return "#04F96C"
        case .Leisure:
            return "#04F2F9"
        case .Professional:
            return "#0434F9"
        case .Shopping:
            return "#9504F9"
        case .Makers:
            return "#F904D0"
        case .Events:
            return "#C12F75"
        case .Services:
            return "#468859"
        default:
            return "#468529"
        }
    }

    
}



