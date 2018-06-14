//
//  OverviewViewController + Collection.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 12/06/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

private let reuseIdentifier = "OverviewCollectionViewCell"

extension OverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        if self.recentRooms != nil{
            return self.recentRooms!.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! OverviewCollectionViewCell
        
        let recentRoom = self.recentRooms![indexPath.item]
        
        // Configure the cell
        cell.image.downloadedFrom(link: recentRoom.imageLink)
        
        cell.nameLabel.text = recentRoom.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recentRoom = self.recentRooms![indexPath.item]
        
        self.tabBarController?.selectedIndex = 2
        let splitviewController = self.tabBarController?.viewControllers![2] as! RoomSplitViewController
        
        let navViewController = splitviewController.viewControllers.first as! UINavigationController
        
        var roomsViewController: RoomsViewController?
        
        if let tempRoomsViewController = navViewController.topViewController as? RoomsViewController{
            roomsViewController = tempRoomsViewController
        }else{
            
            let secondNavController = navViewController.topViewController as! UINavigationController
            roomsViewController = secondNavController.topViewController as? RoomsViewController
            
        }
        
        roomsViewController!.roomIdToLoad = recentRoom.id
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var amountOfCellsHorizontal:CGFloat = 2
        
        if UIDevice.current.screenType == .unknown{
            amountOfCellsHorizontal = 4
            
        }
        
        return CGSize(width: (collectionView.bounds.width/amountOfCellsHorizontal) - 6 , height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
