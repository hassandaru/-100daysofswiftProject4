//
//  DetailWebViewController.swift
//  Project4
//
//  Created by Hassan Sohail Dar on 17/8/2022.
//

import UIKit
import WebKit

class DetailWebViewController: UIViewController, WKNavigationDelegate {
    var progressView: UIProgressView!
    var webView: WKWebView!
    var urlValue = ""
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //add forward and back button for webview here
        let back = UIBarButtonItem(title: "<", style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: ">", style: .plain, target: webView, action: #selector(webView.goForward))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))

        
        
        
        toolbarItems = [progressButton, spacer, back, forward, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        let url = URL(string: "https://" + urlValue)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true

    }

    @objc func openTapped() {
        
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
        for website in websites.list {
            ac.addAction(UIAlertAction(title: urlValue, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        //important for iPad
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }

    func openPage(action: UIAlertAction) {
//        let url = URL(string: "https://" + action.title!)!
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url

        if let host = url?.host {
            for website in websites.list {
                if host.contains(website) {
                    if host.contains(websites.blockedList) {
                        //website is blocked
                        let ac = UIAlertController(title: websites.blockedList, message: "Sorry! this website is blocked", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
                        present(ac, animated: true)
                        decisionHandler(.cancel)
                        return
                    }
                    decisionHandler(.allow)
                    return
                }
            }
        }

        decisionHandler(.cancel)
    }
}
