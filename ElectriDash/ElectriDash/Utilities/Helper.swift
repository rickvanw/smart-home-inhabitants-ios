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
    
    static func getStoredTokenString() -> String? {
        if let tokenString = UserDefaults.standard.value(forKey: Constants.Keys.token) as? String {
            return tokenString
        } else {
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
    
    
    
    // Part of faceId / TouchId implementation - Disabled due to incompletion
//    static func biometricType() -> BiometricType {
//        let authContext = LAContext()
//        if #available(iOS 11, *) {
//            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
//            switch(authContext.biometryType) {
//            case .none:
//                return .none
//            case .touchID:
//                return .touch
//            case .faceID:
//                return .face
//            }
//        } else {
//            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
//        }
//    }
//
//    enum BiometricType {
//        case none
//        case touch
//        case face
//    }
    
}
