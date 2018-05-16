//
//  ViewController.swift
//  ElectriDash
//
//  Created by Ruben Assink on 26/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//


import UIKit
import Alamofire

class RoomsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    var rooms = [Room]()
    let refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        refresher.tintColor = .white
        refresher.addTarget(self, action: #selector(getData), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refresher
        } else {
            collectionView.addSubview(refresher)
        }
        getData()
        
    }
    
    
    @objc func getData() {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Helper.getStoredTokenString()!,
            "Accept": "application/json"
        ]
        
        Alamofire.request("\(Constants.Urls.api)/1/rooms", headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Rooms info retrieved")
                do {
                    self.rooms = try JSONDecoder().decode([Room].self, from: response.data!)
                    self.collectionView.reloadData()
                }catch {
                    print("Parse error")
                }
            case .failure(let error):
                print(error)
            }
        }
        self.refresher.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "RoomsToRoomDetail" {
//            let destVC = segue.destination as! RoomViewController
//            destVC.room = sender as? Room
            
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! RoomViewController
            
            let room = sender as? Room
            targetController.room = room
            targetController.title = room?.name
            targetController.initialize()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rooms.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RoomsCollectionViewCell
        
        // Set cell content
        cell.locationImage.downloadedFrom(link: self.rooms[indexPath.row].imageLink)
        cell.roomName.text = rooms[indexPath.row].name
        cell.roomKwh.text = "\(Helper.getCurrencyOrKWh(room: rooms[indexPath.row])) \(Helper.getCurrencyOrKWhName())"
        cell.roomTemp.text = String(rooms[indexPath.row].temperature) + " ℃"
        cell.roomLastMotion.text = Helper.getFormattedTimeStringBetweenDates(beginDate: rooms[indexPath.row].getLastMotionDate(), endDate: Date())
        
        // Apply cell properties
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        return CGSize(width: (width - 20), height: (200)) // width & height are the same to make a square cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
        let room = rooms[indexPath.row]
        performSegue(withIdentifier: "RoomsToRoomDetail", sender: room)
    }
    
    
    
    
}


