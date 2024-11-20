//
//  IntroViewController.swift
//
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class IntroViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let imgArr = ["wel1","wel2","wel3"]
   // let imgBgArr = ["bg1","bg2","bg3","bg6","bg5","bg4"]
    let headingArr = ["Welcome to the Belilli","Be rewarded for supporting local","Proudly supporting \nWest Kent Mind"]
    
    let dataArr = ["Be part of something special and join our fast growing community supporting local in Tunbridge Wells, Tonbridge and Sevenoaks.","Show your virtual membership card at hundreds of independent businesses to enjoy rewards from free fizz to money off your shopping.","Our charity partner is West Kent Mind.  10% from your membership goes directly to the mental health charity to fund their work in our community."]
    
    var timer : Timer!
        
    override func viewDidLoad() {
        super.viewDidLoad()
       
        collectionView.dataSource = self
        collectionView.delegate   = self
        (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = 0
        (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
        self.hideNavigationController()
       
    }
    
    
    @objc func btnskipAction(_ sender: UIButton) {
        let storboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storboard.instantiateViewController(withIdentifier: "firstScreenViewController") as! FirstScreenViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func btnTapStartUsingTNcard(_ sender: UIButton) {
        if sender.tag == 2 {
        let storboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storboard.instantiateViewController(withIdentifier: "firstScreenViewController") as! FirstScreenViewController
        self.navigationController?.pushViewController(vc, animated: true)
        } else {
            scrollToNextCell()
        }
    }
    
    @objc func scrollToNextCell(){
        
        let cellSize = CGSize(width: self.collectionView.bounds.width, height: self.collectionView.bounds.height);
        let  contentOffset = collectionView.contentOffset
         Int(contentOffset.x) == (Int(cellSize.width) * (imgArr.count - 1)) ?
        collectionView.scrollRectToVisible(CGRect(x: 0, y: contentOffset.y, width:  cellSize.width, height: cellSize.height), animated: true) :  collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width:  cellSize.width, height: cellSize.height), animated: true)
        
    }
    
}
    extension IntroViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return imgArr.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCollectionViewCell", for: indexPath) as! PageCollectionViewCell
            cell.imgType.image =  UIImage(named : imgArr[indexPath.row])
            cell.lblHeading.text = headingArr[indexPath.row]
            cell.lblDetail.text = dataArr[indexPath.row]
            cell.pageControl.numberOfPages = self.imgArr.count
            cell.pageControl.currentPage = indexPath.item
            cell.btnNext.tag = indexPath.item
            cell.btnNext.addTarget(self, action: #selector(btnTapStartUsingTNcard(_:)), for: .touchUpInside)
            cell.btnSkip.addTarget(self, action: #selector(btnskipAction(_:)), for: .touchUpInside)
            cell.btnSkip.isHidden = indexPath.item == 2
            cell.btnNext.setTitle(indexPath.item == 2 ? "   Start using the BeLilli   " : "    NEXT    ", for: .normal)
            cell.imgType.contentMode = indexPath.item == 2 ? .scaleAspectFill : .scaleAspectFill
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: UIScreen.main.bounds.width, height: self.collectionView.bounds.height);
        }
    }




