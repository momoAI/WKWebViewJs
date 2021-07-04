//
//  ViewController.swift
//  WKWebViewJs
//
//  Created by mom on 2021/7/1.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    struct WebScriptHandlerName {
        static let clickButton = "clickButton"
    }

    var label: UILabel!
    var webview: WKWebView!
    
    // 使用WebViewJavascriptBridge
    var webBridge: WebViewJavascriptBridge!

    // MARK: - lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(frame: CGRect(x: 0, y: 100, width: 100, height: 30))
        button.setTitle("iOS Button", for: .normal)
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        view.addSubview(button)
        button.backgroundColor = .blue
        
        label = UILabel(frame: CGRect(x: 0, y: button.frame.maxY, width: view.bounds.width, height: 60))
        label.textColor = .white
        view.addSubview(label)
        label.backgroundColor = .red
        
        //-----------------------系统API-----------------------------------------------
        
//        let webConfig = WKWebViewConfiguration()

        // window.open打开新的界面
//        let webPreference = WKPreferences()
//        webPreference.javaScriptCanOpenWindowsAutomatically = true
//        webConfig.preferences = webPreference
//
//        let webUserController = WKUserContentController()
//        let scriptDelegate = WeakScriptMessageDelegate(delegate: self)
//        webUserController.add(scriptDelegate, name: WebScriptHandlerName.clickButton)
        // 注入js
//        let script = "var p = document.createElement('p'); p.innerHTML='injection from WKWebView'; document.getElementsByTagName(\"body\")[0].appendChild(p);"
//        let script = "function iOS2jsFunction() {return 'injection from WKWebView'}"
//        let script = """
//                    function injectionJsCalliOS() {
//                        window.webkit.messageHandlers.clickButton.postMessage({})
//                    };
//                    var button = document.getElementById('mm_btn');
//                    button.onclick = injectionJsCalliOS;
//                    """
//        let injectionScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//        webUserController.addUserScript(injectionScript)
//        webConfig.userContentController = webUserController
        
//        webview = WKWebView(frame: CGRect(x: 0, y: label.frame.maxY, width: view.bounds.width, height: 200), configuration: webConfig)
//        webview.uiDelegate = self
//        view.addSubview(webview)
//        let fileURL = Bundle.main.url(forResource: "iOSTest", withExtension: "html")
//        webview.loadFileURL(fileURL!, allowingReadAccessTo: Bundle.main.bundleURL)
        
        //----------------------------------------------------------------------------
        
        
        //-----------------------WebViewJavascriptBridge API--------------------------
        
        webview = WKWebView(frame: CGRect(x: 0, y: label.frame.maxY, width: view.bounds.width, height: 200))
        webview.uiDelegate = self
        view.addSubview(webview)
        let fileURL = Bundle.main.url(forResource: "iOSTest", withExtension: "html")
        webview.loadFileURL(fileURL!, allowingReadAccessTo: Bundle.main.bundleURL)
        
        webBridge = WebViewJavascriptBridge(webview)
        webBridge.registerHandler(WebScriptHandlerName.clickButton) { (data, responseCallback) in
            print("CalliOSFunction with JSParameter" + (data as? String ?? ""))
            // 返回值给JS
            responseCallback?("result from wkwebview")
        }
        
        //----------------------------------------------------------------------------
    }
    
    deinit {
        webview.configuration.userContentController.removeAllUserScripts()
        webview.configuration.userContentController.removeAllScriptMessageHandlers()
    }
    
    // MARK: - action -
    
    @objc func buttonClicked() {
        //-----------------------系统API-----------------------------------------------
        
        // webview调用js 已有函数
//        webview.evaluateJavaScript("jsFunction()") {[weak self] (data, _) in
//            self?.label.text = data as? String ?? "data error"
//        }
        
        // webview调用js 已有函数(带参数)
//        webview.evaluateJavaScript("jsFunctionParameter('wkWebview')") {[weak self] (data, _) in
//            self?.label.text = data as? String ?? "data error"
//        }
        
        // webview调用js WKWebView注入的js函数
//        webview.evaluateJavaScript("iOS2jsFunction()") {[weak self] (data, error) in
//            self?.label.text = data as? String ?? "data error"
//        }
        
        //----------------------------------------------------------------------------
        
        
        //-----------------------WebViewJavascriptBridge API--------------------------
        
        // 无参数
//        webBridge.callHandler("jsFunction", data: nil) {[weak self] (rps) in
//            self?.label.text = rps as? String ?? "data error"
//        }
        
        // 带参数
//        webBridge.callHandler("jsFunction", data: "wkWebview") {[weak self] (rps) in
//            self?.label.text = rps as? String ?? "data error"
//        }
        
        //----------------------------------------------------------------------------
    }
}

// MARK: - WKScriptMessageHandlerProtocol -

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == WebScriptHandlerName.clickButton {
            // 无参数
            print("call from js")
            // openCamera()...
            
            // 带参数 Allowed types are NSNumber, NSString, NSDate, NSArray,NSDictionary,NSNull
//            guard let parameter = message.body as? String else { return }
//            print("call from js " + parameter)
            // openCamera(parameter)
            
            // js调用webview, webview再调用js
//            webview.evaluateJavaScript("getClickButtonResult('result from wkwebview')")
        }
    }
}

// MARK: - WKScriptMessageHandlerProtocol -

extension ViewController: WKUIDelegate {
    // 只有一个 按钮的Alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "js alert", message: message, preferredStyle: .alert)
        alertController.addAction(
            UIAlertAction(title: "ok", style: .default, handler: { _ in
                completionHandler()
            })
        )

        present(alertController, animated: true)
    }

    // 两个按钮的 调用block返回yes或者no来确定是点击了取消按钮还是同意按钮
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        // ... completionHandler(true)
    }

    // 带输入框的alert
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        completionHandler("result from wkwebview")
    }
}
