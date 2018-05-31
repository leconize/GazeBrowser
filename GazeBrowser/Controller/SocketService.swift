//
//  SocketService.swift
//  GazeBrowser
//
//  Created by Supphawit Getmark on 30/4/2561 BE.
//  Copyright © 2561 King Mongkut's Institute of Technology Ladkrabang. All rights reserved.
//

import Foundation
import SwiftSocket

enum SocketServiceState {
    
}
protocol SocketServiceDelegate {
    
    func serviceReady(id: Int)
    func onSendWebPageResponse(pageId: Int)
    
}


class SocketService {
    
    let client: TCPClient
    
    let SERVER_ADDRESS = "161.246.49.250"
    let PORT: Int32 = 1234
    let TIMEOUT = 2
    
    var sessionId: Int?
    
    var delegate: SocketServiceDelegate?
    
    init() {
        client = TCPClient(address: SERVER_ADDRESS, port: PORT)
        switch client.connect(timeout: TIMEOUT) {
        case .success:
            print("connection init success")
            // first byte is message type second is user id
            let a = Data.init(bytes: [0, 1])
            print(a.count)
            switch client.send(data: a) {
            case .success:
                guard let data = client.read(1024*10, timeout: 3) else { return }
                let int = Data.init(bytes: data).integer
                print("session id = \(int)")
                delegate?.serviceReady(id: int)
            case .failure(let error):
                print("Socket send \(error)")
            }
        case .failure(let error):
            print("Error on connect with \(error)")
        }
    }
    
    func sendPage(message: SocketMessage) {
        switch client.send(data: message.data) {
        case .success:
            print("success")
//            guard let data = client.read(1024*10, timeout: 3) else { return }
//            _ = Data(bytes: data)
//            delegate?.onSendWebPageResponse(pageId: 1)
        case .failure(let error):
            print("Page Error : \(error)")
        }
    }
    
    func sendImage(message: SocketMessage) {
        let _ = client.send(data: message.data)
    }
    
    
}
