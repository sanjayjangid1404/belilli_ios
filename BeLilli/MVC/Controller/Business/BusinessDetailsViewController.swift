//
//  BusinessDetailsViewController.swift
//  BeLilli
//
//  Created by apple on 11/02/23.
//

import UIKit
import CoreLocation

class BusinessDetailsViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var businessImage: UIImageView!
    
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var discountDetailsLabel: UILabel!
    
    @IBOutlet weak var titleMapLabel: UILabel!
    @IBOutlet weak var titleMapDescriptionLabel: UILabel!
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var businessDetails: BusinessDTo?
    var businessId: String?
    var locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isHidden = true
        btnBack.setTitle("", for: .normal)
        detailsApiCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setUpValues() {
                
        guard let data = businessDetails else {
            return
        }
        scrollView.isHidden = false
        categoryNameLabel.text = "  \(data.category_name ?? "")  "
        distanceLabel.text = "  \(data.town ?? "")  "
        
        titleLabel.text = data.business_name
        discountLabel.text = data.offer_title
        discountDetailsLabel.text = data.offer_terms
        titleMapLabel.text
        = data.business_name
        titleMapDescriptionLabel.text = data.description
        
        businessImage.sd_setImage(with: URL(string: ServiceUrls.baseUrlImage + (data.image ?? "")), placeholderImage: #imageLiteral(resourceName: "placeholder_icon"))
        
    }

    
    @IBAction func getOfferAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            appDelegate.tabbar?.selectedIndex = 2
        }
        
    }
    
    @IBAction func findMapAction(_ sender: UIButton) {
        guard let data = businessDetails else {
            return
        }
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            if let locationLat = locationManager.location?.coordinate.latitude,  let locationLon = locationManager.location?.coordinate.longitude {
                
                UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(locationLat),\(locationLon)&zoom=14&views=traffic&q=\(data.lat ?? "0.0"),\(data.lng ?? "0.0")")!, options: [:], completionHandler: nil)
            }
                


//            UIApplication.shared.open(URL(string:
//                                            "comgooglemaps://?saddr=&daddr=\(data.lat ?? "0"),\(data.lng ?? "0.0")&directionsmode=driving")!)

                }
            }
    
    
    @IBAction func likeButtonAction(_ sender: UIButton) {
        favoriteApiCall()
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func favoriteApiCall() {
        var params = [String:Any]()
        params["business_id"] = businessDetails?.id
        params["user_id"] = AppHelper.getStringForKey(ServiceKeys.user_id)
        
        ServiceClass.sharedInstance.hitServiceForAddFav(params: params) { type, parseData, errorDict in
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                Common.showAlert(alertMessage: parseData["message"].stringValue, alertButtons: ["Ok"]) { btn in
                    self.navigationController?.popViewController(animated: true)
                }
                
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        }
    }
    
    private func detailsApiCall() {
        var params = [String:Any]()
        params["business_id"] = businessId
//        params["user_id"] = AppHelper.getStringForKey(ServiceKeys.user_id)
        
        ServiceClass.sharedInstance.hitServiceForGetBusinessDetails(params: params) { type, parseData, errorDict in
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                self.businessDetails = BusinessDTo(fromJson:parseData["data"])
                self.setUpValues()
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        }
    }

}


