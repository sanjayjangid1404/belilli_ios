//
//  FavoriteViewController.swift
//  BeLilli
//
//  Created by apple on 01/11/21.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils

class FavoriteViewController: BaseViewController {
    
    @IBOutlet weak var tblExplore: UITableView!
    @IBOutlet weak var noRecrodLabel: UILabel!
    
    
        var dataBusinessArr: [BusinessDTo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.hideKeyboardWhenTappedAround()
        
        tblExplore.delegate = self
        tblExplore.dataSource = self
        self.noRecrodLabel.isHidden = true
        addLeftTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        getFavList()
    }
    
    private func addLeftTitle() {
        let navTitle = UILabel()
        navTitle.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        navTitle.frame = CGRect(x: 0, y: 0, width:self.view.frame.width/2 + 30, height: 44)
        navTitle.text = "Places I love"
        navTitle.numberOfLines = 2
        navTitle.textColor = UIColor.white
        navTitle.backgroundColor = .clear
        navTitle.textAlignment = .left
        let barButton = UIBarButtonItem(customView: navTitle)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
}
extension FavoriteViewController : UITableViewDelegate,UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBusinessArr?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessListCell", for: indexPath) as! BusinessListCell
        cell.likeButton.tag = indexPath.row
        cell.likeButton.setTitle("", for: .normal)
        cell.likeButton.addTarget(self, action: #selector(buttonLikeAction), for: .touchUpInside)
        cell.setup(heading: "", data: self.dataBusinessArr?[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Fav", bundle: nil).instantiateViewController(withIdentifier: "businessDetailsViewController") as! BusinessDetailsViewController
        vc.businessId = self.dataBusinessArr?[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func reloadState(index: Int) {
        
        self.dataBusinessArr?.remove(at: index)
        self.noRecrodLabel.isHidden = self.dataBusinessArr?.count != 0
        tblExplore.reloadData()
    }
    
    @objc func buttonLikeAction(_ sender: UIButton) {
        Common.showAlert(alertMessage: "Are you sure, you want to remove it from your favourites?", alertButtons: ["No", "Yes"]) { btn in
            if btn == "Yes" {
                self.removeFromFav(index: sender.tag)
            }
        }
    }
    
    
    func getFavList() {

        ServiceClass.sharedInstance.getFavList(params: ["user_id": AppHelper.getStringForKey(ServiceKeys.user_id)]) { type, parseData, errorDict in
            self.dataBusinessArr = [BusinessDTo]()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                for obj in parseData["data"].arrayValue {
                    self.dataBusinessArr?.append(BusinessDTo(fromJson: obj))
                }
                self.tblExplore.reloadData()
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
            self.noRecrodLabel.isHidden = self.dataBusinessArr?.count != 0
        }
    }
    
    
    func removeFromFav(index: Int) {
        guard let data = self.dataBusinessArr?[index] else { return }

        ServiceClass.sharedInstance.hitServiceForremoveFav(params: ["user_id": AppHelper.getStringForKey(ServiceKeys.user_id), "business_id": data.id ?? ""]) { type, parseData, errorDict in
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                Common.showAlert(alertMessage: parseData["message"].stringValue, alertButtons: ["Ok"]) { btn in
                    self.reloadState(index: index)
                }
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        }
    }
    
}
