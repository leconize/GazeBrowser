//
//  TestMessageController.swift
//  GazeBrowserTests
//
//  Created by Supphawit Getmark on 28/4/2561 BE.
//  Copyright © 2561 King Mongkut's Institute of Technology Ladkrabang. All rights reserved.
//

import XCTest

class TestMessageController: XCTestCase {

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test01_init() {
        let messageController = MessageController(id:1)
        XCTAssertEqual(messageController.id, 1)
        XCTAssertNil(messageController.pageId)
    }
    
    func test02_setPageId() {
        let messageController = MessageController(id:1)
        messageController.pageId = 3
        XCTAssertEqual(messageController.pageId, 3)
    }
    
    func test03_sendCameraImage() {
        let messageController = MessageController(id:1)
        messageController.pageId = 3
        let bundlePath = Bundle.main.path(forResource: "test", ofType: "jpg")
        let testImage = UIImage(contentsOfFile: bundlePath!)
        let message: SocketMessage? = messageController.createMessage(image: testImage!)
        XCTAssertNotNil(message)
    }
    
    
}
