//
//  Validation.swift
//  Medbrain
//
//  Created by Simon Anreiter on 10/04/16.
//  Copyright © 2016 anreiter.simon. All rights reserved.
//

import Foundation

protocol Validator {
    func validate() throws -> Bool
}

enum GroupValidatorError: ErrorType {
    case ChildValidatorsFailed(errors :[ErrorType])
}

class GroupValidator: NSObject, Validator {

    var validators = [Validator]()

    func validate() throws -> Bool {
        var valid = true

        var aggregateErrors = [ErrorType]()

        validators.forEach { (childValidator) in
            do {
                let childIsValid = try childValidator.validate()
                valid = valid && childIsValid
            } catch {
                aggregateErrors.append(error)
            }
        }

        if aggregateErrors.count > 0 {
            throw GroupValidatorError.ChildValidatorsFailed(errors: aggregateErrors)
        }

        return valid
    }

}
