//
//  NotificationViewController.swift
//  BeLilli
//
//  Created by apple on 30/10/21.
//

import UIKit

class NotificationViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tblNotification: UITableView!
    @IBOutlet weak var noRecrodLabel: UILabel!

    var dataNotificationArr: [NotificationListDTo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblNotification.delegate = self
        tblNotification.dataSource = self
        self.navTitle.text = "Notifications"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNotificationList()
    }
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataNotificationArr?.count ?? 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "notifcationTableViewCell", for: indexPath) as! NotifcationTableViewCell
        
        let objNotificationData = self.dataNotificationArr?[indexPath.item]

        if objNotificationData?.read_status == "0"  {
            //cell.backgroundColor = UIColor(hexString: "#BA0E5E")
            cell.backgroundColor = UIColor(hexString: "#081c34")
            cell.lblHead.textColor = .white
            cell.lblTime.textColor = .white
            cell.lblOffer.textColor = .white
            cell.lblSeperator.backgroundColor = UIColor(red: 8.0/255.0, green: 8.0/255.0, blue: 22.0/255.0, alpha: 1.0)

        } else {
            cell.backgroundColor = .white
            cell.lblHead.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            cell.lblTime.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            cell.lblOffer.textColor = UIColor(red: 153.0/255.0, green: 143.0/255.0, blue: 162.0/255.0, alpha: 1.0)
            cell.lblSeperator.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)

        }
        
        cell.lblHead.text = objNotificationData?.title
        cell.lblTime.text = objNotificationData?.message_date
        cell.lblOffer.text = objNotificationData?.message
        return cell
    }

    
}

extension NotificationViewController {
    
    func getNotificationList() {
        var params = [String:Any]()
        params["user_id"] = AppHelper.getStringForKey(ServiceKeys.user_id)
        ServiceClass.sharedInstance.hitServiceForGetNotification(params: params) { type, parseData, errorDict in
            self.dataNotificationArr = [NotificationListDTo]()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                for obj in parseData["data"]["notifications"].arrayValue {
                    self.dataNotificationArr?.append(NotificationListDTo(fromJson: obj))
                }
                self.readNotification()

            } else {
                self.makeToast("No record found")
            }
            
            self.noRecrodLabel.isHidden = (self.dataNotificationArr?.count ?? 0) != 0
            
            self.reloadTableView()
        }
    }

    func reloadTableView() {
        DispatchQueue.main.async {
            self.tblNotification.reloadData()
        }
    }
    
    func readNotification() {
        ServiceClass.sharedInstance.hitServiceForReadNotification(params: ["user_id": AppHelper.getStringForKey(ServiceKeys.user_id)]) { type, parseData, errorDict in
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
            
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        }
    }
    

}
