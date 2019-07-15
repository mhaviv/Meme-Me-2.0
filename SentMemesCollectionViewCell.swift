//
//  MemeCollectionViewCell.swift
//  Meme Me 2.0
//
//  Created by Michael Haviv on 7/8/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewCell: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
//        let villain = self.allVillains[(indexPath as NSIndexPath).row]
//        
//        // Set the name and image
//        cell.nameLabel.text = Meme.name
//        cell.imageView?.image = UIImage(named: Meme.imageName)
//        
//        return cell
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
//        
//        // Grab the DetailVC from Storyboard
//        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "VillainDetailViewController") as! VillainDetailViewController
//        
//        //Populate view controller with data from the selected item
//        detailController.villain = allVillains[(indexPath as NSIndexPath).row]
//        
//        // Present the view controller using navigation
//        navigationController!.pushViewController(detailController, animated: true)
//        
//    }

}
