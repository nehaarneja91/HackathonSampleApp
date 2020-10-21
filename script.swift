#!/usr/bin/env swift
import Foundation

let process = Process()
process.executableURL = URL(fileURLWithPath: "/usr/bin/env")

let scheme = "HackathonSampleAppUITests"
let projectScheme = "HackathonSampleApp"
let project = "HackathonSampleApp.xcodeproj"
let platform = "platform=iOS Simulator,name=iPhone 11 Pro Max,OS=13.2.2"
let CONFIGURATION = "Debug"

func getTestPlans() -> [String] {
    let pipe = Pipe()
    var testPlans = [String]()
    process.standardOutput = pipe
    process.arguments = ["xcodebuild", "-showTestPlans", "-project", project, "-scheme", scheme]
    
    do {
        try process.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: String.Encoding.utf8) {
            guard let subRange = output.range(of: "\(scheme)\":") else {
                return testPlans
            }
            
            let startIndex = output.index(after: subRange.upperBound)
            testPlans = String(output[startIndex...]).split(separator: " ").map { (subString) -> String in
                return subString.trimmingCharacters(in: CharacterSet.newlines)
            }
            return testPlans
        }
    } catch {
        print("Error")
        return testPlans
    }
    return testPlans
}

let testPlanList = getTestPlans()

//xcodebuild -showTestPlans -project HackathonSampleApp.xcodeproj -scheme HackathonSampleAppUITests
//xcodebuild test -project SnapShotExperiment.xcodeproj -scheme SnapShotExperimentUITests -testPlan SnapShotExperimentUITests
//xcodebuild -project HackathonSampleApp.xcodeproj -scheme HackathonSampleAppUITests -destination 'platform=iOS Simulator,name=iPhone 11 Pro Max,OS=13.2.2' test


func makeScreenshotDir() {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = ["mkdir", "screenshots"]
    do {
        print("--------------Making screenshots Folder--------------")
        try process.run()
        process.waitUntilExit()
    } catch  {
        print("Error while creating screenshot dir")
    }
}

func moveScreenshots() {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = ["mv", "DerivedData/Build/Products/\(CONFIGURATION)-iphonesimulator/screenshots", "."]
    do {
        print("--------------Moving screenshots--------------")
        try process.run()
        process.waitUntilExit()
    } catch  {
        print("Error while moving screenshot")
    }
}

func removeDerivedDataDir() {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = ["rm", "-r", "DerivedData"]
    do {
        print("--------------Removing DerivedData--------------")
        try process.run()
        process.waitUntilExit()
    } catch  {
        print("Error while removing  DerivedData")
    }
}

func runTest() {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    
    process.arguments = [
        "xcodebuild",
        "-project", project,
        "-scheme", projectScheme,
        "-destination", platform,
        "-testPlan", testPlanList[1],
        "-derivedDataPath", "DerivedData",
        "test"
    ]
    
    do {
        try process.run()
        process.waitUntilExit()
       // makeScreenshotDir()
        moveScreenshots()
        removeDerivedDataDir()
    } catch  {
        print("Error while testing")
    }
}
print("--------------Available Schemes--------------")
print(testPlanList)
runTest()



