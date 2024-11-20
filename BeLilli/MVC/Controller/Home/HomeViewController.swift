//
//  HomeViewController.swift
//  BeLilli
//
//  Created by apple on 09/10/21.
//

import UIKit
import GoogleMaps
import SwiftyJSON


class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tblHome: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblNotificationCount: UILabel!
    @IBOutlet weak var viewNoRecord: UIView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBackView: UIView!
    
    let dispatchGroup = DispatchGroup()
    
    private var worker: DispatchWorkItem?
    private var searchedList : [String]?
    
    var currentPage : Int = 1
    var isLoadMore = true
    var filterObj: Filter?
    
    private enum DataType: String {
        case category
        case feature
        case business
    }
    
    private var sectionsArray: [String:HomeDTo] = [:]
    let refreshControl = UIRefreshControl()
    
    
    var objPlan : PlanDTo?
    var unreadCount: String = ""
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNoRecord.isHidden = true
        self.view.backgroundColor = CustomColor.appThemeColor
        self.hideKeyboardWhenTappedAround()
        
        tblHome.delegate = self
        tblHome.dataSource = self
        searchBar.delegate = self
        lblNotificationCount.isHidden = true
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        LocationManager.shared.checkPermission()
        self.imgProfile.image = UIImage(named: "placeHolder")
        getData()
        //printFontFamily()
        searchBar.setupSearchBar()
        addPullToReferash()
        addSearchTable()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        updateUserProfileImage()
        //        getSubscriptiondetail()
    }
    
    private func addPullToReferash() {
        refreshControl.tintColor = .white
        let refreshTitle = NSAttributedString(string: "Pull to refersh",
                                              attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        refreshControl.attributedTitle = refreshTitle
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblHome.addSubview(refreshControl)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    @objc func refresh(_ refresh: UIRefreshControl) {
        getData()
        refreshControl.endRefreshing()
    }
    
    private func updateUserProfileImage() {
        let userProfileImage = AppHelper.getStringForKey(ServiceKeys.profile_image)
        if userProfileImage.isEmpty {
            self.imgProfile.image = UIImage(named: "placeHolder")
        } else {
            imgProfile.kf.setImage(with: URL(string: ServiceUrls.baseUrl + userProfileImage), placeholder: UIImage(named: "placeholder"), options: nil, progressBlock: nil) { (result) in
                switch result {
                case .failure(let err):
                    print(err)
                    self.imgProfile.image = UIImage(named: "placeholder")
                case .success(let value):
                    print(value.source.url?.absoluteString ?? "")
                }
            }
        }
    }
    
    func updateUserUnreadCount() {
        if unreadCount == "0" || unreadCount.isEmpty {
            lblNotificationCount.isHidden = true
        } else {
            lblNotificationCount.isHidden = false
            lblNotificationCount.text = unreadCount
        }
    }
    
    @IBAction func btnNotificationAction(_ sender : UIButton) {
        
        let vc = UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "filterViewController") as! FilterViewController
        vc.delegate = self
        if let filter = filterObj {
            vc.filter = filter
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnProfileAction(_ sender : UIButton) {
        
        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "profileOptionsVC") as! ProfileOptionsVC
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView.tag == 2 ? 1 : self.sectionsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 2 {
            return searchedList?.count ?? 0
        } else {
            switch section {
            case 0,1:
                return 1
            default:
                if let data = sectionsArray[DataType.business.rawValue]?.data {
                    return data.count
                }
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
            cell.lblSearch.text = searchedList?[indexPath.row]
            return cell
        } else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCell", for: indexPath) as! CategoryTableViewCell
                cell.delegate = self
                cell.setup(heading: "I am in the mood for…", arrayList:  sectionsArray[DataType.category.rawValue]?.data, isCategory: true)
                return cell
            } else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "featureTableViewCell", for: indexPath) as! FeatureTableViewCell
                cell.delegate = self
                cell.setup(heading: "Feature businesses", arrayList:  sectionsArray[DataType.feature.rawValue]?.data, isCategory: false)
                return cell
            } else  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "businessListCell", for: indexPath) as! BusinessListCell
                cell.delegate = self
                let data = sectionsArray[DataType.business.rawValue]?.data
                if data?.count ?? 0 > indexPath.row {
                    cell.setup(heading: "", data: data?[indexPath.row])
                }
                return cell
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 2 {
            return 30
        } else {
            if indexPath.section == 0 {
                return 135
            } else if indexPath.section == 1  {
                return 260
            }else {
                return 210
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView.tag == 2 {
            return nil
        } else {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerTableViewCell") as! HeaderTableViewCell
            
            switch section {
            case 0:
                if let _ = self.sectionsArray[DataType.category.rawValue]?.sectionName {
                    headerCell.setUp(dataObj: self.sectionsArray[DataType.category.rawValue])
                }
            case 2:
                if let _ = self.sectionsArray[DataType.business.rawValue]?.sectionName {
                    headerCell.setUp(dataObj: self.sectionsArray[DataType.business.rawValue])
                }
                headerCell.TNView.isHidden = true
            default:
                headerCell.TNView.isHidden = true
            }
            return headerCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.tag == 2 {
            return 0
        } else {
            switch section {
            case 1:
                return 0
            default:
                return 40
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 2 {
            self.searchBar.text = self.searchedList?[indexPath.row] ?? ""
            apicallForBusinessListFromSearch()
            DispatchQueue.main.async {
                self.hideSearchTable(true)
                self.view.endEditing(true)
            }
            
        } else {
            let vc = UIStoryboard(name: "Fav", bundle: nil).instantiateViewController(withIdentifier: "businessDetailsViewController") as! BusinessDetailsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func btnAllClick(_ sender: UIButton) {
        if sender.tag == 1 {
            appDelegate.tabbar?.selectedIndex = 1
        }
    }
    
    @objc func btnSubscriptionAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "planListVC") as! PlanListVC
        vc.isFromSignup = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: CardTapDelegate {
    func didCardTapped() {
        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "subscriptionViewController") as! SubscriptionViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didInactiveCardTapped() {
        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "planListVC") as! PlanListVC
        vc.isFromSignup = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: ButtonActionDelegate, BusinessDelegate {
    
    func didSelectAction(isCategory: Bool, isLocation: Bool, obj: CategoryDTo?) {
        
        if isCategory {
            let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "businessListViewController") as! BusinessListViewController
            if let obj = obj {
                vc.category = [obj]
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func buttonReedamAction(obj: CategoryDTo?) {
        //        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "eventDetailViewController") as! EventDetailViewController
        //        vc.dataObj = obj
        //        vc.isEvent = false
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getData() {
        getCategories()
        getBusinessList()
        getFeaturedBusiness()
        dispatchGroup.notify(queue: .main) {
            self.reloadTableView()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tblHome.reloadData()
        }
    }
    
    func getFeaturedBusiness() {
        dispatchGroup.enter()
        var params = [String: Any]()
        params["pagecount"] = 1
        params["limit"] = 100
//        params["user_id"] = AppHelper.getStringForKey(ServiceKeys.user_id)
//        if let locationLat = locationManager.location?.coordinate.latitude,  let locationLon = locationManager.location?.coordinate.longitude {
//            params["latitude"] = locationLat
//            params["longitude"] = locationLon
//        }
        
        ServiceClass.sharedInstance.hitServiceForGetFeaturedBusiness(params: params) { type, parseData, errorDict in
            self.dispatchGroup.leave()
            var dataFeaturedBusinessArr = [BusinessDTo]()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                for obj in parseData["data"].arrayValue {
                    dataFeaturedBusinessArr.append(BusinessDTo(fromJson: obj))
                }
                self.sectionsArray[DataType.feature.rawValue] = (HomeDTo(sectionName: nil, data: dataFeaturedBusinessArr,isTNShow: true))
                
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        }
    }
    
    func getCategories() {
        dispatchGroup.enter()
        ServiceClass.sharedInstance.hitServiceForGetCategories(params: [:]) { type, parseData, errorDict in
            self.dispatchGroup.leave()
            var dataCatArr = [CategoryDTo]()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                for obj in parseData["data"].arrayValue {
                    dataCatArr.append(CategoryDTo(fromJson: obj))
                }
                self.sectionsArray[DataType.category.rawValue] = HomeDTo(sectionName: "I am in the mood for…", data: dataCatArr)
                if self.filterObj == nil {
                    self.filterObj = Filter(categoryList: (self.sectionsArray[DataType.category.rawValue]?.data as? [CategoryDTo]) ?? [])
                }
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        }
    }
    
    
    func getSearchBusiness(_ text: String) {
        ServiceClass.sharedInstance.hitServiceForGetSearchBuList(params: ["search_key": text]) { type, parseData, errorDict in
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                self.searchedList = [String]()
                for obj in parseData["data"].arrayValue {
                    self.searchedList?.append(obj.stringValue)
                }
            
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
            self.hideSearchTable(self.searchedList?.count == 0)
            self.searchTableView.reloadData()
        }
    }
    
    func getBusinessList(isCalledAlone: Bool = true) {
        dispatchGroup.enter()
        
        var params = [String: Any]()
        params["pagecount"] = currentPage
        params["limit"] = 10
        params["search_key"] = searchBar.text
//        params["user_id"] = AppHelper.getStringForKey(ServiceKeys.user_id)
        if let locationLat = locationManager.location?.coordinate.latitude,  let locationLon = locationManager.location?.coordinate.longitude {
            params["latitude"] = locationLat
            params["longitude"] = locationLon
        }
        if let _ = filterObj {
            params["category_ids"] = filterObj?.categoryList?.filter({$0.isSelected ?? false}).map({$0.id}).joined(separator: ",")
            params["radius"] = filterObj?.radius
        }
        
        if currentPage == 1 {  self.sectionsArray[DataType.business.rawValue] = HomeDTo(sectionName: "Awesome places near me", data: []) }
        
        ServiceClass.sharedInstance.hitServiceForGetBusiness(params: params) { type, parseData, errorDict in
            self.dispatchGroup.leave()
            var dataRecommendedArr = [BusinessDTo]()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                for obj in parseData["data"].arrayValue {
                    dataRecommendedArr.append(BusinessDTo(fromJson: obj))
                }
                self.sectionsArray[DataType.business.rawValue]?.data?.append(contentsOf: dataRecommendedArr)

                self.isLoadMore = parseData["total_count"].intValue >= self.sectionsArray[DataType.business.rawValue]?.data?.count ?? 0

            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
            !isCalledAlone ? self.tblHome.reloadData() : nil
        }
    }
    
    func getSubscriptiondetail() {
        dispatchGroup.enter()
        ServiceClass.sharedInstance.hitServiceForsubscriptiondetail(params:  ["user_id": AppHelper.getStringForKey(ServiceKeys.user_id)]) { type, parseData, errorDict in
            self.dispatchGroup.leave()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                self.objPlan = PlanDTo(fromJson:parseData["data"]["user"])
                self.unreadCount = parseData["data"]["unread_count"].stringValue
                self.updateUserUnreadCount()
                AppHelper.setStringForKey(self.objPlan?.subscription_status, key: ServiceKeys.keySubscriptionStatus)
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        }
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        apicallForBusinessListFromSearch()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        worker?.cancel()
         if searchText.count >= 3{
             print("more than 3 ")
 
             let requestWorkItem = DispatchWorkItem {
                 self.getSearchBusiness(searchText)
             }
             worker = requestWorkItem
             DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300),
                                           execute: requestWorkItem)
         }
        self.hideSearchTable(searchText.count <= 2)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tblHome {
            if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && isLoadMore) {
                self.loadMoreItemsForList()
            }
        }
    }
    
    func loadMoreItemsForList(){
        if isLoadMore {
            isLoadMore = false
            currentPage += 1
            getBusinessList()
        }
    }
}

extension HomeViewController: BusinessCellDelegate, FilterDelegate {
    func getAllSelectedFilter(filter: Filter?) {
        self.filterObj = filter
        currentPage  = 1
        isLoadMore = true
        getData()
    }
    
    func didselectAction(data: LandingDataProtocol?) {
        
        if let data = data as? BusinessDTo {
            let vc = UIStoryboard(name: "Fav", bundle: nil).instantiateViewController(withIdentifier: "businessDetailsViewController") as! BusinessDetailsViewController
            vc.businessId = data.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension HomeViewController {
    
    
    fileprivate func apicallForBusinessListFromSearch() {
        appDelegate.exploreType = ExploreType.searchMode
        appDelegate.searchtxt = searchBar.text ?? ""
        self.currentPage = 1
        getBusinessList(isCalledAlone: false)
    }
    
    fileprivate func addSearchTable() {
        
        searchTableView.tag = 2
        searchTableView.clipsToBounds = true
        searchTableView.layer.cornerRadius = 10
        searchTableView.layer.maskedCorners =  [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        registerCell()
        hideSearchTable(true)
        
    }
    
    fileprivate func hideSearchTable(_ isHidden: Bool) {
        searchTableView.isHidden = isHidden
        searchBackView.isHidden = isHidden
    }
    
    fileprivate func registerCell() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")

    }
}
