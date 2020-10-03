//
//  LoginTwitterViewController.swift
//  TweetFromSpace
//
//  Created by 茂木貴紀 on 2020/10/03.
//  Copyright © 2020 K. All rights reserved.
//
import UIKit
import OAuthSwift

struct Const {
    static let consumerKey = "pLfYuBCVAbWVDp50PYqzcdsYq"
    static let consumerSecret = "wQOxSYIqsQ88nM9Pb53YhHORySqAN5nbkz8WydW4o1pWQ4MZiP"
}

class LoginTwitterViewController: UIViewController {
    var oauthswift: OAuthSwift?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("^^^^^^^^^")
    }
    
    @IBAction func click(_ sender: Any) {
        doOAuthTwitter()
    }
    
    /// OAuth1ログイン処理
    func doOAuthTwitter(){
        
        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: ["oauthToken": "default","oauthTokenSecret": "default"])

        let oauthswift = OAuth1Swift(
            consumerKey: Const.consumerKey,
            consumerSecret: Const.consumerSecret,
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl:    "https://api.twitter.com/oauth/authorize",
            accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
        )
        self.oauthswift = oauthswift
        oauthswift.authorizeURLHandler = getURLHandler()

        // コールバック処理
        oauthswift.authorize(withCallbackURL: URL(string: "TwitterLoginSampleOAuth://")!,
                             completionHandler:
            { result in
                switch result {
                case .success(let (credential, _, _)):
                    userDefaults.set(credential.oauthToken, forKey:"oauthToken")
                    userDefaults.set(credential.oauthTokenSecret,forKey: "oauthTokenSecret")
                    self.move()
                    print("success")
                case .failure(let error):
                    print(error.localizedDescription)
                    print("failure")
                }
        }
        )
    }

    /// ログイン画面起動に必要な処理
    ///
    /// - Returns: OAuthSwiftURLHandlerType
    func getURLHandler() -> OAuthSwiftURLHandlerType {
        if #available(iOS 9.0, *) {
            let handler = SafariURLHandler(viewController: self, oauthSwift: self.oauthswift!)
            handler.presentCompletion = {
                print("Safari presented")
            }
            handler.dismissCompletion = {
                print("Safari dismissed")
            }
            return handler
        }
        return OAuthSwiftOpenURLExternally.sharedInstance
    }
    
    func move() {
        performSegue(withIdentifier: "toViewController",sender: nil)
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toViewController2") {
            let vc2: ViewController = (segue.destination as? ViewController)!
        }
    }

}
