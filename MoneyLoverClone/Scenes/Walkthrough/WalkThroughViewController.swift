//
//  WalkThroughViewController.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 10/8/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import BWWalkthrough
import FBSDKLoginKit
import GoogleSignIn
import Reusable
import Then

final class WalkThroughViewController: BWWalkthroughViewController {
    
    // MARK: - Properties
    struct Constant {
        static let clientID = "782337553368-c802gf8k9fh3qqtpkevp3nl69fiolar0.apps.googleusercontent.com"
    }
    var database: DBManager!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Data
    func setupData() {
        database = DBManager.shared
        GIDSignIn.sharedInstance()?.do {
            $0.clientID = Constant.clientID
            $0.presentingViewController = self
        }
    }
    
    func getData() {
        if AccessToken.current != nil {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name"]).start(completionHandler: { (_, _, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
            })
        } else {
            print("Access Token is nil")
        }
    }
    
    // MARK: - Action
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
        login.logIn(permissions: [.publicProfile, .email, .userFriends], viewController: self) { loginResult in
            switch loginResult {
            case .failed(_):
                print("Log in failed")
            case .success(granted: _, declined: _, token: _):
                print("Logged In")
                self.getData()
            case .cancelled:
                print("User cancelled log in")
            }
        }
    }
}

extension WalkThroughViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn?, didSignInFor user: GIDGoogleUser?, withError error: Error!) {
        guard let currentUser = GIDSignIn.sharedInstance()?.currentUser else {
            return
        }
        let avatarURL = GIDSignIn.sharedInstance()?.currentUser.profile.imageURL(withDimension: 100)?.absoluteString ?? ""
        let name = String(currentUser.profile.name)
        let email = String(currentUser.profile.email)
        let newUser = User(name: name, email: email, avatar: avatarURL)
        database.save(newUser)
        dismiss(animated: false, completion: nil)
    }
}

extension WalkThroughViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.walkThrough
}
