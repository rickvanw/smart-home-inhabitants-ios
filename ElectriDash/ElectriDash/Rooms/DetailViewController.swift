//
//  DetailViewController.swift
//  ElectriDash
//
//  Created by Ruben Assink on 01/05/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var room: Room?

    @IBOutlet weak var roomDetailImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = room?.name
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
