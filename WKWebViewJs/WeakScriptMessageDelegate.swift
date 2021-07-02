//
//  WeakScriptMessageDelegate.swift
//  WKWebViewJs
//
//  Created by mom on 2021/7/1.
//

import Foundation
import WebKit

class WeakScriptMessageDelegate: NSObject, WKScriptMessageHandler {
    
    weak var scriptDelegate: WKScriptMessageHandler?
    
    init(delegate: WKScriptMessageHandler?) {
        self.scriptDelegate = delegate
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.scriptDelegate?.userContentController(userContentController, didReceive: message)
    }
}
