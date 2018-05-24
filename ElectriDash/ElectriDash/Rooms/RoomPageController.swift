//
//  RoomPageController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 25/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit
import Alamofire

class RoomPageController: UIPageViewController, UIPageViewControllerDelegate, SegmentPageChange{
    
    var currentPageIndex = 0
    var height: CGFloat?

    
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "RoomOverviewViewController"),
            self.getViewController(withIdentifier: "RoomDevicesViewController"),
            self.getViewController(withIdentifier: "RoomHistoryViewController")
        ]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    override func loadView() {
        super.loadView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self

        if let firstViewController = pages.first {
            setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        var room = (self.parent as! RoomViewController).room
        
        if room == nil {
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + Helper.getStoredTokenString()!,
                "Accept": "application/json"
            ]
            
            Alamofire.request("\(Constants.Urls.api)/1/rooms", headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    print("Rooms info retrieved")
                    do {
                        room = try JSONDecoder().decode([Room].self, from: response.data!).first
                        guard let currentPage = self.viewControllers?.first else { return }
                        (currentPage as! RoomPageControllerToPage).setRoom(room: room!)
                    }catch {
                        print("Parse error")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }else{
            guard let currentPage = self.viewControllers?.first else { return }
            (currentPage as! RoomPageControllerToPage).setRoom(room: room!)
        }
    }
    
    func reloadCurrent(){
        let page = pages[currentPageIndex] as! RoomPageControllerToPage
        page.reloadPage()
    }
    
    
    // MARK: SegmentPageChange
    
    func pageChangedToIndex(index: Int) {
        
        var viewController = UIViewController()
        
        switch (index) {
        case 0:
            print("first")
            viewController = pages[0]
            
            break;
        case 1:
            print("second")
            viewController = pages[1]
            
            break;
        case 2:
            print("third")
            viewController = pages[2]
            
            break;
        default:
            break;
        }
        
        var direction:UIPageViewControllerNavigationDirection = .reverse
        
        if index > self.currentPageIndex{
            direction = .forward
        }
        
        self.currentPageIndex = index

        let room = (self.parent as! RoomViewController).room
        
        guard let currentPage = self.viewControllers?.first else { return }
        (currentPage as! RoomPageControllerToPage).setRoom(room: room!)
        
        setViewControllers([viewController], direction: direction, animated: false, completion: nil)
        
        
    }
}
