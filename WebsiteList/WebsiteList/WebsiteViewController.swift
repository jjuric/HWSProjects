//
//  WebsiteViewController.swift
//  WebsiteList
//
//  Created by Jakov Juric on 13/10/2018.
//  Copyright © 2018 Jakov Juric. All rights reserved.
//
import WebKit
import UIKit

class WebsiteViewController: UIViewController, WKNavigationDelegate {
    var webView : WKWebView!
    var website : String?
    var progressView : UIProgressView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progress = UIBarButtonItem(customView: progressView)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [progress, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        if let websiteURL = website {
            openWebsite(withURL: websiteURL)
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    func openWebsite(withURL url: String){
        webView.load(URLRequest(url: URL(string: "https://" + url)!))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        removeObserver(self, forKeyPath: "estimatedProgress")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
