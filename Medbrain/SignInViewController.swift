//
//  SignInViewController.swift
//  Medbrain
//
//  Created by Simon Anreiter on 10/04/16.
//  Copyright © 2016 anreiter.simon. All rights reserved.
//

import UIKit
import SMART
import Operations

extension Queue {
    func perform(block: () -> Void) {
        dispatch_async(self.queue, block)
    }
}

class SignInViewController: UIViewController {
    var completionHandler: ((controller: SignInViewController) -> Void)?

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Einloggen"

        // Do any additional setup after loading the view.
    }

    @IBAction func submitPressed(sender: AnyObject) {
        submitButton.alpha = 0
        activityIndicator.startAnimating()

        let server = SignInController.sharedSignInController.server

        Patient.search(["_id": ["$exact": "f001"]]).perform(server) { [weak self](bundle, error) in

            guard let strongSelf = self else {
                return
            }

            guard error == nil else {
                Queue.Main.perform {
                    strongSelf.submitButton.alpha = 1
                    strongSelf.activityIndicator.stopAnimating()

                    let alert = UIAlertController(title: "Error while signing in", message: nil, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))

                    strongSelf.presentViewController(alert, animated: true, completion: nil)
                }
                return
            }

            let patients = bundle?.entry?
                .filter() { return $0.resource is Patient }
                .map() { return $0.resource as! Patient }

            let ids = patients?.map() { $0.id }

            print(ids)
            // print(identifierss)

            if let patient = patients?.first {
                SignInController.sharedSignInController.patient = patient

                strongSelf.completionHandler?(controller: strongSelf)
            } else {
                strongSelf.submitButton.alpha = 1
                strongSelf.activityIndicator.stopAnimating()
            }
        }
    }
}
