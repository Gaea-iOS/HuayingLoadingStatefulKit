//
//  ProgressProxyWebView.swift
//  FBSnapshotTestCase
//
//  Created by lzc1104 on 2018/4/26.
//

import Foundation
import WebKit

public class ProxyWebview: WKWebView, WKNavigationDelegate,WKUIDelegate, ViewStateMachineProtocol {
    
    
    
    override public init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        self._initialSubViews()
        self._layoutConstraints()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var _proxyuiDelegate: WKUIDelegate?
    weak var _proxynavigationDelegate: WKNavigationDelegate?
    override public var uiDelegate: WKUIDelegate? {
        set {
            if let _ = newValue ,newValue! is ProxyWebview {
                super.uiDelegate = newValue
            } else {
                self._proxyuiDelegate = newValue
            }
        }
        
        get {
            return self._proxyuiDelegate
        }
    }
    
    public override var navigationDelegate: WKNavigationDelegate? {
        set {
            if let _ = newValue ,newValue! is ProxyWebview {
                super.navigationDelegate = newValue
            } else {
                self._proxynavigationDelegate = newValue
            }
        }
        
        get {
            return self._proxynavigationDelegate
        }
    }
    
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .white
        view.progressTintColor = ViewStateManager.shared.configuration.webProgressColor
        return view
    }()
    
    //MARK: -Private Layout
    private func _initialSubViews() {
        self.uiDelegate = self
        self.navigationDelegate = self
        self.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.progressView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func _layoutConstraints() {
        self.addSubview(progressView)
        self.equalAttribute(to: self.progressView, attribute: NSLayoutAttribute.left)
            .equalAttribute(to: self.progressView, attribute: NSLayoutAttribute.right)
            .equalAttribute(to: self.progressView, attribute: NSLayoutAttribute.top)
        
        self.progressView.heightCons(2)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let key = keyPath else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        guard let ofObject = object as? WKWebView, ofObject == self else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if key == "estimatedProgress" {
            progressView.progress = Float(self.estimatedProgress)
            if progressView.progress >= 1.0 {
                progressView.isHidden = true
            } else {
                progressView.isHidden = false
            }
        }
        
    }
    
    typealias WKNavigationActionMethodType = (WKWebView,WKNavigationAction,@escaping(WKNavigationActionPolicy)->Void) -> Void
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        
        if let _ = self._proxynavigationDelegate {
            if self._proxynavigationDelegate!.responds(to: #selector(webView(_:decidePolicyFor:decisionHandler:) as WKNavigationActionMethodType)) {
                self._proxynavigationDelegate!.webView!(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
        
    }
    typealias WKNavigationResponseMethodType = (WKWebView,WKNavigationResponse,@escaping(WKNavigationResponsePolicy)->Void) -> Void
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void) {
        if let _ = self._proxynavigationDelegate {
            if self._proxynavigationDelegate!.responds(to: #selector(webView(_:decidePolicyFor:decisionHandler:) as WKNavigationResponseMethodType)) {
                self._proxynavigationDelegate!.webView!(webView, decidePolicyFor: navigationResponse, decisionHandler: decisionHandler)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
    
    typealias WKNavigationProvisionalNavigationMethodType = (WKWebView,WKNavigation) -> Void
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if let _ = self._proxynavigationDelegate {
            if self._proxynavigationDelegate!.responds(to: #selector(webView(_:didStartProvisionalNavigation:) as WKNavigationProvisionalNavigationMethodType)) {
                self._proxynavigationDelegate!.webView!(webView, didStartProvisionalNavigation: navigation)
            }
        }
    }
    
    typealias WKNavigationdidReceiveServerRedirectMethodType = (WKWebView,WKNavigation) -> Void
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if let _ = self._proxynavigationDelegate {
            if self._proxynavigationDelegate!.responds(to: #selector(webView(_:didReceiveServerRedirectForProvisionalNavigation:) as WKNavigationdidReceiveServerRedirectMethodType)) {
                self._proxynavigationDelegate!.webView!(webView, didReceiveServerRedirectForProvisionalNavigation: navigation)
            }
        }
    }
    typealias WKNavigationdidFailProvisionalMethodType = (WKWebView,WKNavigation,Error) -> Void
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.state = ViewErrorState.init(error: error as NSError, resume: {
            self.state = .normal()
            self.reload()
        })
        if let _ = self._proxynavigationDelegate {
            if self._proxynavigationDelegate!.responds(to: #selector(webView(_:didFailProvisionalNavigation:withError:) as WKNavigationdidFailProvisionalMethodType)) {
                self._proxynavigationDelegate!.webView!(webView, didFailProvisionalNavigation: navigation, withError: error)
            }
        }
    }
    typealias WKNavigationdidCommitMethodType = (WKWebView,WKNavigation) -> Void
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if let _ = self._proxynavigationDelegate {
            if self._proxynavigationDelegate!.responds(to: #selector(webView(_:didCommit:) as WKNavigationdidCommitMethodType)) {
                self._proxynavigationDelegate!.webView!(webView, didCommit: navigation)
            }
        }
    }
    typealias WKNavigationdidFinishMethodType = (WKWebView,WKNavigation) -> Void
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.state = .normal()
        if let _ = self._proxynavigationDelegate {
            if self._proxynavigationDelegate!.responds(to: #selector(webView(_:didFinish:) as WKNavigationdidFinishMethodType)) {
                self._proxynavigationDelegate!.webView!(webView, didFinish: navigation)
            }
        }
    }
    typealias WKNavigationdidFailMethodType = (WKWebView,WKNavigation,Error) -> Void
    public  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.state = ViewErrorState.init(error: error as NSError, resume: {
            self.reload()
        })
        if let _ = self._proxynavigationDelegate {
            if self._proxynavigationDelegate!.responds(to: #selector(webView(_:didFail:withError:) as WKNavigationdidFailMethodType)) {
                self._proxynavigationDelegate!.webView!(webView, didFail: navigation, withError: error)
            }
        }
    }
    
    typealias WKNavigationdidReceiveChallengeMethodType = (WKWebView,URLAuthenticationChallenge,@escaping(URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) -> Void
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        if let _ = self._proxynavigationDelegate {
            if self._proxynavigationDelegate!.responds(to: #selector(webView(_:didReceive:completionHandler:) as WKNavigationdidReceiveChallengeMethodType)) {
                self._proxynavigationDelegate!.webView!(webView, didReceive: challenge, completionHandler: completionHandler)
            } else {
                completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
            }
        } else {
            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
        }
    }
    typealias WKContentProcessDidTerminateMethodType = (WKWebView) -> Void
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView)  {
        if let _ = self._proxynavigationDelegate {
            if self._proxynavigationDelegate!.responds(to: #selector(webViewWebContentProcessDidTerminate(_:) as WKContentProcessDidTerminateMethodType)) {
                self._proxynavigationDelegate!.webViewWebContentProcessDidTerminate!(webView)
            }
        }
    }
    
}


//public class ProgressWebview: UIView {
//
//    public var webview: WKWebView!
//    //MARK: -Override Intializer
//    override public init(frame: CGRect) {
//        super.init(frame: .zero)
//        self._initialSubViews()
//        self._layoutConstraints()
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    //MARK: -Private Layout
//    private func _initialSubViews() {
//        self.webview = ProxyWebview(frame: CGRect.zero)
//        self.webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
//        self.progressView.translatesAutoresizingMaskIntoConstraints = false
//        self.webview.translatesAutoresizingMaskIntoConstraints = false
//
//    }
//
//    private func _layoutConstraints() {
//        self.addSubview(self.webview)
//        self.addSubview(progressView)
//
//        self.equalAttribute(to: self.progressView, attribute: NSLayoutAttribute.left)
//            .equalAttribute(to: self.progressView, attribute: NSLayoutAttribute.right)
//            .equalAttribute(to: self.progressView, attribute: NSLayoutAttribute.top)
//        self.progressView.heightCons(2)
//
//        self.equalAttribute(to: self.webview, attribute: NSLayoutAttribute.left)
//            .equalAttribute(to: self.webview, attribute: NSLayoutAttribute.right)
//            .equalAttribute(to: self.webview, attribute: NSLayoutAttribute.bottom)
//
//        self.addConstraint(NSLayoutConstraint.init(item: self.webview, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.progressView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))
//
//
//    }
//
//    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
//        guard let key = keyPath else {
//            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//            return
//        }
//        guard let ofObject = object as? WKWebView, ofObject == self.webview else {
//            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//            return
//        }
//
//        if key == "estimatedProgress" {
//            progressView.progress = Float(self.webview.estimatedProgress)
//            if progressView.progress >= 1.0 {
//                progressView.isHidden = true
//            } else {
//                progressView.isHidden = false
//            }
//        }
//
//    }
//
//    private lazy var progressView: UIProgressView = {
//        let view = UIProgressView()
//        view.trackTintColor = .white
//        view.progressTintColor = .red
//        return view
//    }()
//
//
//
//}

