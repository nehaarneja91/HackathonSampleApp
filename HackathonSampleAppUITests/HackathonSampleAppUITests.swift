//
//  HackathonSampleAppUITests.swift
//  HackathonSampleAppUITests
//
//  Created by Kumar Singh, Randhir on 19/10/20.
//  Copyright © 2020 Kumar Singh, Randhir. All rights reserved.
//

import XCTest

class HackathonSampleAppUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        setupScreenshot(app: app, testCase: self)
        app.launch()
    }
    
    override func tearDown() {
        
    }
    
    func testOverviewPage() {
        app.buttons["Go to overview"].tap()
        screenshot(name: "Overview")
    }
    
    func testMePage() {
        app.buttons["Go to overview"].tap()
        app.buttons["Go to Me Page"].tap()
        screenshot(name: "Me Page")
    }
    
    func testAddEmailFlow() {
        screenshot(name: "Login")
        app.buttons["Go to overview"].tap()
        screenshot(name: "Overview")
        app.buttons["Go to Me Page"].tap()
        screenshot(name: "Me Page")
        app.buttons["Open DF welcome"].tap()
        screenshot(name: "DF Welcome Screen")
        app.buttons["Add Email"].tap()
        screenshot(name: "Add Email")
    }
    
    func testListViewFlow() {
        screenshot(name: "Login")
        app.buttons["Go to overview"].tap()
        screenshot(name: "Overview")
        app.buttons["Go to Me Page"].tap()
        screenshot(name: "Me Page")
        app.buttons["Open DF welcome"].tap()
        screenshot(name: "DF Welcome Screen")
        app.buttons["ListView"].tap()
        screenshot(name: "Add Email")
    }
}

class ScreenshotHelper {
    static var app: XCUIApplication?
    static var testCase: XCTestCase?
    
    static func screenshot(name: String, lifetTime: XCTAttachment.Lifetime = .keepAlways) {
        guard let app = app, let testCase = testCase else {
            return
        }
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = lifetTime
        testCase.add(attachment)
        snapshot(name)
        //Save into folder
        
        
    }
}

func setupScreenshot(app: XCUIApplication, testCase: XCTestCase) {
    ScreenshotHelper.app = app
    ScreenshotHelper.testCase = testCase
    setupSnapshot(app)
}

func screenshot(name: String, lifetTime: XCTAttachment.Lifetime = .keepAlways) {
    ScreenshotHelper.screenshot(name: name, lifetTime: lifetTime)
}



