//
//  networking.swift
//  version-control-ios
//
//  Created by Luis Mesas on 2/10/15.
//  Copyright (c) 2015 Luis Mesas. All rights reserved.
//

import XCTest

class networking: XCTestCase {

    override func setUp() {
        super.setUp()
        LSNocilla.sharedInstance().start()
    }
    
    override func tearDown() {
        super.tearDown()
        LSNocilla.sharedInstance().start()
        LSNocilla.sharedInstance().clearStubs()
    }
    
    func testInvalidVersionNotification() {
        let vc = VersionControl()
        vc.start()
        
        let expectation = self.expectationWithDescription("testInvalidVersionNotification")
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        notificationCenter.addObserverForName(VersionControlNotificationInvalidVersion, object: vc, queue: mainQueue) { _ in
            vc.stop()
            expectation.fulfill()
        }
        
        stubRequest("GET", "http://localhost/path").andReturn(400)
            .withHeader("content-type","application/json")
            .withBody("{\"err\":\"invalid_version\",\"des\":\"Must update to last application version\"}")
        
        let networkManager = AFHTTPRequestOperationManager()
        networkManager.responseSerializer = AFJSONResponseSerializer()
        networkManager.GET("http://localhost/path", parameters: nil, success: nil, failure: nil)
        
        self.waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    func testInvalidVersionNotificationUserInfo() {
        let vc = VersionControl()
        vc.start()
        
        let expectation = self.expectationWithDescription("testInvalidVersionNotificationUserInfo")
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        notificationCenter.addObserverForName(VersionControlNotificationInvalidVersion, object: vc, queue: mainQueue) { (notification:NSNotification!) -> Void in
            notificationCenter.removeObserver(self)
            if let info = notification.userInfo as? Dictionary<String,String> {
                if let data = info["data"] {
                    XCTAssertEqual(data, "http://link", "invalid data attribute")
                } else {
                    XCTFail("invalid data attribute")
                }
            } else {
                XCTFail("no userinfo included in notification")
            }
            vc.stop()
            expectation.fulfill()
        }
        
        stubRequest("GET", "http://localhost/path").andReturn(400)
            .withHeader("content-type","application/json")
            .withBody("{\"err\":\"invalid_version\",\"des\":\"Must update to last application version\",\"data\":\"http://link\"}")
        
        let networkManager = AFHTTPRequestOperationManager()
        networkManager.responseSerializer = AFJSONResponseSerializer()
        networkManager.GET("http://localhost/path", parameters: nil, success: nil, failure: nil)
        
        self.waitForExpectationsWithTimeout(1, handler: nil)
    }
}
