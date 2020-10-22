#!/usr/bin/env swift

import Foundation

// MARK: - SimulatorManager
struct SimulatorManager: Codable {
    let repository: DeviceRepository
    
    enum CodingKeys: String, CodingKey {
        case repository = "devices"
    }
}

struct DeviceRepository: Codable {
    var devices: [Device]
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        var tempArray = [Device]()

        for key in container.allKeys {
            var deviceType = "unknown"
            
            if key.stringValue.contains("iOS") {
                deviceType = "iOS"
            } else if key.stringValue.contains("watchOS") {
                deviceType = "watchOS"
            } else if key.stringValue.contains("tvOS") {
                deviceType = "tvOS"
            }
            
            let devices = try container.decode([Device].self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            
            tempArray += devices.map { (device) -> Device in
                var deviceTemp = device
                deviceTemp.type = deviceType
                return deviceTemp
            }
        }
        devices = tempArray
    }
}

//enum DeviceType: Codable {
//    case ios, tvOS, watchOS
//}

// MARK: - Device
struct Device: Codable {
    let state: State
    let isAvailable: Bool
    let name, udid: String
    var type: String?
}

enum State: String, Codable {
    case shutdown = "Shutdown"
}

let scheme = "HackathonSampleAppUITests"
let projectScheme = "HackathonSampleApp"
let project = "HackathonSampleApp.xcodeproj"
let platform = "platform=iOS Simulator,name=iPhone 11 Pro Max,OS=13.2.2"
let CONFIGURATION = "Debug"

func getTestPlans() -> [String] {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
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

//xcrun simctl list devices --json -v
func getAvailableDevices() -> [Device] {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    let pipe = Pipe()
    process.standardOutput = pipe
    process.arguments = ["xcrun", "simctl", "list", "devices", "--json", "-v"]
    
    do {
        try process.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let jsonDecoder = JSONDecoder()
        let devices = try jsonDecoder.decode(SimulatorManager.self, from: data).repository.devices
        //print("Devices: \(devices)")
        return devices
        
    } catch {
        print("Error")
        return []
    }
}


let devices = getAvailableDevices()

func runTest() {
    print("Started Capturing Screenshots....")
    let testPlanList = getTestPlans()
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    
    //Select only one iOS simulator to run on
    let simulator = devices.filter { (device) in
        if let type = device.type {
            return type == "iOS"
        }
        return false
    }.first
    
    guard let availableSimulator = simulator else {
        print("Unable to find simulator.")
        return
    }
    
    print("Availabel simulator: \(availableSimulator.name)")
    
    let destination = "platform=iOS Simulator,name=\(availableSimulator.name)"
    
    process.arguments = [
        "xcodebuild",
        "-project", project,
        "-scheme", projectScheme,
        "-destination", destination,
        "-testPlan", testPlanList[2],
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


for argument in CommandLine.arguments {
    if argument == "./script.swift" {
        continue
    }
    
    switch argument {
    case "screenshot":
        print("--------------Capturing Screenshot--------------")
        runTest()
    case "availableSimulators":
        let sims = getAvailableDevices().map { (device) in
            return device.name
        }
        print(sims)
    case "showTestPlans":
        print(getTestPlans())
    case "-help":
        print("Usage: ./script.swift [screenshot | availableSimulators | showTestPlans]")
    default:
        print("./script.swift: error: invalid option '\(argument)'")
        print("Usage: ./script.swift [screenshot | availableSimulators | showTestPlans]")
        exit(0)
    }
}

//print(testPlanList)
//runTest()





