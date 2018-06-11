//
//  PeriodSettingViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 28/05/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class PeriodSettingViewController: UIViewController {
    
    var delegate: PeriodSettingDelegate?
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var setButton: UIButton!
    
    var fromDate: Date?
    var toDate: Date?
    
    var isFromDate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if fromDate != nil{
            datePicker.setDate(fromDate!, animated: false)
        }else{
            fromDate = Date()
            datePicker.setDate(Date(), animated: false)
        }
        
        datePicker.maximumDate = Date()
        
        if toDate == nil {
            toDate = Date()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closePopup(){
        
        self.delegate?.canceledModal()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions
    
    @IBAction func newPeriod(){
        
        if fromDate != nil, toDate != nil, fromDate! < toDate! {
            
            self.delegate!.newPeriod(from: fromDate!, to: toDate!)
            closePopup()
        }
    }
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        closePopup()
    }
    
    @IBAction func datePicked(_ sender: UIDatePicker) {
        if isFromDate{
            fromDate = sender.date
        }else{
            toDate = sender.date
        }
        let calendar = Calendar.current

        let begin = calendar.startOfDay(for: fromDate!)
        let end = calendar.startOfDay(for: toDate!)
        let components = calendar.dateComponents([.day, .month, .year], from: end, to: begin)
        let day = components.day!
        let month = components.month!
        let year = components.year!

        if fromDate != nil, toDate != nil, year <= 0, month <= 0, day <= 0{
            
            if year < 0 {
                setButton.isEnabled = true

            }else if month < 0{
                setButton.isEnabled = true
            }else if day < 0{
                
                setButton.isEnabled = true
            }
            else if day == 0{
                
                fromDate = calendar.startOfDay(for: fromDate!)
                var components = DateComponents()
                components.day = 1
                components.second = -1
                toDate = Calendar.current.date(byAdding: components, to: fromDate!)
                setButton.isEnabled = true
            }
            else{
                setButton.isEnabled = false
            }
            
        }else{
            setButton.isEnabled = false
        }
    }
    
    @IBAction func segmentPicked(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            isFromDate = true
            datePicker.setDate(fromDate!, animated: true)
            
        }else{
            isFromDate = false
            datePicker.setDate(toDate!, animated: true)
            
        }
    }
    
    @IBAction func setButtonPressed(_ sender: UIButton) {
        self.delegate!.newPeriod(from: fromDate!, to: toDate!)
        dismiss(animated: true, completion: nil)
    }
}
