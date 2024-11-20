//
//  ServiceClass.swift
//  TradeInYourLease
//
//  Created by Ajay Vyas on 10/2/17.
//  Copyright © 2017 Ajay Vyas. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class ServiceClass: NSObject {

    static let sharedInstance = ServiceClass()
 
    enum ResponseType : Int {
        case   kResponseTypeFail = 0
        case  kresponseTypeSuccess
    }
    
    typealias completionBlockType = (ResponseType, JSON, AnyObject?) ->Void
    
    
    func hudShow()  {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func hudHide()  {
        SVProgressHUD.dismiss()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    
    //MARK:- Common Get Webservice calling Method using SwiftyJSON and Alamofire
    func hitServiceWithUrlString( urlString:String, parameters:[String:AnyObject],headers:HTTPHeaders,completion:@escaping completionBlockType)
    {
        if Reachability.forInternetConnection()!.isReachable()
        {
            print(headers)
            print(urlString)
            print(parameters)
            DispatchQueue.main.async {
                self.hudShow()
            }
            
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers : headers)
                .responseJSON { response in
                    DispatchQueue.main.async {
                    self.hudHide()
                    }
                    guard case .success(let rawJSON) = response.result else {
                        print("SomeThing wrong")
                        
                        var errorDict:[String:Any] = [String:Any]()
                        errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                        errorDict[ServiceKeys.keyErrorMessage] = "SomeThing wrong"
                        completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                        return
                    }
                    if rawJSON is [String: Any] {
                        let json = JSON(rawJSON)
                        print(json)
                        if json["error"] == false {
                            completion(ResponseType.kresponseTypeSuccess,json,nil)
                        }
                        else {
                            var errorDict:[String:Any] = [String:Any]()
                            errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                            errorDict[ServiceKeys.keyErrorMessage] = json["message"].stringValue
                            print(json["error_code"].stringValue)
                            
                            
                            if json["error_code"].stringValue == "delete_user"{
                                SVProgressHUD.dismiss()
                       
//                                appDelegate.openHome()
                            }
                            else {
                                completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                            }
                            
                        }
                    }
            }
        }
        else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let errorDict = NSMutableDictionary()
                errorDict.setObject(ErrorCodes.errorCodeInternetProblem, forKey: ServiceKeys.keyErrorCode as NSCopying)
                errorDict.setObject("Check your internet connectivity", forKey: ServiceKeys.keyErrorMessage as NSCopying)
                completion(ResponseType.kResponseTypeFail,JSON(),errorDict as NSDictionary)
            }
            
        }
        
    }
    
    func hitGetServiceWithUrlParams( urlString:String, parameters:[String:Any],headers:HTTPHeaders,completion:@escaping completionBlockType)
          {
              if Reachability.forInternetConnection()!.isReachable()
              {
                  
                  let updatedUrl = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                  let url = URL(string: updatedUrl!)!
                  print("URL \(url)")
                  print("PARAMETERS: \(parameters)")
                DispatchQueue.main.async {
                self.hudShow()
                }
              
                  
                   Alamofire.request(url, method: .get,parameters: parameters  , encoding: URLEncoding.default, headers: headers).responseJSON { response in
                    DispatchQueue.main.async {
                    self.hudHide()
                    }
                      guard case .success(let rawJSON) = response.result else {
                          print("SomeThing wrong")
                          
                          print(response.result)
                          
                          var errorDict:[String:Any] = [String:Any]()
                          errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                          errorDict[ServiceKeys.keyErrorMessage] = "SomeThing wrong"
                          
                          completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                          return
                      }
                      if rawJSON is [String: Any] {
                          
                          let json = JSON(rawJSON)
                          print(json)
                          if  json["error"] != false {
                              completion(ResponseType.kresponseTypeSuccess,json,nil)
                          }
                          else {
                              var errorDict:[String:Any] = [String:Any]()
                              errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                              errorDict[ServiceKeys.keyErrorMessage] = json["message"].stringValue
                              print(json["error_code"].stringValue)
                              
                              if json["error_code"].stringValue == "delete_user"{
                                  SVProgressHUD.dismiss()
                              }
                              else {
                                  completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                              }
                              
                          }
                      }
               
                  }
              }
                  
              else  {
       
                  DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                      let errorDict = NSMutableDictionary()
                      errorDict.setObject(ErrorCodes.errorCodeInternetProblem, forKey: ServiceKeys.keyErrorCode as NSCopying)
                      errorDict.setObject("Check your internet connectivity", forKey: ServiceKeys.keyErrorMessage as NSCopying)
                      completion(ResponseType.kResponseTypeFail,JSON(),errorDict as NSDictionary)
                  }
              }
          }
       
    
    func hitGetServiceWithUrlString( urlString:String, parameters:[String:Any],headers:HTTPHeaders,completion:@escaping completionBlockType)
    {
        if Reachability.forInternetConnection()!.isReachable()
        {
         
            DispatchQueue.main.async {
            self.hudShow()
            }
            
            let updatedUrl = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = URL(string: updatedUrl!)!
            print("URL \(url)")
            print("PARAMETERS: \(parameters)")
            Alamofire.request(url, method: .get , encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                DispatchQueue.main.async {
                self.hudHide()
                }
                guard case .success(let rawJSON) = response.result else {
                    print("SomeThing wrong")
                    
                    print(response.result)
                    
                    var errorDict:[String:Any] = [String:Any]()
                    errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                    errorDict[ServiceKeys.keyErrorMessage] = "SomeThing wrong"
                    
                    completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                    return
                }
                if rawJSON is [String: Any] {
                    
                    let json = JSON(rawJSON)
                    print(json)
                    if json["error"] == false {
                        completion(ResponseType.kresponseTypeSuccess,json,nil)
                    }
                    else {
                        var errorDict:[String:Any] = [String:Any]()
                        errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                        errorDict[ServiceKeys.keyErrorMessage] = json["message"].stringValue
                        print(json["error_code"].stringValue)
                        
                        
                        if json["error_code"].stringValue == "delete_user"{
                            SVProgressHUD.dismiss()
                            
//                            appDelegate.openHome()
                        }
                        else {
                            completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                        }
                        
                        
                    }
                }
         
            }
        }
            
        else  {
 
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let errorDict = NSMutableDictionary()
                errorDict.setObject(ErrorCodes.errorCodeInternetProblem, forKey: ServiceKeys.keyErrorCode as NSCopying)
                errorDict.setObject("Check your internet connectivity", forKey: ServiceKeys.keyErrorMessage as NSCopying)
                completion(ResponseType.kResponseTypeFail,JSON(),errorDict as NSDictionary)
            }
        }
    }
    func imageUpload(_ urlString:String, params:[String : Any],data : Data?,imageKey:String,headers:HTTPHeaders, completion:@escaping completionBlockType){
        
        print(urlString)
        print(params)
        DispatchQueue.main.async {
        self.hudShow()
        }
        Alamofire.upload(multipartFormData:{ multipartFormData in
            if let _ = data {
            multipartFormData.append(data ?? Data() , withName: imageKey, fileName: "file.jpg", mimeType: "image/jpg")
            }
            
            for (key, value) in params {
                    let str = "\(value)"
                    multipartFormData.append(((str as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
            }
        },
                         usingThreshold:UInt64.init(), to:urlString,method:.post,headers:headers,
                         encodingCompletion: { encodingResult in
                            
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    
                                    guard case .success(let rawJSON) = response.result else {
                                        DispatchQueue.main.async {
                                        self.hudHide()
                                        }

                                        var errorDict:[String:Any] = [String:Any]()
                                        errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                                        errorDict[ServiceKeys.keyErrorMessage] = "SomeThing wrong" + urlString
                                        
                                        completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                                        
                                        return
                                    }
                                    print(rawJSON)
                                    if rawJSON is [String: Any] {
                                        DispatchQueue.main.async {
                                        self.hudHide()
                                        }
                                        let json = JSON(rawJSON)
                                        
                                        if json["error"] == true {
                                            var errorDict:[String:Any] = [String:Any]()
                                            
                                            errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                                            errorDict[ServiceKeys.keyErrorMessage] = json["message"].stringValue
                                            
                                            completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                                        }
                                        else {
                                            completion(ResponseType.kresponseTypeSuccess,json,nil)
                                        }
                                    }
                                    
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                DispatchQueue.main.async {
                                self.hudHide()
                                }
                            }
        })
    }
    
    
    //multiple images upload
    func multipleImageUpload(_ urlString:String, params:[String : Any],data: [Data],identifiedImageData : Data,headers:HTTPHeaders, completion:@escaping completionBlockType){
        
        print(urlString)
        print(params)
        print(data)
        
        DispatchQueue.main.async {
            self.hudShow()
        }
        Alamofire.upload(multipartFormData:{ multipartFormData in
            
            for imgData in data {
                multipartFormData.append(imgData , withName:  "file_data[]", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            
            multipartFormData.append(identifiedImageData , withName:  "identified", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            
            for (key, value) in params {
                // let str = "\(value)"
                //multipartFormData.append(((str as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
                if let val = value as? Bool{
                    var str = "Yes"
                    if val {
                        multipartFormData.append(((str as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
                    }
                    else {
                        str = "No"
                        multipartFormData.append(((str as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
                    }
                }
                else {
                    let str = "\(value)"
                    multipartFormData.append(((str as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
                }
            }
        },
        usingThreshold:UInt64.init(), to:urlString,method:.post,headers:headers,
        encodingCompletion: { encodingResult in
            DispatchQueue.main.async {
                self.hudHide()
            }
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    guard case .success(let rawJSON) = response.result else {
                        var errorDict:[String:Any] = [String:Any]()
                        errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                        errorDict[ServiceKeys.keyErrorMessage] = "SomeThing wrong" + urlString
                        
                        completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                        
                        return
                    }
                    print(rawJSON)
                    if rawJSON is [String: Any] {
                        
                        let json = JSON(rawJSON)
                        
                        if  json["status"] == "error"{
                            var errorDict:[String:Any] = [String:Any]()
                            
                            errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                            errorDict[ServiceKeys.keyErrorMessage] = json["message"].stringValue
                            
                            completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                        }
                        else {
                            completion(ResponseType.kresponseTypeSuccess,json,nil)
                        }
                    }
                    
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
        
    }
         
    
    // For SignUp
    func hitServiceForRegistration(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.enterregistrationcode)"
        print(baseUrl)
           let headers: HTTPHeaders = [ "Content-Type" : "application/json"]
        print_debug(params)
        self.imageUpload(baseUrl, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
    func hitServiceForResetNewPassword(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.createpassword)"
        print(baseUrl)
        let headers: HTTPHeaders = [:]
        print_debug(params)
        self.imageUpload(baseUrl, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
    func hitServiceForFavUserList(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.getuserfavourites)"
        print(baseUrl)
        let headers: HTTPHeaders = [:]
        self.imageUpload(baseUrl, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
   
    

   
    //MARK:- EmailLogin
    func hitServiceForEmailLogin(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.login)"
       
        let headers: HTTPHeaders = [:]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }

    //MARK:- Register
    func hitServiceForRegister(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.register)"
        let headers: HTTPHeaders = [:]//[ "Content-Type" : "application/json"]
       
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
    
     //MARK:- Forgot
     func hitServiceForForgotPassword(_ params:[String : Any], completion:@escaping completionBlockType)
     {
         let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.forgot_password)"
        
         let headers: HTTPHeaders = [:]
         self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
     }
//
    func hitServiceForUpdateProfileImage(_ params:[String : Any],data : Data?, completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.update_profile_image)"
        print(baseUrl)

       let headers: HTTPHeaders = [ "Content-Type" : "application/json"]
        print_debug(params)
        print_debug(headers)
        self.imageUpload(baseUrl, params: params, data: data, imageKey: "file", headers: headers, completion: completion)
    }

    
    //MARK:- Get Services
    func hitServiceForGetBusiness(params: [String:Any] , completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.getbusinesse)"
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
    func hitServiceForGetMapBusiness(params: [String:Any] , completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.getbusinessesformap)"
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }

    
    func hitServiceForGetRecommendedBusiness(params: [String:Any] , completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.getrecommendedbusinesses)"
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }

    
    //MARK : Get states
    func hitServiceForGetCategories(params: [String:Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.getcategories)"
        let headers: HTTPHeaders = [:]
        self.hitGetServiceWithUrlString(urlString: urlString, parameters: params as [String:AnyObject], headers: headers, completion: completion)
    }
    func hitServiceForGetSearchBuList(params: [String:Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.getSearchBuList)"
        let headers: HTTPHeaders = [:]
        self.hitGetServiceWithUrlString(urlString: urlString, parameters: params as [String:AnyObject], headers: headers, completion: completion)
    }
    

    func hitServiceForReadNotification(params: [String:Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.readallnotifications)"
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
    //MARK : Get states
    func hitServiceForGetFeaturedBusiness(params: [String:Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.getgetfeaturedbusinesses)"
        let headers: HTTPHeaders = [:]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
    func hitServiceForGetBusinessDetails(params: [String:Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.getbusinessesDetails)"
        let headers: HTTPHeaders = [:]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
    func getFavList(params: [String:Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.getFavList)"
        let headers: HTTPHeaders = [:]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
    func getActivityList(params: [String:Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.getActivityList)"
        let headers: HTTPHeaders = [:]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
    
    func hitServiceForremoveFav(params: [String:Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.deletefavourite)"
        let headers: HTTPHeaders = [:]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
    func hitServiceForAddFav(params: [String:Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.addtofavourite)"
        let headers: HTTPHeaders = [:]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
    func hitServiceForUpdateUserLocation(params: [String:Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.updatecurrentlocation)"
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }

    
    func hitServiceForGetNotification(params: [String:Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.getnotifications)"
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
    func hitServiceForGetHistory(params: [String:Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.getrewardhistory)"
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
    func hitServiceForGetBusinessURl(params: [String:Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.getbusinessurl)"
        let headers: HTTPHeaders = [:]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }


    //MARK : Get states
    func hitServiceForGetBusinessList(params: [String:Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrlOld)\(ServiceUrls.getbusinesses)"
        let headers: HTTPHeaders = [:]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
    
    
    func hitServiceForGetEvent(params: [String:Any],duration: String, completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.getevents)"
   
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
        
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
    func hitServiceForFavBusiness(params: [String:Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.fav_business)"
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
   
    func hitServiceForRemoveFavBusiness(params: [String:Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.deletefavourite)"
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
    
    func hitServiceForGetEventDetails(params: [String:Any] , completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.getevent)"
        let headers: HTTPHeaders = [:]
        self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
    }
    
    //MARK : Get Address
    func hitServiceForGetAddress(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_address)?state_id=\(params["state_id"] ?? 0)&access_token=\(params["access_token"] ?? "")"
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
        self.hitGetServiceWithUrlString(urlString: urlString, parameters: [:], headers: headers, completion: completion)
    }
    
    //MARK : Create Request
       func hitServiceForCreateRequest(_ params:[String : Any], completion:@escaping completionBlockType)
       {
           let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.create_request)"
           let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
           self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
       }


    //MARK : Create Vendor Account
        func hitServiceForPLanList( completion:@escaping completionBlockType)
        {
            let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.getplan)"
            let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
            self.hitGetServiceWithUrlString(urlString: urlString, parameters: [:] as [String : AnyObject], headers: headers, completion: completion)
        }
   
    
    func hitServiceForsubscriptiondetail(params: [String: Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.getsubscriptiondetail)"
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    func hitServiceForupdatesubscription(params: [String: Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.updatesubscription)"
        let headers: HTTPHeaders = [:]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
   
    func hitServiceForEditProfile(params: [String:Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.updateprofile)"
   
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
        
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
    func hitServiceForEditProfileImage(params: [String: Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.updateprofilephoto)"
   
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
        
        self.imageUpload(urlString, params: params, data: nil, imageKey: "photo", headers: headers, completion: completion)
    }
      
    
    func hitServiceForGetPreference(params: [String:Any],completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.getuserpreferences)"
   
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
        
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }

    func hitServiceForUpdatePreference(params: [String:Any],completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.updatepreferences)"
   
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
        
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    
    
    func hitServiceForLogout(params: [String: Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.logout_api)"
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
    }
    //ChangePassword
    func hitServiceForchagePassword(_ params:[String : Any], completion:@escaping completionBlockType)
          {
              let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.change_password)"
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
        self.imageUpload(urlString, params: params, data: nil, imageKey: "file", headers: headers, completion: completion)
          }
    
    //MARK : delete Notification
         func hitServiceForDeleteNotifications(_ params:[String : Any], completion:@escaping completionBlockType)
         {
             let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.update_notification_logs)"
             let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
          self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
         }
    
    
    //MARK : Get All Notification
    func hitServiceForGetAllNotifications(_ params:[String : Any], completion:@escaping completionBlockType)
        {
            let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.list_notification_logs)"
            let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
         self.hitGetServiceWithUrlParams(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
        }
   
       //MARK : Create Gift
              func hitServiceForaddGiftOfferAndRequest(_ params:[String : Any], completion:@escaping completionBlockType)
              {
                  let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.create_gift_request)"
                  let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
               self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
              }
    
    
    
      //MARK : Create Invitation
              func hitServiceForaCreateInvitation(_ params:[String : Any], completion:@escaping completionBlockType)
              {
                  let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.create_invitation)"
                  let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
               self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
              }
    
    
    //MARK : Get All Notification
    func hitServiceForGetAllGiftRequest(_ params:[String : Any], completion:@escaping completionBlockType)
        {
            let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_gift_request)"
            let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
         self.hitGetServiceWithUrlParams(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
        }
    
    
    //MARK : Planner Add
             func hitServiceForaddPlanner(_ params:[String : Any], completion:@escaping completionBlockType)
             {
                 let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.create_planner_request)"
                 let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
              self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
             }
    
    //MARK : Get supported
             func hitServiceForCreateGetSupport(_ params:[String : Any], completion:@escaping completionBlockType)
             {
                 let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.create_support_ticket)"
                 let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
              self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
             }
    
    //MARK:- Share
    func hitServiceForShareApp(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.share_app_via_sms)"
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
       
        self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
    }

}
