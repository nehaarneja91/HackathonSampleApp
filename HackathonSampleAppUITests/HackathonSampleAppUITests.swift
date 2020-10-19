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
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testOverviewPage() {
  
        app.buttons["Go to overview"].tap()
    }
    
    func testMePage() {
        app.buttons["Go to overview"].tap()
        app.buttons["Go to Me Page"].tap()
    }
    
    func testAddEmailFlow() {
        app.buttons["Go to overview"].tap()
        app.buttons["Go to Me Page"].tap()
        app.buttons["Open DF welcome"].tap()
        app.buttons["Add Email"].tap()
    }
    
    func testListViewFlow() {
        app.buttons["Go to overview"].tap()
        app.buttons["Go to Me Page"].tap()
        app.buttons["Open DF welcome"].tap()
        app.buttons["ListView"].tap()
    }
}


class Screenshot {
    static var app: XCUIApplication?
    static var testCase: XCTestCase?
    
    func <#name#>(<#parameters#>) -> <#return type#> {
        <#function body#>
    }
}


