//
//  OverviewViewController + CollectionCollectionViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 12/06/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

private let reuseIdentifier = "OverviewCollectionViewCell"

extension OverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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
        let roomsViewController = navViewController.topViewController as! RoomsViewController

        
        roomsViewController.roomIdToLoad = recentRoom.id
        
//        performSegue(withIdentifier: "OverviewToRoomDetail", sender: recentRoom)
//        self.view.window.rootViewController = splitViewController;
//        self.present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "RoomSplitViewController")
//        self.present(controller, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.width/2) - 6 , height: 100)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == "OverviewToRoomDetail" {

//            let destinationNavigationController = segue.destination as! RoomSplitViewController
//            let targetController = destinationNavigationController.topViewController as! RoomViewController
            
//            let room = sender as? Room
//            targetController.roomId = room?.id
//            targetController.title = room?.name
//            targetController.initialize()
//        }
    }


}
