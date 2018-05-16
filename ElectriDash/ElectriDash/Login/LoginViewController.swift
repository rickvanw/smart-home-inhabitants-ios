//
//  ViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 04/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit
import Alamofire
import KeychainAccess
import LocalAuthentication

class LoginViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var gradientView: UIView!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var viewPasswordImageView: UIImageView!
    
    @IBOutlet var loginButton: UIButton!
    
    // Constraints connections
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet var loginButtonToPasswordConstraint: NSLayoutConstraint!
    
    @IBOutlet var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet var titleHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var titleBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var centerUsernameConstraint: NSLayoutConstraint!
    
    
    // Constraints initial values
    private var keyboardHeightLayoutDistance: CGFloat!
    private var loginButtonToPasswordDistance:CGFloat!
    private var titleBottomDistance:CGFloat!
    private var logoHeightDistance:CGFloat!
    
    
    private var extraButtonHeight:CGFloat!
    private var extraInputHeight:CGFloat!

    private var extraSmallScreenMode: Bool!
    
    private var viewPassword = false
    
    private var passwordFromKeychain: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        if self.traitCollection.horizontalSizeClass == .regular{
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        
        loginButton.addShadow()
        loginButton.layer.cornerRadius = 25
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self

        usernameTextField.tag = 0
        passwordTextField.tag = 1
        
        // Storyboard values are not respected
        viewPasswordImageView.tintColor = UIColor.white.withAlphaComponent(0.50)
        adjustViewForDevice()

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        if let username = Helper.getStoredUsername(){
            usernameTextField.text = username
        }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.gradientView.frame.size
        gradientLayer.locations = [0,0.3,0.6,1.0]
        gradientLayer.colors =
            [UIColor(hexString: "#4b5b6d").cgColor,
             UIColor(hexString: "#414e5e").cgColor,
             UIColor(hexString: "#2c3540").cgColor,
             UIColor(hexString: "#171c22").cgColor]
        
        self.gradientView.layer.addSublayer(gradientLayer)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var shouldAutorotate: Bool{
        if self.traitCollection.horizontalSizeClass == .regular && UIDevice.current.screenType != .iPhones_6Plus_6sPlus_7Plus_8Plus{
            return true
        }else{
            return false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

        if let touch = touches.first, touch.view == self.viewPasswordImageView{
            
        }else{
            view.endEditing(true)
        }
        
        super.touchesBegan(touches, with: event)
    }
    
    func requestToken(username: String, password: String){
        
        showActivityIndicator(message: "Bezig met inloggen...")
        
        let parameters: Parameters = [
            "email": username,
            "password": password
        ]
        
        Alamofire.request("\(Constants.Urls.api)/user/login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            self.dismissActivityIndicator()
            
            var showError = false
            var errorMessage = ""
            
            switch(response.result) {
            case .success:
                
                if let json = response.result.value, let object = json as? [String:Any], let token = object["token"] as? String {
                    print("JSON: \(json)") // serialized json response
                    print("TOKEN: \(token)")
                    
                    Helper.setStoredTokenString(token: token)
                    Helper.setStoredUsername(username: username)
                    
                    // After successfull login, perform segue
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                    
                }else{
                    showError = true
                    errorMessage = "Probeer het opnieuw"
                }
                
            case .failure(let error):
                
                showError = true
                
                print("FAILURE: \(error.localizedDescription)")
                
                if let httpStatusCode = response.response?.statusCode {
                    switch(httpStatusCode) {
                    case 401:
                        errorMessage = "Het emailadres of wachtwoord is verkeerd"
                    default:
                        errorMessage = "Er is een onbekende fout opgetreden"
                    }
                } else {
                    errorMessage = "Er is een onbekende fout opgetreden"
                }
            }
            
            if showError{
                Helper.showAlertOneButton(viewController: self, title: "Fout tijdens login", message: errorMessage, buttonTitle: "OK")
            }
            
        }
    }
    
    func showActivityIndicator(message: String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func dismissActivityIndicator(){
        dismiss(animated: false, completion: nil)
    }
    
    func adjustViewForDevice(){
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
            extraInputHeight = 20
            extraButtonHeight = 20
            
        case .iPhones_6Plus_6sPlus_7Plus_8Plus:
            
            keyboardHeightLayoutConstraint.constant = 180
            extraInputHeight = 20
            extraButtonHeight = 20
            
        case .iPhoneX:
            
            keyboardHeightLayoutConstraint.constant = 180
            extraInputHeight = 20
            extraButtonHeight = 20
            
        default:
            print("iPad")
            keyboardHeightLayoutConstraint.constant = 180
            extraInputHeight = 20
            extraButtonHeight = 20
        }
        
        
        self.view.layoutIfNeeded()
        
        keyboardHeightLayoutDistance = keyboardHeightLayoutConstraint.constant
        loginButtonToPasswordDistance = loginButtonToPasswordConstraint.constant
        titleBottomDistance = titleBottomConstraint.constant
        logoHeightDistance = logoHeightConstraint.constant
    }
        
    // MARK: Actions
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        view.endEditing(true)
        
        if usernameTextField.text != "" && passwordTextField.text != ""{
            requestToken(username: usernameTextField.text!, password: passwordTextField.text!)

        }else{
            Helper.showAlertOneButton(viewController: self, title: "Fout tijdens login", message: "Controleer of alle velden zijn ingevuld", buttonTitle: "OK")
        }
    }
    
    @IBAction func viewPasswordButtonPressed(_ sender: Any) {
        
        if(viewPassword == false) {
            
            viewPasswordImageView.tintColor = UIColor.white.withAlphaComponent(1.0)
            passwordTextField.isSecureTextEntry = false
            viewPassword = true

        } else {
            viewPasswordImageView.tintColor = UIColor.white.withAlphaComponent(0.50)
            passwordTextField.isSecureTextEntry = true
            viewPassword = false
        }
    }
    
    // If keyboard changes, adjust the rest of the view
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                
                if self.traitCollection.horizontalSizeClass == .regular{
                    centerUsernameConstraint.isActive = true
                    keyboardHeightLayoutConstraint.isActive = false
                }
                
                keyboardHeightLayoutConstraint.constant = keyboardHeightLayoutDistance
                loginButtonToPasswordConstraint.constant = loginButtonToPasswordDistance


            } else {
                
                if self.traitCollection.horizontalSizeClass == .regular{
                    centerUsernameConstraint.isActive = false
                    keyboardHeightLayoutConstraint.isActive = true
                }
                
                if !extraSmallScreenMode{
                    
                    keyboardHeightLayoutConstraint.constant = (endFrame?.size.height ?? 0.0) + extraButtonHeight
                    loginButtonToPasswordConstraint.constant = extraInputHeight
                    
                }else{
                    keyboardHeightLayoutConstraint.constant = (endFrame?.size.height ?? 0.0) + extraButtonHeight
                    loginButtonToPasswordConstraint.constant = extraInputHeight
                }
            }
            
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: { self.view.layoutIfNeeded() }, completion: nil)
        }
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

