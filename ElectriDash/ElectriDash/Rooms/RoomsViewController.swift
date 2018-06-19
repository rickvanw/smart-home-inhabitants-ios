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
    
    var roomIdToLoad: Int?
    
    var rooms = [Room]()
    let refresher = UIRefreshControl()
    var refresh = false
    
    override func viewDidLoad() {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        refresher.tintColor = .white
        refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refresher
        } else {
            collectionView.addSubview(refresher)
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("RoomsViewController did appear")
        
        var room:Room?
        var segue = false
        var animated = false
        
        if Helper.isConnectedToInternet() == true{
            
            if self.roomIdToLoad != nil, let newRoom = self.rooms.first(where: { $0.id == self.roomIdToLoad!}){
                segue = true
                room = newRoom
                self.roomIdToLoad = nil
            }
            
            if UIDevice.current.screenType == .unknown{
                animated = true
            }
            
            if segue {
                
                if room != nil{
                    let indexPath = IndexPath(item: self.rooms.index(of: room!)!, section: 0)
                    self.collectionView.selectItem(at: indexPath, animated: animated, scrollPosition: UICollectionViewScrollPosition.centeredVertically)
                    
                }else{
                    room = self.rooms.first
                    
                }
                self.performSegue(withIdentifier: "RoomsToRoomDetail", sender: room)
            }else{
                getData()
            }

        }else {
            Helper.showAlertOneButton(viewController: self, title: "No Internet Connection", message: "Make sure your device is connected to the internet.", buttonTitle: "Ok")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc func deviceRotated(){
        self.collectionView.reloadData()

    }
    
    @objc func refreshData(){
        refresh = true
        getData()
    }
    
    @objc func getData() {
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + Helper.getStoredTokenString()!,
                "Accept": "application/json"
            ]
        
        Alamofire.request("\(Constants.Urls.api)/house/\(Helper.getStoredHouseId()!)/rooms", headers: headers).responseJSON { response in
                        
            switch response.result {
            case .success:
                print("Rooms info retrieved")
                do {
                    let tempRooms = try JSONDecoder().decode([Room].self, from: response.data!)
                    
                    var room:Room?
                    var animated = false
                    var segue = false
                    
                    if tempRooms != self.rooms || self.refresh{
                        self.refresh = false

                        self.rooms = tempRooms
                        self.collectionView.reloadData()
                        
                        if self.roomIdToLoad != nil, let newRoom = self.rooms.first(where: { $0.id == self.roomIdToLoad!}){
                            segue = true
                            room = newRoom
                            self.roomIdToLoad = nil
                        }
                        
                        if UIDevice.current.screenType == .unknown{
                            animated = true
                        }
                        
                        if segue {
                            
                            if room != nil{
                                let indexPath = IndexPath(item: self.rooms.index(of: room!)!, section: 0)
                                self.collectionView.selectItem(at: indexPath, animated: animated, scrollPosition: UICollectionViewScrollPosition.centeredVertically)
                                self.performSegue(withIdentifier: "RoomsToRoomDetail", sender: room)

                            }
                            
                        }else if UIDevice.current.screenType == .unknown{
                            let room = self.rooms.first
                            self.performSegue(withIdentifier: "RoomsToRoomDetail", sender: room)
                        }

                    }
  
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

            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! RoomViewController

            if let room = sender as? Room{
                
                // Add room to recents
                Helper.addRecentRoom(room: room)
                
                targetController.roomId = room.id
                targetController.title = room.name
                targetController.segmentedControl.isEnabled = true

                targetController.initialize()
            }
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
        cell.roomKwh.text = "\(Helper.getCurrencyOrKWh(energyUsage: rooms[indexPath.row].energyUsage)) \(Helper.getCurrencyOrKWhName())"
        if rooms[indexPath.row].temperature != nil {
            cell.roomTemp.text = "\(rooms[indexPath.row].temperature!) ℃"
        }else{
            cell.roomTemp.text = "-- ℃"
        }
        
        if rooms[indexPath.row].getLastMotionDate() != nil {
        cell.roomLastMotion.text = Helper.getFormattedTimeStringBetweenDates(beginDate: rooms[indexPath.row].getLastMotionDate()!, endDate: Date())
        }else{
            cell.roomLastMotion.text = "--"
        }
        
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


