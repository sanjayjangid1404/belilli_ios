//
//  QRScannerViewController.swift
//  QRCodeReader
//
//  Created by KM, Abhilash a on 08/03/19.
//  Copyright © 2019 KM, Abhilash. All rights reserved.
//

import UIKit
import AudioToolbox
import SwiftyJSON

class QRScannerViewController: BaseViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    @IBOutlet weak var scanButton: UIButton! {
        didSet {
            scanButton.setTitle(" STOP ", for: .normal)
        }
    }
    
    var qrData: QRData? = nil {
        didSet {
            if qrData != nil {
                self.openOhterScreen()
            }
        }
    }
    
    var objPlan : PlanDTo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton.isHidden = true
        
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
        if !scannerView.isRunning {
            scannerView.startScanning()
        }
        viewContainer.isHidden = true
//        getSubscriptiondetail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }

    @IBAction func scanButtonAction(_ sender: UIButton) {
        scannerView.isRunning ? scannerView.stopScanning() : scannerView.startScanning()
        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
        sender.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func subscriptionButtonAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "planListVC") as! PlanListVC
        //vc.user = user
        vc.isFromSignup = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openOhterScreen() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        getURL()
//        Common.showAlert(alertMessage: "Opened QR code \(qrData?.codeString ?? "")", alertButtons: ["ok"]) { btn in
//        }
    }
    
    private func showInactiveView() {
        if isUserSubscriptionActive(subscriptionStatus: objPlan?.subscription_status ?? "0") {
            viewContainer.isHidden = true
        } else {
            viewContainer.isHidden = false
        }
    }
    
    private func isUserSubscriptionActive(subscriptionStatus: String) -> Bool {
        return subscriptionStatus == SubscriptionStatus.active.rawValue
    }

}


extension QRScannerViewController: QRScannerViewDelegate {
    func qrScanningDidStop() {
        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
        scanButton.setTitle(buttonTitle, for: .normal)
    }
    
    func qrScanningDidFail() {
        
        Common.showAlert(alertMessage: "Scanning Failed. Please try again", alertButtons: ["ok"]) { btn in
        }
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        self.qrData = QRData(codeString: str)
    }
    
   func getURL() {
    var params = [String:Any]()
    params["business_id"] = qrData?.codeString ?? ""
    params["user_id"] = AppHelper.getStringForKey(ServiceKeys.user_id)
//    params["scan_time"] = Utilities.getCurrentTime()
//    params["scan_date"] = Utilities.getCurrentDate()

    ServiceClass.sharedInstance.hitServiceForGetBusinessURl(params: params) { type, parseData, errorDict in
        if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
             let businessDetails = BusinessDTo(fromJson:parseData["data"])
            if let url = URL(string: businessDetails.website) {
                UIApplication.shared.open(url)
            }
        } else {
            self.makeToast("No Url Found")
        }
    }
    }
    
    func getSubscriptiondetail() {
        ServiceClass.sharedInstance.hitServiceForsubscriptiondetail(params:  ["user_id": AppHelper.getStringForKey(ServiceKeys.user_id)]) { type, parseData, errorDict in
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                self.objPlan = PlanDTo(fromJson:parseData["data"]["user"])
                AppHelper.setStringForKey(self.objPlan?.subscription_status, key: ServiceKeys.keySubscriptionStatus)
                self.showInactiveView()
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        }
    }
    
}


