//
//  OverviewViewController.swift
//  ElectriDash
//
//  Created by Ruben Assink on 11/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OverviewViewController: UIViewController {
    
    @IBOutlet var overviewCollectionView: UICollectionView!
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var recentsLabel: UILabel!
    
    var recentRooms: [RecentRoom]?
    
    override func viewDidLoad() {
        super.viewDidLoad()        

        if let token = Helper.getToken() {
            welcomeLabel.text = "Welkom terug, \(token.name)"
            welcomeLabel.adjustsFontSizeToFitWidth = true
            welcomeLabel.minimumScaleFactor = 0.2
        }
        
        
        overviewCollectionView.delegate = self
        overviewCollectionView.dataSource = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("APPEARED")
        
        if let recentRooms = Helper.getRecentRooms(){
            
            if self.recentRooms != recentRooms.recentRooms.reversed(){
                
                print(recentRooms)
                
                self.recentRooms = recentRooms.recentRooms.reversed()
                overviewCollectionView.reloadData()
            }
            
            recentsLabel.text = "Onlangs bekeken ruimtes:"
        }else{
            recentsLabel.text = "Nog geen onlangs bekeken ruimtes"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
