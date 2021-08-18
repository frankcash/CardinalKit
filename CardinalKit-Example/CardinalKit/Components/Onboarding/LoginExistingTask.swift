//
//  LoginExistingTask.swift
//  CardinalKit_Example
//
//  Created by Vishnu Ravi on 8/18/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import ResearchKit
import CardinalKit

public var LoginExistingTask: ORKOrderedTask {
    
    let config = CKPropertyReader(file: "CKConfiguration")
    
    var loginSteps: [ORKStep]
    
    if config["Login-Sign-In-With-Apple"]["Enabled"] as? Bool == true {
        let signInWithAppleStep = CKSignInWithAppleStep(identifier: "SignExistingInWithApple")
        loginSteps = [signInWithAppleStep]
    } else {
        let loginStep = ORKLoginStep(identifier: "LoginExistingStep", title: "Login", text: "Log into this study.", loginViewControllerClass: LoginViewController.self)
        
        loginSteps = [loginStep]
    }
    
    // use the `ORKPasscodeStep` from ResearchKit.
    let passcodeStep = ORKPasscodeStep(identifier: "Passcode") //NOTE: requires NSFaceIDUsageDescription in info.plist
    let type = config.read(query: "Passcode Type")
    if type == "6" {
        passcodeStep.passcodeType = .type6Digit
    } else {
        passcodeStep.passcodeType = .type4Digit
    }
    passcodeStep.text = config.read(query: "Passcode Text")
    
    loginSteps += [passcodeStep]
    
    // create a task with each step
    let orderedTask = ORKOrderedTask(identifier: "StudyLoginTask", steps: loginSteps)
    
    // & present the VC!
    return orderedTask
    
}
