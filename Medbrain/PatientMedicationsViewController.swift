//
//  PatientMedicationsViewController.swift
//  Medbrain
//
//  Created by Simon Anreiter on 10/04/16.
//  Copyright © 2016 anreiter.simon. All rights reserved.
//

import UIKit
import Operations

class PatientMedicationsViewController: UIViewController {

    lazy var queue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)


        let op = BlockOperation {
            print("blaaa")
        }

        op.addCondition(SignedInCondition(presentationContext: self))

        queue.addOperation(op)
    }

}
