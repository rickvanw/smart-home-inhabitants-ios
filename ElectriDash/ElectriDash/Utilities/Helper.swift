//
//  Helper.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 04/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit
import LocalAuthentication
import JWTDecode
import Alamofire

class Helper {
    
    // Return true if key exists in userdefaults
    static func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    static func logout(clearLoginPassword: Bool){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + getStoredTokenString()!,
            "Accept": "application/json"
        ]
        
        Alamofire.request("\(Constants.Urls.api)/api/user/logout", headers: headers).response{ response in
            if response.response?.statusCode == 200{
                print("Logout call successfull")
            }else{
                print(response.error.debugDescription)
            }
        }
        
        let standard = UserDefaults.standard
        
        let token = Constants.Keys.token
        let houseId = Constants.Keys.houseId
        let currencyUnit = Constants.Keys.currencyUnit
        let username = Constants.Keys.username

        if isKeyPresentInUserDefaults(key: token){
            standard.removeObject(forKey: token)
        }
        
        if isKeyPresentInUserDefaults(key: houseId){
            standard.removeObject(forKey: houseId)
        }
        
        if isKeyPresentInUserDefaults(key: currencyUnit){
            standard.removeObject(forKey: currencyUnit)
        }
        
        if clearLoginPassword, isKeyPresentInUserDefaults(key: username){
            standard.removeObject(forKey: username)
        }
        
        standard.synchronize()
        
    }

    static func showAlertOneButton(viewController:UIViewController, title:String, message:String, buttonTitle:String){
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func isLoggedIn() -> Bool{
        if (UserDefaults.standard.value(forKey: Constants.Keys.token) as? String) != nil {
            return true
        } else {
            return false
        }
    }
    
    static func getStoredTokenString() -> String? {
        if let tokenString = UserDefaults.standard.value(forKey: Constants.Keys.token) as? String {
            return tokenString
        } else {
            return nil
        }
    }
    
    static func setStoredHouseId(id: Int){
        UserDefaults.standard.setValue(id, forKey: Constants.Keys.houseId)
        UserDefaults.standard.synchronize()
        
        print("Stored house id: \(id)")
    }
    
    static func getStoredHouseId() -> Int? {
        if let id = UserDefaults.standard.value(forKey: Constants.Keys.houseId) as? Int{
            print("Obtained house id: \(id)")
            return id
        }else{
            return nil
        }
        
    }
    
    static func setStoredTokenString(token: String){
        UserDefaults.standard.setValue(token, forKey: Constants.Keys.token)
        UserDefaults.standard.synchronize()
    }
    
    static func getToken() -> Token?{
        
        var token: Token?
        token = nil
        
        if let tokenString = getStoredTokenString(){
            
            do {
                let jwt = try decode(jwt: tokenString)
                
                let claimExternalSessionId = jwt.claim(name: Constants.JwtClaimNames.externalSessionId)
                let claimUsername = jwt.claim(name: Constants.JwtClaimNames.username)
                let claimName = jwt.claim(name: Constants.JwtClaimNames.name)
                let claimSurname = jwt.claim(name: Constants.JwtClaimNames.surname)
                let claimEmail = jwt.claim(name: Constants.JwtClaimNames.email)

                if let sessionId = claimExternalSessionId.string, let username = claimUsername.string, let name = claimName.string, let surname = claimSurname.string, let email = claimEmail.string, let expiresAt = jwt.expiresAt{
                    print("sessionId in jwt was \(sessionId)")
                    print("Username in jwt was \(username)")
                    print("Name in jwt was \(name)")
                    print("Surname in jwt was \(surname)")
                    print("Email in jwt was \(email)")
                    
                    print("ExpiresAt in jwt was \(expiresAt)")
                    
                    token = Token(sessionId: sessionId, username: username, name: name, surname: surname, email: email, expiresAt: expiresAt)
                    
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        return token
    }
    
    static func getStoredUsername() -> String? {
        if let username = UserDefaults.standard.value(forKey: Constants.Keys.username) as? String {
            return username
        } else {
            return nil
        }
    }
    
    static func setStoredUsername(username: String){
        UserDefaults.standard.setValue(username, forKey: Constants.Keys.username)
        UserDefaults.standard.synchronize()
    }
    
    static func getStoredRecentRoomsArray() -> [RecentRooms]? {
//        if let recentRoomsArray = UserDefaults.standard.object(forKey: Constants.Keys.recentRoomsArray) as? [RecentRooms] {
//            return recentRoomsArray
//        } else {
//            return nil
//        }
        
        if !isKeyPresentInUserDefaults(key: Constants.Keys.recentRoomsArray){
            return nil
        }
        
        // Get the profile from the userdefaults
        let defaults = UserDefaults.standard
        let data = defaults.object(forKey: Constants.Keys.recentRoomsArray) as! Data
        let recentRoomsArray = NSKeyedUnarchiver.unarchiveObject(with: data) as! [RecentRooms]
        
        return recentRoomsArray
    }
    
    static func setRecentRoomsArray(recentRoomsArray: [RecentRooms]){
//        UserDefaults.standard.set(recentRoomsArray, forKey: Constants.Keys.recentRoomsArray)
//        UserDefaults.standard.synchronize()
        
        let defaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: recentRoomsArray)
        defaults.set(encodedData, forKey: Constants.Keys.recentRoomsArray)
        defaults.synchronize()
    }
    
    static func addRecentRoom(room: Room){
        
        if let username = Helper.getToken()?.username, let houseId = Helper.getStoredHouseId(), let recentRoom = RecentRoom(id: room.id, name: room.name, imageLink: room.imageLink){
            
            let tempRecentRooms = RecentRooms(username: username, houseId: houseId, recentRooms: [recentRoom])!
            
            if var recentRoomsArray = getStoredRecentRoomsArray(){
                
                var userHouseExists = false
                
                var roomIndex:Int?
                
                for recentRooms in recentRoomsArray{
                    
                    if recentRooms == tempRecentRooms{
                        // The user/house combination already exists
                        print("User/House exists")
                        userHouseExists = true
                        
                        roomIndex = recentRooms.recentRooms.index(of: recentRoom)
                        if recentRooms.recentRooms.contains(recentRoom){
                            // The recentroom already exists, so the old one needs to be removed
                            print("Recentroom exists")
                            recentRooms.recentRooms.remove(at: roomIndex!)
                        }
                        
                        recentRooms.recentRooms.append(recentRoom)
                        
                        setRecentRoomsArray(recentRoomsArray: recentRoomsArray)
                    }
                }
                
                if !userHouseExists{
                    // Add user/house combo and room
                    print("User/House does not exists")
                    
                    recentRoomsArray.append(tempRecentRooms)
                    
                    setRecentRoomsArray(recentRoomsArray: recentRoomsArray)
                    
                }
                
            }else{
                // Create array, add user/house combo and add room
                print("No existing array, add new one with the room")
                
                setRecentRoomsArray(recentRoomsArray: [tempRecentRooms])
            }
            
        }
        
    }
    
    static func getRecentRooms() -> RecentRooms? {
        
        if let username = Helper.getToken()?.username, let houseId = Helper.getStoredHouseId(), let tempRecentRooms = RecentRooms(username: username, houseId: houseId, recentRooms: [RecentRoom]()), let recentRoomsArray = getStoredRecentRoomsArray(), recentRoomsArray.contains(tempRecentRooms){
            
            let index = recentRoomsArray.index(of: tempRecentRooms)
            
            return recentRoomsArray[index!]
        } else {
            return nil
        }
        
    }

    // Boolean is set when user has set to see currency instead of unit, the setting is saved in userdefaults
    static var isCurrency: Bool {
        get {
            if let currencyUnit = UserDefaults.standard.bool(forKey: Constants.Keys.currencyUnit) as Bool?{
                return currencyUnit
            } else {
                return false
            }
        }
        set(isCurrency) {
            UserDefaults.standard.set(isCurrency, forKey: Constants.Keys.currencyUnit)
            UserDefaults.standard.synchronize()
        }
    }
    
    // Return in kwh or currency string
    static func getCurrencyOrKWh(energyUsage: EnergyUsage) -> String{
        
        if isCurrency {
            if energyUsage.euro != nil{
                return "\(energyUsage.euro!)"
            }else {
                return "--"
            }
        }else{
            if energyUsage.usage != nil{
                return "\(energyUsage.usage!)"
            }else {
                return "--"
            }
        }
    }
    
    // Return in kwh or currency string
    static func getCurrencyOrW(energyUsage: EnergyUsage) -> String{
        
        if isCurrency {
            if energyUsage.euro != nil{
                return "\(energyUsage.euro!)"
            }else {
                return "--"
            }
        }else{
            if energyUsage.usage != nil{
                return "\(energyUsage.usage!)"
            }else {
                return "--"
            }
        }
    }
    
    // Return in cubicMeter or currency string
    static func getCurrencyOrCubicMeter(cubicMeter: Double) -> String{
        if isCurrency {
            let price = cubicMeter * Constants.Prices.cubicMeter
            return "\(price)"
        }else{
            return "\(cubicMeter)"
        }
    }
    
    // Return kwh or currency label name
    static func getCurrencyOrKWhName() -> String{
        if isCurrency {
            return Constants.Units.euro
        }else{
            return Constants.Units.kWh
        }
    }
    
    // Return W or currency label name
    static func getCurrencyOrWattName() -> String{
        if isCurrency {
            return Constants.Units.euro + " / uur"
        }else{
            return Constants.Units.watt
        }
    }
    
    // Return cubicMeter or currency label name
    static func getCurrencyOrCubicMeterName() -> String{
        if isCurrency {
            return Constants.Units.euro
        }else{
            return Constants.Units.cubicMeter
        }
    }
    
    // Return appropriate minute/hour/day string depending on time difference
    static func getFormattedTimeStringBetweenDates(beginDate:Date, endDate:Date) -> String{
        
        let calendar = Calendar.current

        let day = calendar.dateComponents([.day], from: beginDate, to: endDate).day!
        let hour = calendar.dateComponents([.hour], from: beginDate, to: endDate).hour!
        let minute = calendar.dateComponents([.minute], from: beginDate, to: endDate).minute!
        
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
        
        return showDate
    }
    
    // Remove the blur from the given view (if enabled by addBlur)
    static func removeBlur() {
        // Remove the blur from the view
        let window = UIApplication.shared.keyWindow!
        
        let blurView = window.viewWithTag(1001)
        
        UIView.animate(withDuration: 0.5,
                       animations: { blurView?.alpha = 0 },
                       completion: { finished in blurView?.removeFromSuperview() })
    }
    
    // Add the blur to the given view (remove using removeBlur)
    static func addBlur() {
        let window = UIApplication.shared.keyWindow!
        
        // Add a blur effect before the popup to add/change opens
        let blurEffectView = UIVisualEffectView()
        blurEffectView.frame = window.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.tag = 1001
        window.addSubview(blurEffectView)
        
        UIView.animate(withDuration: 0.5) {
            blurEffectView.effect = UIBlurEffect(style: .dark)
        }
    }
    
    // Checks if there is an internet connection
    static func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    static func setCenterActivityIndicator(view: UIView) -> UIActivityIndicatorView{
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center = view.center
        activityView.startAnimating()
        activityView.hidesWhenStopped = true
        activityView.color = Constants.AppColors.loginGreen
        
        view.addSubview(activityView)
        
        return activityView
    }
}
