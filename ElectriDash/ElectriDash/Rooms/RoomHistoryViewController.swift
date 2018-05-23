//
//  RoomHistoryViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 25/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit
import ScrollableGraphView

class RoomHistoryViewController: UIViewController, RoomPageControllerToPage, ScrollableGraphViewDataSource {

    @IBOutlet var totalEnergy: UILabel!
    @IBOutlet var graphViewContainer: UIView!
    
    
    var room: Room?
    
    var roomId: Int?
    
    var linePlotData: [Double] = [0.0, 1.5, 2.3, 5.5, 1.0, 2.9, 0.0, 1.5, 2.3, 5.5, 1.0, 2.9]
    var numberOfDataItems = 12
    
    func reloadPage() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Compose the graph view by creating a graph, then adding any plots
        // and reference lines before adding the graph to the view hierarchy.
        let graphView = ScrollableGraphView(frame: graphViewContainer.frame, dataSource: self)
        
        let linePlot = LinePlot(identifier: "line") // Identifier should be unique for each plot.
        let referenceLines = ReferenceLines()
        
        linePlot.adaptAnimationType = .easeOut
        linePlot.lineStyle = .smooth
        linePlot.lineColor = Constants.AppColors.loginGreen
        linePlot.shouldFill = true
        linePlot.fillType = .solid
        linePlot.fillColor = Constants.AppColors.loginGreen.withAlphaComponent(0.5)
        linePlot.lineCap = kCALineCapRound
        
        graphView.addPlot(plot: linePlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
        
        graphView.shouldAdaptRange = true
        graphView.shouldAnimateOnAdapt = true
        graphView.shouldAnimateOnStartup = true
        
        
        self.graphViewContainer.addSubview(graphView)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        switch(plot.identifier) {
        case "line":
            return linePlotData[pointIndex]
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "\(pointIndex)"
    }
    
    func numberOfPoints() -> Int {
        return numberOfDataItems
    }
}
