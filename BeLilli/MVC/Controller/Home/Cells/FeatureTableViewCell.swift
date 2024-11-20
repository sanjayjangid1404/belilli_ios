//
//  FeatureTableViewCell.swift
//  BeLilli
//
//  Created by apple on 04/02/23.
//

import UIKit

class FeatureTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionBottom: UICollectionView!
    @IBOutlet weak var headingLabel: UILabel!
    var isCategory : Bool = false
    var isLocation: Bool = false
    var arrayList: [BusinessDTo]?
    weak var delegate : BusinessCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(heading: String, arrayList: [LandingDataProtocol]?, isCategory: Bool = false, isLocation: Bool = false) {
        collectionBottom.delegate = self
        collectionBottom.dataSource = self
        self.arrayList = arrayList as? [BusinessDTo]
        self.isCategory = isCategory
        self.isLocation = isLocation

        collectionBottom.reloadData()
        (self.collectionBottom.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = 0
        (self.collectionBottom.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
        collectionBottom.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
    }
    
}
extension FeatureTableViewCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.arrayList?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featureCollectionViewCell", for: indexPath) as! FeatureCollectionViewCell
        cell.imgWidthConstraint.constant = UIScreen.main.bounds.width - 108
        cell.setup(heading: "", data: arrayList?[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:  UIScreen.main.bounds.width - 108, height: 180);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didselectAction(data: self.arrayList?[indexPath.item] as? BusinessDTo)
    }
}
