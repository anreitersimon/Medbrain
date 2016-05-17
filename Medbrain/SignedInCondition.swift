//
//  SignedInCondition.swift
//  Medbrain
//
//  Created by Simon Anreiter on 10/04/16.
//  Copyright © 2016 anreiter.simon. All rights reserved.
//

import Foundation
import Operations
import SMART


class SignInController {
    static let sharedSignInController: SignInController = SignInController()
    
    var patient: Patient?
    
    let server = Server(base: "http://fhir2.healthintersections.com.au/open/")
}

enum SignedInConditionError: ErrorType {
    case NotSignedIn
}

struct SignedInCondition: OperationCondition {
    
    let name = "SignedInCondition"
    let isMutuallyExclusive = true
    
    weak var presentationContext: PresentationContext?
    
    init(presentationContext: PresentationContext?) {
        self.presentationContext = presentationContext
    }
    
    
    func dependencyForOperation(operation: Operation) -> NSOperation? {
        return  SignInOperation(presentationContext: presentationContext)
    }
    
    func evaluateForOperation(operation: Operation, completion: OperationConditionResult -> Void) {
        
        let result: OperationConditionResult
        
        if let _ = SignInController.sharedSignInController.patient {
            result = .Satisfied
        } else {
            result = .Failed( SignedInConditionError.NotSignedIn)
        }
        
        //R.color
        
        completion(result)
    }
}


class SignInOperation: Operation {
    
    weak var presentationContext: PresentationContext?
    
    init(presentationContext context: PresentationContext? = nil ) {
        self.presentationContext = context
    }
    
    override func execute() {
        guard SignInController.sharedSignInController.patient == nil else {
            finish()
            return
        }
        
        let signInController = R.storyboard.signIn.signInViewController()!
        
        signInController.completionHandler = {
            $0.dismissViewControllerAnimated(true, completion: {
                self.finish()
            })
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            
            presentViewController(inPresentationContext: self.presentationContext, viewControllerToPresent: signInController, animated: true, completion: nil)
        }
        
    }
}
