//
//  CategoryTableViewCell.swift
//  BeLilli
//
//  Created by apple on 10/10/21.
//

import UIKit
import SDWebImage

protocol BusinessDelegate: AnyObject {
    func didSelectAction(isCategory: Bool, isLocation: Bool, obj: CategoryDTo?)
}

class CategoryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var collectionBottom: UICollectionView!
    var isCategory : Bool = false
    var isLocation: Bool = false
    var arrayList: [CategoryDTo]?
    weak var delegate : BusinessDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(heading: String, arrayList: [LandingDataProtocol]?, isCategory: Bool = false, isLocation: Bool = false) {
        collectionBottom.delegate = self
        collectionBottom.dataSource = self
        self.arrayList = arrayList as? [CategoryDTo]
        self.isCategory = isCategory
        self.isLocation = isLocation

        collectionBottom.reloadData()
        (self.collectionBottom.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = 10
        (self.collectionBottom.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
        collectionBottom.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 70)
    }
    
}
extension CategoryTableViewCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.arrayList?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        let objData = self.arrayList?[indexPath.item]
        cell.lblHead.text =  objData?.name.html2String
        DispatchQueue.main.async {
            if objData?.image ?? "" == "" {
                cell.imgItem.sd_setImage(with: URL(string: ServiceUrls.baseUrlImage + (objData?.banner ?? "")), placeholderImage: #imageLiteral(resourceName: "placeholder_icon"))
            } else {
                cell.imgItem.sd_setImage(with: URL(string: ServiceUrls.baseUrlImage + (objData?.image ?? "")), placeholderImage: #imageLiteral(resourceName: "placeholder_icon"))
            }
        }
        cell.imgWidthConstraint.constant = 90.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:  90, height: 150);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectAction(isCategory: isCategory, isLocation: isLocation,obj: self.arrayList?[indexPath.item] )
    }
}
