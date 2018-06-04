//
//  RoomHistoryViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 25/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit
import ScrollableGraphView
import Alamofire

class RoomHistoryViewController: UIViewController, RoomPageControllerToPage, ScrollableGraphViewDataSource, PeriodSettingDelegate{
    
    @IBOutlet var totalEnergy: UILabel!
    @IBOutlet var graphViewContainer: UIView!
    
    var graphView: ScrollableGraphView!
    var fromDate: Date!
    var toDate: Date!
    
    var room: Room?
    
    var roomId: Int?
    
    var yAxis: [Double] = [2.9, 1.5, 2.3, 5.5, 1.0, 2.9, 2.9, 1.5, 2.3, 3.0, 1.0, 2.9, 2.9, 1.5, 2.3, 5.5, 1.0, 2.9, 2.9, 1.5, 2.3, 3.0, 1.0, 2.9, 2.9]
    var linePlotLabel = [String]()
    
    var xAxis = [Date]()
    
    var numberOfDataItems = 25
    
    func reloadPage() {
        graphView.reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        fromDate = calendar.date(byAdding: .day, value: -4, to: today)
        toDate = calendar.date(byAdding: .day, value: -2, to: today)
        
        getData(from: fromDate, to: toDate)
        
        //        initGraph()
        
    }
    
    func initGraph(){
        for x in xAxis {
            
            linePlotLabel.append(getDateFormatted(date: x))
        }
        
        graphView = createMultiPlotGraphOne(graphViewContainer.frame)
        
        self.graphViewContainer.addSubview(graphView)
        
        graphView.dataPointSpacing = (self.view.frame.width - (graphView.leftmostPointPadding + graphView.rightmostPointPadding)) / CGFloat(numberOfDataItems)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
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
        
        return "\(linePlotLabel[pointIndex])"
    }
    
    func numberOfPoints() -> Int {
        return numberOfDataItems
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
        
        
        // dots on the line
        //        let dotPlot = DotPlot(identifier: "dot") // Add dots as well.
        //        dotPlot.dataPointSize = 4
        //        dotPlot.dataPointFillColor = Constants.AppColors.loginGreen
        //        dotPlot.dataPointType = .circle
        //        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.easeOut
        //        dotPlot.animationDuration = 0.1
        
        // Setup the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.darkGray.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.darkGray
        referenceLines.relativePositions = [0, 0.2, 0.4, 0.6, 0.8, 1]
        
        referenceLines.dataPointLabelColor = UIColor.darkGray.withAlphaComponent(1)
        
        referenceLines.dataPointLabelsSparsity = 3
        
        graphView.rangeMax = yAxis.max()!.rounded(.up)
        graphView.rangeMin = yAxis.min()!.rounded(.down)
        
        graphView.shouldRangeAlwaysStartAtZero = true
        graphView.shouldAnimateOnStartup = false
        graphView.shouldAdaptRange = false
        graphView.shouldAnimateOnAdapt = false
        graphView.leftmostPointPadding = 20
        graphView.rightmostPointPadding = 5
        
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
        
        print("fromDate: \(fromDate) - toDate: \(toDate)")
        
        graphView.removeFromSuperview()
        getData(from: fromDate, to: toDate)
    }
    
    func canceledModal() {
        
        Helper.removeBlur()
    }
    
    func getData(from: Date, to: Date){
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Helper.getStoredTokenString()!,
            "Accept": "application/json"
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let fromDateString = dateFormatter.string(from: from)
        let toDateString = dateFormatter.string(from: to)
        
        Alamofire.request("\(Constants.Urls.api)/house/1/room/\(roomId!)/history/\(fromDateString)/\(toDateString)", headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Rooms history retrieved")
                do {
                    //                    print(response)
                    
                    let graph = try JSONDecoder().decode(Graph.self, from: response.data!)
                    self.generateDateRange()
                    self.initGraph()
                }catch {
                    print("Parse error")
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getDateFormatted(date: Date) -> String{
        
        let calendar = Calendar.current
        
        let begin = calendar.startOfDay(for: fromDate!)
        let end = calendar.startOfDay(for: toDate!)
        let components = calendar.dateComponents([.day, .month, .year], from: end, to: begin)
        let day = components.day!
        let month = components.month!
        let year = components.year!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        
        //        if fromDate != nil, toDate != nil, year <= 0, month <= 0, day <= 0{
        
        if year < 0 {
            dateFormatter.dateFormat = "MM/yyyy"
            
        }else if month < 0{
            dateFormatter.dateFormat = "dd/MM"
            
        }else if day == 0{
            dateFormatter.dateFormat = "HH:mm"
            
        }
        //        }
        
        return dateFormatter.string(from:date)
    }
    
    func generateDateRange(){
        let calendar = Calendar.current
        
        var date = calendar.startOfDay(for: fromDate)
        
        for _ in yAxis{
            
            date = calendar.date(byAdding: .hour, value: 1, to: date)!
            
            xAxis.append(date)
        }
        
    }
    
    //MARK: Actions
    @IBAction func periodButtonPressed(_ sender: Any) {
        periodSettingScreen()
    }
}
