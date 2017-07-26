//
//  LoginViewController.swift
//  Notes
//
//  Created by Anton Fresher on 25.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController {
    
    // PART: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(webView)
        
        topLayoutGuide.bottomAnchor.constraint(equalTo: webView.topAnchor).isActive = true
        bottomLayoutGuide.topAnchor.constraint(equalTo: webView.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: webView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: webView.trailingAnchor).isActive = true
        
        let request = URLRequest(url: BackendConfiguration.OAuthRequest.requestURL)
        webView.load(request)
    }
    
    // PART: - Segues handling

    static let successfullyAuthorizedSegueIdentifier = "Successfully Authorized"
    
    fileprivate func performSegueToMain() {
        performSegue(withIdentifier: LoginViewController.successfullyAuthorizedSegueIdentifier, sender: nil)
    }
    
}

extension LoginViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url,
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let fragment = urlComponents.fragment,
            urlComponents.host == BackendConfiguration.host else {
                decisionHandler(.allow)
                return
        }
        
        let arguments = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
        
        guard let accessTokenArgument = arguments.first(where: { $0[0] == BackendConfiguration.OAuthResponse.Arguments.accessToken.rawValue }) else {
            decisionHandler(.allow)
            return
        }
        
        let token = accessTokenArgument[1]
        UserDefaults.standard.setValue(token, forKey: AppDelegate.userAuthSettingName)
        
        decisionHandler(.cancel)
        
        performSegueToMain()
    }

}
