//
//  TestEncodeImage.swift
//  GazeBrowser
//
//  Created by Supphawit Getmark on 28/4/2561 BE.
//  Copyright © 2561 King Mongkut's Institute of Technology Ladkrabang. All rights reserved.
//

import XCTest

class TestSocketMessage: XCTestCase {
    
    let expectedWidth = 720
    let expectedHeight = 1280
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testImageEncode() {
        let bundlePath = Bundle.main.path(forResource: "test", ofType: "jpg")
        let testImage = UIImage(contentsOfFile: bundlePath!)
        XCTAssertNotNil(testImage)
        let result = testImage?.toJpg(quality: 0.91, width:expectedWidth, height:expectedHeight)
        XCTAssertNotNil(result)
        let resultImage = UIImage(data: result!)
        XCTAssertTrue(resultImage?.size.width ==  CGFloat(expectedWidth))
        XCTAssertTrue(resultImage?.size.height == CGFloat(expectedHeight))
        

    }
    
}
