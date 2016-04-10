//
//  SignInViewController.swift
//  Medbrain
//
//  Created by Simon Anreiter on 10/04/16.
//  Copyright © 2016 anreiter.simon. All rights reserved.
//

import UIKit
import SMART

class SignInViewController: UIViewController {

    var completionHandler :((controller: SignInViewController)->Void)?

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


        Patient.search(["name": "Henry"]).perform(server) {  [weak self] (bundle, error) in

            guard let strongSelf = self else {
                return
            }

            let patients = bundle?.entry?
                .filter() { return $0.resource is Patient }
                .map() { return $0.resource as! Patient }


            if let patient = patients?.first {

                SignInController.sharedSignInController.patient = patient

                strongSelf.completionHandler?(controller: strongSelf)
            } else {
                strongSelf.submitButton.alpha = 1
                strongSelf.activityIndicator.stopAnimating()
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
