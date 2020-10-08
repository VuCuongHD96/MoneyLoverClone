//
//  LoginViewController.swift
//  MoneyLoverClone
//
//  Created by Phan Minh Thang on 10/8/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    struct Constant {
        static let clientID = "782337553368-c802gf8k9fh3qqtpkevp3nl69fiolar0.apps.googleusercontent.com"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        autoLogin()
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        loginFacebook()
    }
    
    func loginFacebook() {
        let login = LoginManager()
        login.logOut()
        login.logIn(permissions: [.publicProfile, .email, .userFriends], viewController: self) {
            loginResult in
            switch loginResult {
            case .failed( _):
                print("Log in failed")
            case .success(granted: _, declined: _, token: _):
                print("Logged In")
                self.getData()
                let story = UIStoryboard.init(name: "Main", bundle: nil)
                guard let homeScreen = story.instantiateViewController(identifier: "Home") as? TabBarViewController else {
                    return
                }
                self.navigationController?.pushViewController(homeScreen, animated: true)
            case .cancelled:
                print("User cancelled log in")
            }
        }
    }
    
    func setupData() {
        GIDSignIn.sharedInstance()?.clientID = Constant.clientID
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    private func autoLogin() {
        if UserDefaults.standard.value(forKey: "email") != nil {
            goToMenuScreen()
        }
    }
    
    func getData() {
        if AccessToken.current != nil {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name"]).start(completionHandler: {(connection, result , error) -> Void in
                if error != nil{
                    print(error?.localizedDescription as Any)
                }
            })
        } else {
            print("Access Token is nil")
        }
    }
    
    func goToMenuScreen() {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        guard let homeScreen = story.instantiateViewController(identifier: "Home") as? TabBarViewController else {
            return
        }
        navigationController?.pushViewController(homeScreen, animated: true)
    }
}

extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn?, didSignInFor user: GIDGoogleUser?, withError error: Error!) {
        guard let currentUser = GIDSignIn.sharedInstance()?.currentUser else {
            return
        }
        let avatarURL = GIDSignIn.sharedInstance()?.currentUser.profile.imageURL(withDimension: 100)?.absoluteString ?? ""
        let name = String(currentUser.profile.name)
        let email = String(currentUser.profile.email)
        UserDefaults.standard.set(currentUser.profile.name, forKey: "name")
        UserDefaults.standard.set(currentUser.profile.email, forKey: "email")
        goToMenuScreen()
    }
}

