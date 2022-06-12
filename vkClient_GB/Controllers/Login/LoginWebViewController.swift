//
//
//  LoginWebViewController.swift
//  VKClient
//
//  Created by Дмитрий Скок on 03.12.2021.

import UIKit
import WebKit

class LoginWebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet{
            webView.navigationDelegate = self
        }
    }
    let constants = NetworkingConstants()
    var session = Session.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeRequest()
    }
}

private extension LoginWebViewController {
    func authorizeRequest () {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: constants.clientID),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "friends, photos, groups"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: constants.versionAPI),
            URLQueryItem(name: "revoke", value: "0")
        ]
        
        guard let url = urlComponents.url else {return}
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension LoginWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        if let token = params["access_token"], let userId = params["user_id"] {
            session.token = token
            session.userId = Int(userId)!
            print(token)
            print(userId)
            performSegue(withIdentifier: "login", sender: self)
            decisionHandler(.cancel)
            
        }
    }
}



    


