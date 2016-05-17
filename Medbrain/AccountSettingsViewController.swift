//
//  AccountSettingsViewController.swift
//  Medbrain
//
//  Created by Simon Anreiter on 13/04/16.
//  Copyright © 2016 anreiter.simon. All rights reserved.
//

import UIKit
import SMART

class AccountSettingsViewController: UIViewController {
    
    var user :Patient? {
        didSet {
            updateViewHierarchy()
        }
    }
    
    
    
    func updateViewHierarchy() {
        let views = stackView.arrangedSubviews
        
        views.forEach {
           stackView.removeArrangedSubview($0)
        }
        
        let createLabel :(text :String?)->Void = {
            guard let text = $0 else {
                return
            }
            let l = UILabel(frame: CGRect.zero)
            l.translatesAutoresizingMaskIntoConstraints = false
            l.text = text
            
            self.stackView.addArrangedSubview(l)
        }
        
        guard let patient = user else {
            
            createLabel(text: "Not logged in")
            return
        }
        
        createLabel(text:  patient.name?.first?.text)
        createLabel(text:  patient.telecom?.first?.value)
        
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.user = SignInController.sharedSignInController.patient
    }
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
