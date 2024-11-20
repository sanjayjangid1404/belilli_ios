//
//  HomeBannerTableViewCell.swift
//  BeLilli
//
//  Created by apple on 09/10/21.
//

import UIKit
protocol ButtonActionDelegate: AnyObject {
    func buttonReedamAction(obj: CategoryDTo?)
}

class HomeBannerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionTop: UICollectionView!
    
    weak var delegate: ButtonActionDelegate?
    
    var dataFeaturedBusinessArr: [CategoryDTo]?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func setup(listArray: [CategoryDTo]?) {
        self.dataFeaturedBusinessArr = listArray
        collectionTop.delegate = self
        collectionTop.dataSource = self
        (self.collectionTop.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = 0
        (self.collectionTop.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
        self.collectionTop.reloadData()
    }


}

extension HomeBannerTableViewCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataFeaturedBusinessArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
        cell.pageControl.numberOfPages = dataFeaturedBusinessArr?.count ?? 0
        cell.pageControl.currentPage = indexPath.item
        cell.imageHeight.constant = self.collectionTop.bounds.height - 65
        let objData = self.dataFeaturedBusinessArr?[indexPath.item]
        cell.lblHeader.text =  objData?.name.html2String
        cell.lblDescriptionText.text = objData?.offer.html2String
        DispatchQueue.main.async {
            if objData?.image ?? "" == "" {
                cell.imgBackground.sd_setImage(with: URL(string: ServiceUrls.baseUrl + (objData?.banner ?? "")), placeholderImage: #imageLiteral(resourceName: "placeholder_icon"))
            } else {
                cell.imgBackground.sd_setImage(with: URL(string: ServiceUrls.baseUrl + (objData?.image ?? "")), placeholderImage: #imageLiteral(resourceName: "placeholder_icon"))
            }
        }
        cell.imgWidthConstraint.constant = UIScreen.main.bounds.width * 0.7
        cell.shadowView.applyGradient(colours: [UIColor.clear, UIColor.black.withAlphaComponent(0.8), UIColor.black, UIColor.black], locations: [0, 0.25, 1])
        cell.btnRedeem.tag = indexPath.item
        cell.imgWidthConstraint.constant = UIScreen.main.bounds.width
        cell.btnRedeem.addTarget(self, action: #selector(btnRedeemAction), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: self.collectionTop.bounds.height);
    }
    
    @objc func btnRedeemAction(_ button : UIButton) {
        let objData = self.dataFeaturedBusinessArr?[button.tag]
        delegate?.buttonReedamAction(obj: objData)
    }
}



