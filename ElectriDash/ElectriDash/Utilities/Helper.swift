//
//  Helper.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 04/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit
import LocalAuthentication

class Helper {
    
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
    
    static func getToken() -> String? {
        if let token = UserDefaults.standard.value(forKey: Constants.Keys.token) as? String {
            return token
        } else {
            return nil
        }
    }
    
    static func setToken(token: String){
        UserDefaults.standard.setValue(token, forKey: Constants.Keys.token)
        UserDefaults.standard.synchronize()
    }
    
    static func getUsername() -> String? {
        if let username = UserDefaults.standard.value(forKey: Constants.Keys.username) as? String {
            return username
        } else {
            return nil
        }
    }
    
    static func setUsername(username: String){
        UserDefaults.standard.setValue(username, forKey: Constants.Keys.username)
        UserDefaults.standard.synchronize()
    }
    
    static func biometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
        }
    }
    
    enum BiometricType {
        case none
        case touch
        case face
    }
    
}
