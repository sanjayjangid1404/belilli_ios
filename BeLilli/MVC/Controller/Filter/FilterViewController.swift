//
//  FilterViewController.swift
//  BeLilli
//
//  Created by apple on 03/02/23.
//

import UIKit
import TagListView

protocol FilterDelegate: AnyObject {
    func getAllSelectedFilter(filter: Filter?)
}

class FilterViewController: BaseViewController, TagListViewDelegate {
    
    @IBOutlet weak var slider: CustomSlider!
    @IBOutlet weak var tagListView: TagListView!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    
    weak var delegate: FilterDelegate?

    var categoryList = [CategoryDTo]()
    var filter: Filter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlaceHolderColor(text_field:locationTextField , placeholder: "Location")
        locationTextField.delegate = self
        self.navTitle.text = "My Belilli"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tagListView.delegate = self
        slider.maximumValue = 5
        let categories = filter?.categoryList?.map({$0.name ?? ""}) ?? []
        tagListView.addTags(categories)
        setSelectedFilter()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setSelectedFilter() {
        if let selectedList = filter?.categoryList?.filter({$0.isSelected ?? true}).map({$0.name ?? ""}) {
            tagListView.tagViews.forEach { tag in
               
                if selectedList.contains(tag.titleLabel?.text ?? "") {
                    tag.isSelected = true
                }
                
            }
        }
        
        slider.value = Float(Float(filter?.radius ?? 0))
        
    }
    
    @IBAction func clearFilterClicked(_ sender: UIButton) {
        tagListView.selectedTags().forEach({ tag in
            tag.isSelected = false
        })
        filter = nil
        slider.value = 0.0
    }
    
    @IBAction func saveFilterClicked(_ sender: UIButton) {
        tagListView.selectedTags().forEach({ tag in
            print(tag.titleLabel?.text ?? "")
        })
                
        delegate?.getAllSelectedFilter(filter: filter)
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func changeCostSlider(_ sender: UISlider) {

        sender.setValue(Float(lroundf(slider.value)), animated: false)
        
        self.filter?.radius = Int(sender.value)
        print_debug("\(Int(sender.value))")
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
        
        if  let index = self.filter?.categoryList?.firstIndex(where: { $0.name == title }) {
            self.filter?.categoryList?[index].isSelected = !(self.filter?.categoryList?[index].isSelected ?? false)
        }
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }

}



extension FilterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}


//extension FilterViewController {
//
//    func getSubscriptiondetail() {
//        ServiceClass.sharedInstance.hitServiceForsubscriptiondetail(params:  ["user_id": AppHelper.getStringForKey(ServiceKeys.user_id)]) { type, parseData, errorDict in
//            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
//                self.objPlan = PlanDTo(fromJson:parseData["data"]["user"])
//                self.unreadCount = parseData["data"]["unread_count"].stringValue
//                self.updateUserUnreadCount()
//                AppHelper.setStringForKey(self.objPlan?.subscription_status, key: ServiceKeys.keySubscriptionStatus)
//            } else {
//                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
//            }
//        }
//    }
//}
