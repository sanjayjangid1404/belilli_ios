//
//  LocationManager.swift
//  BeLilli
//
//  Created by apple on 13/11/21.
//

import Foundation
import CoreLocation
import UIKit
class LocationManager: NSObject {
    static let shared = LocationManager()
    
    var locationManager = CLLocationManager()
    var location : CLLocation?
    
    static let UPDATE_SERVER_INTERVAL = 60 * 10
    static let timeInterval = 60 * 10
    
    var currentBgTaskId : UIBackgroundTaskIdentifier?
    var lastLocationDate : NSDate = NSDate()
    var isFirstTime = false
    var timerBack  = Timer()
    
    
    override init() {
        super.init()
        isFirstTime = true
//        doBackgroundTask()
    }
    
    
    func doBackgroundTask() {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.beginBackgroundUpdateTask()
            
            print("Background time remaining = \(UIApplication.shared.backgroundTimeRemaining) seconds")
            
            self.timerBack = Timer.scheduledTimer(timeInterval: 60*15, target: self, selector: #selector(self.updateUserCurrentLocation), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timerBack, forMode: RunLoop.Mode.default)
            RunLoop.current.run()
            
            self.endBackgroundUpdateTask()
        }
    }
    var backgroundUpdateTask: UIBackgroundTaskIdentifier!
    
    func beginBackgroundUpdateTask() {
        self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            self.endBackgroundUpdateTask()
        })
    }
    
    func endBackgroundUpdateTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskIdentifier.invalid
    }
    
    func checkPermission() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                Common.showAlert(alertMessage: "Please enable the user current location", alertButtons: ["Ok"]) { btn in
                    if let url = URL(string: "App-prefs:root=LOCATION_SERVICES") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                self.locationManager.delegate = self
                self.locationManager.startUpdatingLocation()
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.distanceFilter = 100.0
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
                locationManager.allowsBackgroundLocationUpdates = false
                
            @unknown default:
                break
            }
//        } else {
//            print("Location services are not enabled")
//            Common.showAlert(alertMessage: "Please enable the user current location", alertButtons: ["Ok"]) { btn in
//                if let url = URL(string: "App-prefs:root=LOCATION_SERVICES") {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//            }
//        }
    }
    
    
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.restricted:
        //log("Restricted Access to location")
            checkPermission()
        case CLAuthorizationStatus.denied:
        //log("User denied access to location")
            checkPermission()
        case CLAuthorizationStatus.notDetermined:
        //log("Status not determined")
            checkPermission()
        default:
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        self.location = location
        //self.locationManager.stopUpdatingLocation()
        if isFirstTime {
            isFirstTime = false
            lastLocationDate = NSDate()
//            self.updateUserCurrentLocation()
        }
        let now = NSDate()
        if(isItTime(now: now)){
            lastLocationDate = NSDate()
//            self.updateUserCurrentLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func isItTime(now:NSDate) -> Bool {
        let timePast = now.timeIntervalSince(lastLocationDate as Date)
        let intervalExceeded = Int(timePast) > LocationManager.UPDATE_SERVER_INTERVAL
        return intervalExceeded
    }
    
    
    @objc private func updateUserCurrentLocation() {
        var params = [String:Any]()
        params["user_id"] = AppHelper.getStringForKey(ServiceKeys.user_id)
        params["lat"] = location?.coordinate.latitude ?? 0.0
        params["lang"] = location?.coordinate.longitude ?? 0.0
        
        ServiceClass.sharedInstance.hitServiceForUpdateUserLocation(params: params) { type, parseData, errorDict in
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                print("User Location updated")
            } else {
                let errormsg = (errorDict?[ServiceKeys.keyErrorMessage] as? String)!
                print("User Location Error - \(errormsg)")
            }
            
        }
    }
    
}
