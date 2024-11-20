//
//  ActivityViewController.swift
//  BeLilli
//
//  Created by apple on 16/02/23.
//

import UIKit

class ActivityViewController: BaseViewController  {

    
    @IBOutlet weak var tblActivity: UITableView!
    @IBOutlet weak var noRecrodLabel: UILabel!

    var dataActivityArr: [BusinessDTo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.backButton.isHidden = true
        self.navTitle.text = "Activity"
        tblActivity.delegate = self
        tblActivity.dataSource = self
        noRecrodLabel.isHidden = true
        getActivityList()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func getActivityList() {

        ServiceClass.sharedInstance.getActivityList(params: ["user_id": AppHelper.getStringForKey(ServiceKeys.user_id)]) { type, parseData, errorDict in
            self.dataActivityArr = [BusinessDTo]()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                for obj in parseData["data"]["acitivity"].arrayValue {
                    self.dataActivityArr?.append(BusinessDTo(fromJson: obj))
                }
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
            self.tblActivity.reloadData()
            self.noRecrodLabel.isHidden = self.dataActivityArr?.count != 0
        }
    }


}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataActivityArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityTableViewCell", for: indexPath) as! ActivityTableViewCell
        cell.setUpData(data: dataActivityArr?[indexPath.row])
        return cell
    }

}
