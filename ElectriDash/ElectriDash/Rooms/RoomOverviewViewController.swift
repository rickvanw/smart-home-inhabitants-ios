//
//  RoomOverviewViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 25/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class RoomOverviewViewController: UIViewController, RoomPageControllerToPage {
    
    var height: CGFloat?
    var room: Room?

    @IBOutlet var roomImageView: UIImageView!
    @IBOutlet var roomNameLabel: UILabel!
    @IBOutlet var roomTotalEnergyLabel: UILabel!
    @IBOutlet var roomTemperatureLabel: UILabel!
    @IBOutlet var roomLastMovementLabel: UILabel!
    
    @IBOutlet var movementImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        height = self.view.frame.height

        print("\(height)")
        
        self.initialize()

        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialize(){
        movementImageView.image = UIImage(named: "movement")?.withRenderingMode(.alwaysTemplate)
        
        if room != nil{
            
            // TODO: set uiimage name
            roomImageView.image = UIImage(named: "woonkamer")
            roomNameLabel.text = room!.name
            roomTotalEnergyLabel.text = "\(room!.energyUsage) kWh"
            roomTemperatureLabel.text = "\(room!.temperature) °C"
            
            let date = room!.lastMotion
            
            let currentDate = Date()
            let calendar = Calendar.current
//            let day = calendar.component(.day, from: currentDate)
//            let hour = calendar.component(.hour, from: currentDate)
//            let minutes = calendar.component(.minute, from: currentDate)
            
//            var showDate = "\(minutes) minuten geleden"
            
            let day = calendar.dateComponents([.day], from: date, to: currentDate).day!
            let hour = calendar.dateComponents([.hour], from: date, to: currentDate).hour!
            let minute = calendar.dateComponents([.minute], from: date, to: currentDate).minute!
            
            var showDate = ""
            
            if day > 0 {
                showDate = "\(day) dagen geleden"
                
                if day == 1 {
                    showDate = "\(day) dag geleden"
                }
            }else if hour > 0 {
                showDate = "\(hour) uur geleden"
                
                if hour == 1 {
                    
                    showDate = "\(hour) uur geleden"
                }
            }else{
                showDate = "\(minute) minuten geleden"
                
                if minute == 1 {
                    showDate = "\(minute) minuut geleden"
                }
            }
            
            // TODO: set time from
            roomLastMovementLabel.text = "\(showDate)"
            
        }
    }
    
    func setRoom(room: Room) {
        self.room = room
        self.initialize()
    }
    
}
