//
//  WebViewController.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/13/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var trailer: Trailer!
    var webView = WKWebView()
    
    override func loadView() {
        super.loadView()
        
        view = webView
        webView.addSubview(loadingView)
        webView.bringSubviewToFront(loadingView)
        setContraints()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWeb()
    }
    
    private func setContraints() {
        
        loadingView.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: webView.centerYAnchor).isActive = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupWeb() {
        
        activityIndicator.startAnimating()
        loadingView.layer.cornerRadius = 25
        webView.navigationDelegate = self
        
        let urlString = MovieAPI.getTrailerVideoURL(trailer.key)
        
        guard let finalUrl = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: finalUrl)
        webView.load(request)
        
    }

}

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        loadingView.isHidden = true

    }
}
