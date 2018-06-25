//
//  EnergyDeviceDetailViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 23/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit
import ScrollableGraphView
import Alamofire

class EnergyDeviceDetailViewController: UIViewController, EnergyPageControllerToPage, ScrollableGraphViewDataSource, PeriodSettingDelegate{

    @IBOutlet var totalEnergy: UILabel!
    @IBOutlet var graphViewContainer: UIView!
    @IBOutlet var xAxisLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var noticeLabel: UILabel!
    
    var graphView: ScrollableGraphView!
    var fromDate: Date!
    var toDate: Date!
    
    var deviceId: Int?
    
    var yAxis = [Double]()
    var xAxis = [Date]()
    
    var devices = [Device]()
    
    func reloadPage() {
        graphView.reload()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        xAxisLabel.text = "Vandaag"
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        fromDate = today
        
        var components = DateComponents()
        components.day = 1
        components.second = -1
        toDate = Calendar.current.date(byAdding: components, to: fromDate!)
        
        getGraphData(from: fromDate, to: toDate)
    }
    
    func initGraph(){
        
        graphView = createMultiPlotGraphOne(graphViewContainer.frame)
        
        self.graphViewContainer.addSubview(graphView)
        
        graphView.rightmostPointPadding = 25
        graphView.leftmostPointPadding = 30
        
        graphView.dataPointSpacing = ((graphView.frame.width - (graphView.leftmostPointPadding + graphView.rightmostPointPadding)) / CGFloat(xAxis.count - 1))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        switch(plot.identifier) {
        case "line":
            return yAxis[pointIndex]
        case "dot":
            return yAxis[pointIndex]
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        
        return "\(getDateFormatted(date: xAxis[pointIndex]))"
    }
    
    func numberOfPoints() -> Int {
        return xAxis.count
    }
    
    fileprivate func createMultiPlotGraphOne(_ frame: CGRect) -> ScrollableGraphView {
        
        // Setup the first plot.
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)
        
        let linePlot = LinePlot(identifier: "line") // Identifier should be unique for each plot.
        
        linePlot.lineStyle = .smooth
        linePlot.lineColor = Constants.AppColors.loginGreen
        linePlot.fillType = .gradient
        linePlot.fillGradientStartColor = Constants.AppColors.loginGreen.withAlphaComponent(1)
        linePlot.fillGradientEndColor = Constants.AppColors.loginGreen.withAlphaComponent(0.2)
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        linePlot.lineCap = kCALineCapSquare
        
        // Setup the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.darkGray.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.darkGray
        referenceLines.relativePositions = [0, 0.2, 0.4, 0.6, 0.8, 1]
        
        referenceLines.dataPointLabelColor = UIColor.darkGray.withAlphaComponent(1)
        
        var sparsity = 1
        
        if xAxis.count > 6 {
            sparsity = xAxis.count / 6
        }
        
        referenceLines.dataPointLabelsSparsity = sparsity
        graphView.rangeMax = yAxis.max()!.rounded(.up)
        graphView.rangeMin = yAxis.min()!.rounded(.down)
        
        if graphView.rangeMin == graphView.rangeMax {
            graphView.rangeMin -= 1
            graphView.rangeMax += 1
        }
        
        graphView.shouldRangeAlwaysStartAtZero = true
        graphView.shouldAnimateOnStartup = false
        graphView.shouldAdaptRange = false
        graphView.shouldAnimateOnAdapt = false
        
        graphView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Add everything to the graph.
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: linePlot)
        
        return graphView
    }
    
    func periodSettingScreen(){
        Helper.removeBlur()
        
        Helper.addBlur()
        
        let periodSettingViewController = self.storyboard?.instantiateViewController(withIdentifier: "PeriodSettingViewController") as! PeriodSettingViewController
        
        periodSettingViewController.delegate = self
        
        periodSettingViewController.fromDate = fromDate
        periodSettingViewController.toDate = toDate
        
        self.present(periodSettingViewController, animated: true, completion: nil)
    }
    
    func newPeriod(from: Date, to: Date) {
        
        self.fromDate = from
        self.toDate = to
        
        if graphView != nil{
            graphView.removeFromSuperview()
        }
        getGraphData(from: fromDate, to: toDate)
    }
    
    func canceledModal() {
        
        Helper.removeBlur()
    }
    
    func getGraphData(from: Date, to: Date){
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Helper.getStoredTokenString()!,
            "Accept": "application/json"
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let fromDateString = dateFormatter.string(from: from)
        let toDateString = dateFormatter.string(from: to)
        
        self.noticeLabel.isHidden = true
        self.hideGraph()
                
        Alamofire.request("\(Constants.Urls.api)/house/\(Helper.getStoredHouseId()!)/device/\(deviceId!)/history/\(fromDateString)/\(toDateString)", headers: headers).responseJSON { response in

            print(response.debugDescription)
            
            self.showGraph()
            
            switch response.result {
            case .success:
                print("Device history retrieved")
                do {
                    
                    let graph = try JSONDecoder().decode(Graph.self, from: response.data!)
                    
                    let graphEntries = graph.graphEntries
                    
                    self.yAxis = [Double]()
                    self.xAxis = [Date]()
                    
                    for graphEntry in graphEntries{
                        self.yAxis.append(graphEntry.yAxis)
                        self.xAxis.append(graphEntry.getxAxisDate()!)
                    }
                    
                    print(self.yAxis)
                    print(self.xAxis)
                    
                    if !self.yAxis.isEmpty, !self.xAxis.isEmpty, (self.yAxis.count > 1), (self.yAxis.count > 1){
                        
                        self.initGraph()
                        self.totalEnergy.text = "\(self.yAxis.max()!.rounded(.up)) Watt max"
                        
                    }else{
                        self.noticeLabel.isHidden = false
                    }
                    
                }catch {
                    print("Parse error")
                    self.noticeLabel.isHidden = false
                }
                
            case .failure(let error):
                print(error)
                self.noticeLabel.isHidden = false
            }
        }
    }
    
    func getDateFormatted(date: Date) -> String{
        
        let calendar = Calendar.current
        
        let begin = calendar.startOfDay(for: fromDate!)
        let end = calendar.startOfDay(for: toDate!)
        let components = calendar.dateComponents([.day, .month, .year], from: begin, to: end)
        let day = components.day!
        let month = components.month!
        let year = components.year!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        xAxisLabel.text = "Maanden"
        
        if year > 0 {
            // More then year apart
            
            dateFormatter.dateFormat = "MM/yyyy"
            xAxisLabel.text = "Maanden"
            
        }else if month > 0{
            // More then month apart
            
            dateFormatter.dateFormat = "dd/MM"
            xAxisLabel.text = "Dagen"
            
        }else if day == 0{
            // Same day
            
            dateFormatter.dateFormat = "HH:mm"
            xAxisLabel.text = "Uren"
            
            if calendar.isDateInToday(fromDate), calendar.isDateInToday(toDate){
                // Today
                
                xAxisLabel.text = "Vandaag"
            }
            
        }else if month == 0 {
            // Same month
            
            xAxisLabel.text = "Dagen"
            
            dateFormatter.dateFormat = "dd/MM"
        }
        
        return dateFormatter.string(from:date)
    }
    
    func hideGraph(){
        graphViewContainer.alpha = 0
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
    }
    
    func showGraph(){
        graphViewContainer.alpha = 1
        activityIndicator.alpha = 0
        activityIndicator.stopAnimating()
    }
    
    // MARK: Actions
    @IBAction func periodButtonPressed(_ sender: Any) {
        periodSettingScreen()
    }
    
}

