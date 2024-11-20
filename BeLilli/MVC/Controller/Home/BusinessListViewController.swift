//
//  BusinessListViewController.swift
//  BeLilli
//
//  Created by apple on 27/10/21.
//

import UIKit

class BusinessListViewController: BaseViewController {
    
    @IBOutlet weak var tblHome: UITableView!
    var dataBusinessArr: [BusinessDTo]?
    var category: [CategoryDTo]?
    
    var currentPage : Int = 0
    var isLoadMore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblHome.delegate = self
        tblHome.dataSource = self
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navTitle.text =  "Business"
    }
    
}


extension BusinessListViewController: UITableViewDelegate,UITableViewDataSource {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && isLoadMore) {
               self.loadMoreItemsForList()
           }
       }
    
    func loadMoreItemsForList(){
        if isLoadMore {
            isLoadMore = false
            currentPage += 1
            getBusinessList()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBusinessArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
            let cell = tableView.dequeueReusableCell(withIdentifier: "businessListCell", for: indexPath) as! BusinessListCell
        let objData = self.dataBusinessArr?[indexPath.item]
        cell.setup(heading: "", data: objData)
            return cell
        }

    
    
}

extension BusinessListViewController {
    
    func getBusinessList() {
        let category_ids = category?.map({$0.id}).joined(separator: ",")
        if currentPage == 1 { self.dataBusinessArr = [BusinessDTo]() }
        ServiceClass.sharedInstance.hitServiceForGetBusiness(params: ["pagecount": currentPage, "limit": 10, "category_ids": category_ids ?? ""]) { type, parseData, errorDict in
            
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                self.isLoadMore = parseData["has_more"].boolValue
                for obj in parseData["data"].arrayValue {
                    self.dataBusinessArr?.append(BusinessDTo(fromJson: obj))
                }
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
            self.tblHome.reloadData()
        }
    }
    
    
    
}
