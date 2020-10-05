//
//  ViewController.swift
//  TweetFromSpace
//
//  Created by K on 2020/10/03.
//  Copyright © 2020 K. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase

// MARK: - Global
var l_flg = 0

class ViewController: UIViewController, GIDSignInDelegate {
    
    // MARK: - Outlet
    
    // MARK: - Action
    @IBAction func clickButton(_ sender: UIButton) {
//        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Firebase Initialize
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
//        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.viewController = self
        
    }
    
    // MARK: - User Methods
    
    // Google Sing In
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let err = error{
            if(err as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue{
                print("The user has not signed before or they have since sign out...")
            }else{
                print("\(err.localizedDescription)")
            }
            return
        }
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            // Already user is signed in...
            print("Signed In :)")
            self.loginSegue()
        }
    }
    // Google Sing Out
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // When the user disconnects from this app.
        // Firebase logout process is below...
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
        }
        catch let signOutError as NSError{
            print("Error Sign out %@", signOutError)
        }
    }
    
    
    // For iOS 9.0 or later than its version.
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
            return GIDSignIn.sharedInstance().handle(url)
        }

    // For iOS older than 9.0...
    func application(_ app: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
            return GIDSignIn.sharedInstance().handle(url)
        }
    func loginSegue(){
        let storyboard: UIStoryboard = self.storyboard!
        let second = storyboard.instantiateViewController(identifier: "second")
        self.present(second, animated: true, completion: nil)
    }
    
    
}
