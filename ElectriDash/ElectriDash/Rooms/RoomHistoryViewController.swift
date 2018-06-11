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

class RoomHistoryViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, RoomPageControllerToPage, ScrollableGraphViewDataSource, PeriodSettingDelegate{
    
    @IBOutlet var totalEnergy: UILabel!
    @IBOutlet var graphViewContainer: UIView!
    @IBOutlet var xAxisLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var historyDeviceTableview: UITableView!
    
    var graphView: ScrollableGraphView!
    var fromDate: Date!
    var toDate: Date!
    
    var roomId: Int?
    
    var yAxis = [Double]()
    var xAxis = [Date]()
    
    var devices = [Device]()
    
    func reloadPage() {
        graphView.reload()
        getData()
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
        
        getData(from: fromDate, to: toDate)
        
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
        
        self.hideGraph()
        
        Alamofire.request("\(Constants.Urls.api)/house/\(Helper.getStoredHouseId())/room/\(roomId!)/history/\(fromDateString)/\(toDateString)", headers: headers).responseJSON { response in
            
            self.showGraph()
            
            switch response.result {
            case .success:
                print("Rooms history retrieved")
                do {
                    
                    let roomHistory = try JSONDecoder().decode(RoomHistory.self, from: response.data!)
                    
                    let graphEntries = roomHistory.graph.graphEntries
                    
                    self.yAxis = [Double]()
                    self.xAxis = [Date]()
                    
                    for graphEntry in graphEntries{
                        self.yAxis.append(graphEntry.yAxis)
                        self.xAxis.append(graphEntry.getxAxisDate()!)
                    }
                    if !self.yAxis.isEmpty, !self.xAxis.isEmpty{
                        
                        self.initGraph()
                        self.totalEnergy.text = "\(self.yAxis.max()!.rounded(.up)) Watt max"

                    }
                    
                    
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
    
    //Tableview
    
    func getData() {
        
        if Helper.isConnectedToInternet() {
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + Helper.getStoredTokenString()!,
                "Accept": "application/json"
            ]
            
            Alamofire.request("\(Constants.Urls.api)/house/\(Helper.getStoredHouseId())/room/\(roomId!)/devices", headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    print("Device info retrieved")
                    do {
                        self.devices = try JSONDecoder().decode([Device].self, from: response.data!)
                        self.devices.sort(by: { $0.categoryName > $1.categoryName })
                        self.historyDeviceTableview.reloadData()
                    }catch {
                        print("Parse error")
                        
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        else {
            Helper.showAlertOneButton(viewController: self, title: "Geen netwerkverbinding", message: "Controleer of uw apparaat verbonden is met het internet", buttonTitle: "OK")
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return devices.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyDeviceCell", for: indexPath) as! DevicesTableViewCell
        
        // Get the device
        let device: Device
        device = devices[indexPath.row]
        
        // Set the values
        cell.deviceName.text = device.name
        
        if device.energyUsage.usage != nil {
            cell.deviceUsage.text = String(device.energyUsage.usage!) + " W"
        }
        
        // Set the image according to the given iconName
        switch device.categoryName {
        case Constants.deviceCategories.multiSensor:
            cell.deviceImage.image = UIImage(named: "multisensor")?.withRenderingMode(.alwaysTemplate)
            break
        case Constants.deviceCategories.light:
            cell.deviceImage.image = UIImage(named: "lightbulb")?.withRenderingMode(.alwaysTemplate)
            break
        case Constants.deviceCategories.socket:
            cell.deviceImage.image = UIImage(named: "powerplug")?.withRenderingMode(.alwaysTemplate)
            break
        case Constants.deviceCategories.doorSensor:
            cell.deviceImage.image = UIImage(named: "movement")?.withRenderingMode(.alwaysTemplate)
            break
        default: break
        }
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        //Set the icon tintcolor
        cell.deviceImage.tintColor = UIColor(hexString: "#5ED0A8")
        
        return cell
    }
}
