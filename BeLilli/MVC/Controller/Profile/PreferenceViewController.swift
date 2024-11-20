//
//  PreferenceViewController.swift
//  BeLilli
//
//  Created by apple on 12/01/22.
//

import UIKit

class NotificationSettings {
    
    var id   : String!
    var name   : String!
    var description : String!
    var isSelected: Bool = false
    
    init(id: String, name: String, description: String, isSelected: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.isSelected = isSelected
    }
    
}


class PreferenceViewController: BaseViewController {
    @IBOutlet weak var tblOption: UITableView!
    
    var locationArr: [LocationDTo]?
    var filterArr: [CategoryDTo]?
    var dataCommonArr = [LocationDTo]()
    var dataNotificationArr = [NotificationSettings]()

    var new_reward_notification_flag = "0"
    var proximity_notification_flag = "0"
    var tncard_update_notification_flag = "0"

    
    let disPatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblOption.delegate = self
        tblOption.dataSource = self
        self.navTitle.text = "My preferences"
        addRightBarButton()
        
        getCategories()
//        getLocation()
        getPreference()
        disPatchGroup.notify(queue: .main) {
            self.setSelectedCategoryAndLocation(self.dataCommonArr)
            self.tblOption.reloadData()
        }
        
    }
    
    func addRightBarButton() {
        let rubricButton  = UIButton(type: UIButton.ButtonType.system)
        rubricButton.frame = CGRect(x: 0, y: 0, width: 90, height: 32)
        rubricButton.backgroundColor = UIColor.clear
        rubricButton.layer.cornerRadius = 16
        rubricButton.setTitle("Save", for: .normal)
        rubricButton.setTitleColor(.white, for: .normal)
        rubricButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16.0)!
        rubricButton.addTarget(self, action: #selector(btnSaveAction), for: .touchUpInside)
        let rubricBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: rubricButton)
        self.navigationItem.setRightBarButtonItems([rubricBarButtonItem], animated: false)
    }
    
    @objc func btnSaveAction(_ sender: UIBarButtonItem) {
        updatePreference()
    }
    
    func getCategories() {
        disPatchGroup.enter()
        ServiceClass.sharedInstance.hitServiceForGetCategories(params: [:]) { type, parseData, errorDict in
            self.disPatchGroup.leave()
            self.filterArr = [CategoryDTo]()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                let allBusiness = CategoryDTo()
                allBusiness.id = "-1"
                allBusiness.name = "All businesses"
                allBusiness.isSelected = false
                self.filterArr?.append(allBusiness)

                for obj in parseData["data"].arrayValue {
                    self.filterArr?.append(CategoryDTo(fromJson: obj))
                }
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        }
    }
    
//    func getLocation() {
//        disPatchGroup.enter()
//        ServiceClass.sharedInstance.hitServiceForGetLOcation(params: [:]) { type, parseData, errorDict in
//            self.locationArr = [LocationDTo]()
//            self.disPatchGroup.leave()
//            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
//                let allAreas = LocationDTo()
//                allAreas.id = "-1"
//                allAreas.name = "All areas"
//                allAreas.isSelected = false
//                self.locationArr?.append(allAreas)
//
//                for obj in parseData["data"].arrayValue {
//                    self.locationArr?.append(LocationDTo(fromJson: obj))
//                }
//            } else {
//                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
//            }
//            self.tblOption.reloadData()
//        }
//    }
    
}


extension PreferenceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return (locationArr?.count ?? 0)
        case 1:
            return (filterArr?.count ?? 0)
        default:
            return (dataNotificationArr.count )
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            
        switch section {
        case 0:
            return "My locations"
        case 1:
            return "My categories"
        default:
            return "My notifications"
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 19.0)
        header.textLabel?.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
               headerTitle.backgroundView?.backgroundColor = CustomColor.lightColor
           }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterTableViewCell", for: indexPath) as! FilterTableViewCell
//        cell.backgroundColor =  indexPath.item % 2 == 0  ? CustomColor.lightColor : .white
        cell.switchFilter.tag = indexPath.row
        cell.switchFilter.section = indexPath.section
        if indexPath.section == 0 {
            cell.lbllblTitle.text = self.locationArr?[indexPath.row].name.html2String
            cell.switchFilter.isOn = self.locationArr?[indexPath.row].isSelected ?? false
            cell.switchFilter.addTarget(self, action: #selector(locationSwitchValueChanged(_:)), for: .valueChanged)
        } else if indexPath.section == 1 {
            cell.lbllblTitle.text = self.filterArr?[indexPath.row].name.html2String
            cell.switchFilter.isOn = self.filterArr?[indexPath.row].isSelected ?? false
            cell.switchFilter.addTarget(self, action: #selector(businessSwitchValueChanged(_:)), for: .valueChanged)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "fitlerSettingTableViewCell", for: indexPath) as! FitlerSettingTableViewCell
            cell.switchFilter.tag = indexPath.row
            cell.switchFilter.section = indexPath.section

            cell.lbllblTitle.text = self.dataNotificationArr[indexPath.row].name
            cell.lblDescription.text = self.dataNotificationArr[indexPath.row].description
            cell.switchFilter.isOn = self.dataNotificationArr[indexPath.row].isSelected
            cell.switchFilter.addTarget(self, action: #selector(notificationSwitchValueChanged(_:)), for: .valueChanged)
            return cell
        }
        return cell
    }
    
    @objc func locationSwitchValueChanged(_ sender: CustomSwitch) {
        let indexRow = sender.tag
        guard sender.section == 0 else {
            return
        }
        if indexRow == 0 {
            if sender.isOn {
                self.locationArr?.forEach{ $0.isSelected = true }
            } else {
                self.locationArr?.forEach{ $0.isSelected = false }
            }
            self.tblOption.reloadData()
        } else {
            locationArr?[indexRow].isSelected = !(locationArr?[indexRow].isSelected ?? false)
            
            if areAllLocationSelected() {
                self.locationArr?[0].isSelected = true
                self.tblOption.reloadData()
            } else if self.locationArr?[0].isSelected == true {
                if isAtleastLocationNotSelected() {
                    self.locationArr?[0].isSelected = false
                    self.tblOption.reloadData()
                } else {
                    self.tblOption.reloadRows(at: [IndexPath(row: indexRow, section: sender.section ?? 0)], with: .none)
                }
            } else {
                self.tblOption.reloadRows(at: [IndexPath(row: indexRow, section: sender.section ?? 0)], with: .none)
            }
            
        }
    }
    
    private func areAllLocationSelected() -> Bool {
        let filteredLocations = locationArr?.filter { locationObj in
            return locationObj.isSelected == true && locationObj.id != "-1"
        }
        return filteredLocations?.count == (locationArr?.count ?? 0) - 1
    }
    
    private func isAtleastLocationNotSelected() -> Bool {
        let filteredLocations = locationArr?.filter { locationObj in
            return locationObj.isSelected == false && locationObj.id != "-1"
        }
        return filteredLocations?.count != (locationArr?.count ?? 0) - 1

    }

    
    @objc func businessSwitchValueChanged(_ sender: CustomSwitch) {
        let indexRow = sender.tag
        
        guard sender.section == 1 else {
            return
        }

        if indexRow == 0 {
            if sender.isOn {
                self.filterArr?.forEach{ $0.isSelected = true }
            } else {
                self.filterArr?.forEach{ $0.isSelected = false }
            }
            self.tblOption.reloadData()
        } else {
            filterArr?[indexRow].isSelected = !(filterArr?[indexRow].isSelected ?? false)

            if areAllbusinessSelected() {
                self.filterArr?[0].isSelected = true
                self.tblOption.reloadData()
            } else if self.filterArr?[0].isSelected == true {
                if isAtleastbusinessNotSelected() {
                    self.filterArr?[0].isSelected = false
                    self.tblOption.reloadData()
                } else {
                    self.tblOption.reloadRows(at: [IndexPath(row: indexRow, section: sender.section ?? 0)], with: .none)
                }
            } else {
                self.tblOption.reloadRows(at: [IndexPath(row: indexRow, section: sender.section ?? 0)], with: .none)
            }

        }
    }
    
    private func areAllbusinessSelected() -> Bool {
        let filteredBusiness = filterArr?.filter { businessObj in
            return businessObj.isSelected == true && businessObj.id != "-1"
        }
        return filteredBusiness?.count == (filterArr?.count ?? 0) - 1
    }
    
    private func isAtleastbusinessNotSelected() -> Bool {
        let filteredBusiness = filterArr?.filter { businessObj in
            return businessObj.isSelected == false && businessObj.id != "-1"
        }
        return filteredBusiness?.count != (filterArr?.count ?? 0) - 1

    }

    
    @objc func notificationSwitchValueChanged(_ sender: CustomSwitch) {
        let indexRow = sender.tag

        guard sender.section == 2 else {
            return
        }
        
        if indexRow == 0 {
            if sender.isOn {
                self.dataNotificationArr.forEach{ $0.isSelected = true }
                new_reward_notification_flag = "1"
                proximity_notification_flag = "1"
                tncard_update_notification_flag = "1"

            } else {
                self.dataNotificationArr.forEach{ $0.isSelected = false }
                new_reward_notification_flag = "0"
                proximity_notification_flag = "0"
                tncard_update_notification_flag = "0"

            }
        } else if indexRow == 1 {
            if sender.isOn {
                dataNotificationArr[indexRow].isSelected = true
                new_reward_notification_flag = "1"
            }else {
                dataNotificationArr[indexRow].isSelected = false
                new_reward_notification_flag = "0"
            }
        } else if indexRow == 2 {
            if sender.isOn {
                dataNotificationArr[indexRow].isSelected = true
                proximity_notification_flag = "1"
            }else {
                dataNotificationArr[indexRow].isSelected = false
                proximity_notification_flag = "0"
            }
        } else if indexRow == 3 {
            if sender.isOn {
                dataNotificationArr[indexRow].isSelected = true
                tncard_update_notification_flag = "1"
            }else {
                dataNotificationArr[indexRow].isSelected = false
                tncard_update_notification_flag = "0"
            }
        }
        
        if areAllNotificationsSelected() {
            self.dataNotificationArr[0].isSelected = true
            self.tblOption.reloadData()
        } else if areAtleastNotificationsSelected() {
                self.dataNotificationArr[0].isSelected = false
                self.tblOption.reloadData()
        } else {
            self.tblOption.reloadRows(at: [IndexPath(row: indexRow, section: sender.section ?? 0)], with: .none)
        }

    }
    

}


extension PreferenceViewController {
    
    func getPreference() {
        disPatchGroup.enter()
        
        ServiceClass.sharedInstance.hitServiceForGetPreference(params: ["user_id": AppHelper.getStringForKey(ServiceKeys.user_id)]) { type, parseData, errorDict in
          
            self.disPatchGroup.leave()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                self.new_reward_notification_flag = parseData["data"]["new_reward_notification_flag"].string ?? "0"
                self.proximity_notification_flag = parseData["data"]["proximity_notification_flag"].string ?? "0"
                self.tncard_update_notification_flag = parseData["data"]["tncard_update_notification_flag"].string ?? "0"

                for obj in parseData["data"]["preferences"].arrayValue {
                    self.dataCommonArr.append(LocationDTo(fromJson: obj))
                }
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        }
    }
    
    func setSelectedCategoryAndLocation(_ dataCommonArr: [LocationDTo]) {
        let locationIds = dataCommonArr.filter({$0.preference == "location"}).map({$0.pref_value})
        self.locationArr?.forEach({ obj in
            if locationIds.contains(obj.id) {
                obj.isSelected = true
            }
        })
        // Select All Areas
        if locationIds.count == self.locationArr?.count {
            self.locationArr?[0].isSelected = true
        }

        let cateGoryIds = dataCommonArr.filter({$0.preference == "category"}).map({$0.pref_value})
        self.filterArr?.forEach({ obj in
            if cateGoryIds.contains(obj.id) {
                obj.isSelected = true
            }
        })
        
        // Select all business
        if cateGoryIds.count == self.filterArr?.count {
            self.filterArr?[0].isSelected = true
        }
        
        createNotificationArray()
    }
    
    func createNotificationArray() {
        let allNotifications = NotificationSettings(id: "-1", name: "All notifications", description: "Turn on all notifications from the BeLilli. Alternatively select below which you’d like to receive.", isSelected: areAllNotificationsSelected() ? true: false)
        let newRewards = NotificationSettings(id: "1", name: "New rewards", description: "Alerts on rewards in your favourite categories and locations.", isSelected: new_reward_notification_flag == "0" ? false : true)
        let locationUpdates = NotificationSettings(id: "2", name: "Location updates", description: "Alerts when rewards are close to you.", isSelected: proximity_notification_flag == "0" ? false : true)
        let cardUpdates = NotificationSettings(id: "3", name: "The BeLilli updates", description: "News regarding the scheme.", isSelected: tncard_update_notification_flag == "0" ? false : true)


        dataNotificationArr.append(allNotifications)
        dataNotificationArr.append(newRewards)

        dataNotificationArr.append(locationUpdates)
        dataNotificationArr.append(cardUpdates)

    }
    
    private func areAllNotificationsSelected() -> Bool {
        return new_reward_notification_flag == "1" && proximity_notification_flag == "1" && tncard_update_notification_flag == "1"
    }

    private func areAtleastNotificationsSelected() -> Bool {
        return new_reward_notification_flag == "0" || proximity_notification_flag == "0" || tncard_update_notification_flag == "0"
    }

    
    func updatePreference() {
        let category = (filterArr?.filter({$0.isSelected ?? true }).map({$0.id ?? ""}) ?? []).joined(separator: ",")
        let locationArr = locationArr?.filter({$0.isSelected }).map({$0.id ?? ""}) ?? []
        
        let location = locationArr.joined(separator: ",")
        ServiceClass.sharedInstance.hitServiceForUpdatePreference(params: ["user_id": AppHelper.getStringForKey(ServiceKeys.user_id),"category": category,"location": location, "new_reward_notification_flag": new_reward_notification_flag, "proximity_notification_flag": proximity_notification_flag, "tncard_update_notification_flag": tncard_update_notification_flag]) { type, parseData, errorDict in
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                Common.showAlert(alertMessage: parseData["message"].stringValue, alertButtons: ["Ok"]) { btn in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        }
    }
    
}
