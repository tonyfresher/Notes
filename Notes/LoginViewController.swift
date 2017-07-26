//
//  LoginViewController.swift
//  Notes
//
//  Created by Anton Fresher on 25.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        view = webView
        
        //        view.addSubview(webView)
        //
        //        topLayoutGuide.bottomAnchor.constraint(equalTo: webView.topAnchor).isActive = true
        //        bottomLayoutGuide.topAnchor.constraint(equalTo: webView.bottomAnchor).isActive = true
        //        view.leadingAnchor.constraint(equalTo: webView.leadingAnchor).isActive = true
        //        view.trailingAnchor.constraint(equalTo: webView.trailingAnchor).isActive = true
        
        let request = URLRequest(url: BackendConfiguration.OAuthRequest.request)
        webView.load(request)
    }
    
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
        
        let accessToken = accessTokenArgument[1]
        // TODO: SAVE AND SEGUE
        decisionHandler(.cancel)
    }
}
