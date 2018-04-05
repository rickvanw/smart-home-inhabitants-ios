//
//  ViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 04/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit
class LoginViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var gradientView: UIView!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet var loginButtonToPasswordConstraint: NSLayoutConstraint!
    
    @IBOutlet var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet var titleHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var titleBottomConstraint: NSLayoutConstraint!
    
    private var keyboardHeightLayoutDistance: CGFloat!
    private var loginButtonToPasswordDistance:CGFloat!
    private var titleBottomDistance:CGFloat!
    private var logoHeightDistance:CGFloat!
    
//    private var newKeyboardHeightLayoutDistance: CGFloat!
//    private var newLoginButtonToPasswordDistance:CGFloat!
//    private var newTitleBottomDistance:CGFloat!
//    private var newLogoHeightDistance:CGFloat!
    
    private var extraButtonHeight:CGFloat!
    private var extraInputHeight:CGFloat!

    private var extraSmallScreenMode: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loginButton.addShadow()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self

        usernameTextField.tag = 0
        passwordTextField.tag = 1
        
        let screenType = UIDevice.current.screenType
        
        extraSmallScreenMode = false
        extraInputHeight = 0
        extraButtonHeight = 0
        
        switch screenType {
            
        case .iPhone4_4S:
            
            keyboardHeightLayoutConstraint.constant = 16
            loginButtonToPasswordConstraint.constant = 30
            extraInputHeight = 10
            extraButtonHeight = 10
            extraSmallScreenMode = true
            
        case .iPhones_5_5s_5c_SE:
            
            keyboardHeightLayoutConstraint.constant = 40
            extraInputHeight = 20
            extraButtonHeight = 20
            extraSmallScreenMode = true

        case .iPhones_6_6s_7_8:
            
            keyboardHeightLayoutConstraint.constant = 120
            extraInputHeight = 60
            extraButtonHeight = 20
            
        case .iPhones_6Plus_6sPlus_7Plus_8Plus:
            
            keyboardHeightLayoutConstraint.constant = 180
            extraInputHeight = 60
            extraButtonHeight = 20
            
        case .iPhoneX:
            
            keyboardHeightLayoutConstraint.constant = 180
            extraInputHeight = 70
            extraButtonHeight = 0
            
        default:
            print("Unknown device")
        }
        
        
        self.view.layoutIfNeeded()
        
        
        keyboardHeightLayoutDistance = keyboardHeightLayoutConstraint.constant
        loginButtonToPasswordDistance = loginButtonToPasswordConstraint.constant
        titleBottomDistance = titleBottomConstraint.constant
        logoHeightDistance = logoHeightConstraint.constant

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.gradientView.frame.size
        gradientLayer.colors = [Constants.AppColors.loginBlue.cgColor,Constants.AppColors.loginGreen.cgColor]
        //Use diffrent colors
        self.gradientView.layer.addSublayer(gradientLayer)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                
                keyboardHeightLayoutConstraint.constant = keyboardHeightLayoutDistance
                loginButtonToPasswordConstraint.constant = loginButtonToPasswordDistance
                
            } else {
                
                if !extraSmallScreenMode{
                    
                    keyboardHeightLayoutConstraint.constant = (endFrame?.size.height ?? 0.0) + extraButtonHeight
                    loginButtonToPasswordConstraint.constant = loginButtonToPasswordDistance - ((endFrame?.size.height ?? 0.0) - keyboardHeightLayoutDistance) + extraInputHeight
                    
                }else{
                    keyboardHeightLayoutConstraint.constant = (endFrame?.size.height ?? 0.0) + extraButtonHeight
                    loginButtonToPasswordConstraint.constant = extraInputHeight
                }
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        
        super.touchesBegan(touches, with: event)
    }
    
    
    // MARK: Actions
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
    }
    
    
    // MARK: TextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }


}

