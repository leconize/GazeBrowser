//
//  BrowserViewController.swift
//  GazeBrowser
//
//  Created by Supphawit Getmark on 29/4/2561 BE.
//  Copyright © 2561 King Mongkut's Institute of Technology Ladkrabang. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import SwiftSocket

enum BrowserError: Error {
    case invalidURL
    case unableToSaveWebPage
}

class BrowserViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var urlTextInput: UITextField!
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    
    var isCreateWebImage: Bool = false
    var socketService: SocketService = SocketService()
    var messageController: MessageController?
    var cameraController: CameraController?
    
    @IBAction func submitUrl() -> Void {
        guard let textUrl = urlTextInput.text else { return }
        guard let url = URL(string: textUrl) else { return }
        let urlText = URLRequest(url: url)
        webview.load(urlText)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submitUrl()
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backButtonTap(_ sender: Any) {
        if webview.canGoBack {
            webview.goBack()
        }
    }
    
    @IBAction func forwardButtonTap(_ sender: Any) {
        if webview.canGoForward {
            webview.goForward()
        }
    }
    
    
    override func viewDidLoad() {
        self.messageController = MessageController()
        urlTextInput.delegate = self
        webview.navigationDelegate = self
        DispatchQueue.main.async {
            self.cameraController = CameraController()
            self.cameraController?.prepare {error in
                if let _error = error {
                    print(_error)
                }
                self.cameraController?.delegate = self
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let url = URL(string: "https://apple.com") else { return }
        let urlText = URLRequest(url: url)
        webview.load(urlText)
    }
    
}

extension BrowserViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        
        urlTextInput.text = webView.url?.absoluteString
        isCreateWebImage = false
        
        self.webview.fullLengthScreenshot {
            image in
            print(image)
            guard let message = self.messageController?.createPageMessage(image: image) else { return }
            self.socketService.sendPage(message: message)
        }
    }
    
    
}

extension BrowserViewController: CameraControllerDelegate {
    func didCaptureVideoFrame(image: UIImage) -> Void {
        DispatchQueue.main.async {
            let offset = self.webview.scrollView.contentOffset
            DispatchQueue.global().async {
                guard let message = self.messageController?.createMessage(image: image, offset: offset) else { return }
    
                self.socketService.sendImage(message: message)
            }
        }
    }
}

extension BrowserViewController: SocketServiceDelegate {
    
    func onSendWebPageResponse(pageId: Int) {
        messageController?.pageId = pageId
    }
    
    
    func serviceReady(id: Int) {
        messageController = MessageController()
        messageController?.id = id
        print("init message service")
    }
   
    
}
