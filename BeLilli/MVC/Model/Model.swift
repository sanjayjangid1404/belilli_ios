//
//  Model.swift
//  BeLilli
//
//  Created by apple on 01/02/23.
//

import Foundation
import SwiftyJSON

class User{
    
    var last_name   : String!
    var first_name   : String!
    var email       : String!
    var phone_no    : String!
    var gender : String!
    var id       : String!
    var dob   : String!
    var img_url     : String!
    var hash   : String!
    var referral_code : String!
    
    var address_line_one : String!
    var address_line_two : String!
    var membership_no    : String!
    var membership_type  : String!
    
    var plan_id   : String!
    var plan_name : String!
    var plan_type : String!
    var postcode  : String!
    var town      : String!
    var county      : String!

    
    var profile_photo: String!
    var title : String!
    
    
    init(fromJson parseData: JSON!){
        if parseData.isEmpty{
            return
        }
        
        let json            = parseData["data"]
        first_name          = json["first_name"].stringValue
        last_name           = json["last_name"].stringValue
        email               = json["email"].stringValue
        phone_no            = json["telephone"].stringValue
        gender              = json["gender"].stringValue
        dob                 = json["dob"].stringValue
        id                  = json["id"].stringValue
        img_url             = json["img_url"].stringValue.replacingOccurrences(of: "\"", with: "")
        hash                = json["hash"].stringValue
        referral_code       = json["referral_code"].stringValue
        
        plan_id    = json["plan_id"].stringValue
        plan_name  = json["plan_name"].stringValue
        plan_type  = json["plan_type"].stringValue
        postcode   = json["postcode"].stringValue
        town       = json["town"].stringValue
        county       = json["county"].stringValue
        title      = json["title"].stringValue
        
        address_line_one = json["address_line_one"].stringValue
        address_line_two = json["address_line_two"].stringValue
        membership_no = json["membership_no"].stringValue
        membership_type = json["membership_type"].stringValue
        
        profile_photo = json["profile_photo"].stringValue
    }
}

protocol LandingDataProtocol {
    
}

class CategoryDTo: LandingDataProtocol{
    
    var id : String!
    var pref_value : String!
    var name  : String!
    var slug : String!
    var banner : String!
    var visible: String!
    var logo : String!
    var postcode : String!
    var image : String!
    var description : String!
    var description_app : String!

    var address : String!
    var phone : String!
    var email : String!
    var website : String!
    var offer : String!
    var offer_text : String!
    var offer_code : String!
    var category_name: String!
    var distance: String?
    var member_favourite: Bool?
    var month: String?
    var date: String?
    var latitude: String?
    var longitude: String?
    var isSelected: Bool? = false
    var event_end_time: String?
    var event_start_time: String?

    init() {
    }
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
        
    }
    
    init(fromJson parseData: JSON!){
        if parseData.isEmpty{
            return
        }
        
        let json            = parseData
        name                 = json?["name"].stringValue
        id                   = json?["id"].stringValue
        banner               = json?["banner"].stringValue
        slug                 = json?["slug"].stringValue
        visible              = json?["visible"].stringValue
        logo                 = json?["logo"].stringValue
        postcode             = json?["postcode"].stringValue
        image                = json?["image"].stringValue
        description          = json?["description"].stringValue
        description_app       = json?["description_app"].stringValue

        address              = json?["address"].stringValue
        phone                = json?["phone"].stringValue
        email                = json?["email"].stringValue
        website               = json?["website"].stringValue
        offer                 = json?["offer"].stringValue
        offer_text                  = json?["offer_text"].stringValue
        offer_code             = json?["offer_code"].stringValue
        category_name          = json?["category_name"].stringValue
        distance          = json?["distance"].stringValue
        member_favourite          = json?["member_favourite"].boolValue
        month        = getMonth(json?["month"].stringValue ?? "")
        date        = json?["date"].stringValue
        latitude        = json?["latitude"].stringValue
        longitude        = json?["longitude"].stringValue
        event_end_time        = json?["event_end_time"].stringValue
        event_start_time        = json?["event_start_time"].stringValue
        
    }
    
    func getMonth(_ index:String) -> String {
        switch index {
        case "1": return "JAN"
        case "2": return "FEB"
        case "3": return "MAR"
        case "4": return "APR"
        case "5": return "MAY"
        case "6": return "JUN"
        case "7": return "JUL"
        case "8": return "AUG"
        case "9": return "SEPT"
        case "10": return "OCT"
        case "11": return "NOV"
        case "12": return "DEC"
        default:
            return "N/A"
        }
    }
}


struct QRData {
    var codeString: String?
}


class PlanDTo {
    
    var id   : String!
    var plan_name   : String = "Subscription Plan"
    var device_type       : String!
    var description    : String!
    var plan_cost    : String = "£ 2.99"
    var first_name :String?
    var last_name  :String?
    var email  :String?
    var start_date  :String?
    var end_date  :String?
    var created  :String?
    var updated  :String?
    var subscription_status    : String!
    var plan_type    : String!
    var plan_id    : String!
    var membership_no    : String!

    
    init(fromJson parseData: JSON!){
        if parseData.isEmpty{
            return
        }
        
        let json        = parseData
        plan_name       = json?["plan_name"].stringValue ?? "Monthly Subscription Plan"
        id              = json?["id"].stringValue
        first_name      = json?["first_name"].stringValue
        last_name       = json?["last_name"].stringValue
        email           = json?["email"].stringValue
        device_type     = json?["device_type"].stringValue
        plan_cost       = json?["plan_cost"].stringValue ?? "£2.99"
        description     = json?["description"].stringValue
        start_date      = json?["start_date"].stringValue
        end_date        = json?["end_date"].stringValue
        created         = json?["created"].stringValue
        updated         = json?["updated"].stringValue
        plan_type       = json?["plan_type"].stringValue
        plan_id         = json?["plan_id"].stringValue
        membership_no   = json?["membership_no"].stringValue

        subscription_status         = json?["status"].stringValue
    }
}


class LocationDTo {
    
    var id   : String!
    var name   : String!
    var preference : String!
    var isSelected: Bool = false
    var pref_value: String!
    
    init() {
    }

    
    init(fromJson parseData: JSON!){
        if parseData.isEmpty{
            return
        }
        
        let json            = parseData
        name                = json?["name"].stringValue
        id                  = json?["id"].stringValue
        preference          = json?["preference"].stringValue
        pref_value        = json?["pref_value"].stringValue

    }
}


class NotificationListDTo {
    
    var id   : String!
    var user_id   : String!
    var title   : String!
    var message   : String!
    var message_date   : String!
    var read_status   : String!
    
    
    init(fromJson parseData: JSON!){
        if parseData.isEmpty{
            return
        }
        
        let json             = parseData
        id                   = json?["id"].stringValue
        user_id              = json?["user_id"].stringValue
        title                = json?["title"].stringValue
        message              = json?["message"].stringValue
        message_date         = json?["message_date"].stringValue
        read_status          = json?["read_status"].stringValue
    }
    

    
}



class BusinessDTo: LandingDataProtocol {
    
    var id                  : String!
    var category_id         : String!
    var business_name       : String!
    var description         : String!
    var image               : String!
    var contact_first_name  : String!
    var contact_last_name   : String!
    var address1            : String!
    var town                : String!
    var county              : String!
    var lat                 : String!
    var lng                 : String!
    var website             : String!
    var category_name       : String!
    var offer_terms         : String!
    var offer_title         : String!
    var redeem_date         : String!
    var offer_name          : String!

    
    init(fromJson parseData: JSON!){
        if parseData.isEmpty{
            return
        }
        
        let json             = parseData
   
        id                      = json?["id"].stringValue
        category_id            = json?["category_id"].stringValue
        business_name    = json?["business_name"].stringValue
        description   = json?["description"].stringValue
        image   = json?["image"].stringValue
        contact_first_name   = json?["contact_first_name"].stringValue
        contact_last_name   = json?["contact_last_name"].stringValue
        address1   = json?["address1"].stringValue
        town   = json?["town"].stringValue
        county   = json?["county"].stringValue
        lat   = json?["lat"].stringValue
        lng   = json?["lng"].stringValue
        website   = json?["website"].stringValue
        category_name   = json?["category_name"].stringValue
        offer_title   = json?["offer_title"].stringValue
        offer_terms   = json?["offer_terms"].stringValue
        redeem_date   = json?["redeem_date"].stringValue
        offer_name   = json?["offer_name"].stringValue
    }

}


struct HomeDTo {
    var sectionName: String?
    var data: [LandingDataProtocol]?
    var isTNShow: Bool
    
    init(sectionName: String? = nil, data: [LandingDataProtocol]? = nil, isTNShow: Bool = false) {
        self.sectionName = sectionName
        self.data = data
        self.isTNShow = isTNShow
    }
}

class Filter {
    
    var categoryList: [CategoryDTo]?
    var location: String?
    var lat: String?
    var lng: String?
    var radius: Int = 0
    
    init() {
        
    }
    
    init(categoryList: [CategoryDTo]?, location: String? = nil, lat: String? = nil,lng: String? = nil, radius: Int = 0) {
        self.categoryList = categoryList
        self.location = location
        self.lat = lat
        self.lng = lng
        self.radius = radius
    }
    
}
