//
//  LoginViewController.swift
//  WeatherApp
//
//  Created by Saiteja Alle on 11/18/20.
//  Copyright © 2020 Saiteja Alle. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Weather App"
        self.view.backgroundColor = UIColor.white
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        loginButton.permissions = ["email"]
        loginButton.delegate = self
        loginButton.backgroundColor = UIColor.primaryColor()
        loginButton.setBackgroundImage(nil, for: .normal)
        loginButton.setBackgroundImage(nil, for: .highlighted)
        loginButton.setBackgroundImage(nil, for: .selected)
        view.addSubview(loginButton)
        
        showWeatherViewController(token: AccessToken.current)
    }
    
    private func showWeatherViewController(token: AccessToken?) {
        guard let token = token, !token.isExpired else {
            return
        }
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherViewControllerID") as? WeatherViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LoginViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        showWeatherViewController(token: result?.token)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }

}
