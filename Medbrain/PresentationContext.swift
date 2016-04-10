//
//  PresentationContext.swift
//  Medbrain
//
//  Created by Simon Anreiter on 10/04/16.
//  Copyright © 2016 anreiter.simon. All rights reserved.
//

import UIKit

protocol PresentationContext: NSObjectProtocol {
    func showViewController(vc: UIViewController, sender: AnyObject?)
    func showDetailViewController(vc: UIViewController, sender: AnyObject?)
    func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

extension UIViewController :PresentationContext {
}


func showViewController(inPresentationContext context: PresentationContext?, viewController: UIViewController, sender: AnyObject?) {

    let ctx = context ?? UIApplication.sharedApplication().keyWindow?.rootViewController

    ctx?.showViewController(viewController, sender: sender)

}

func showDetailViewController(inPresentationContext context: PresentationContext?, viewController: UIViewController, sender: AnyObject?) {

    let ctx = context ?? UIApplication.sharedApplication().keyWindow?.rootViewController

    ctx?.showDetailViewController(viewController, sender: sender)
}

func presentViewController(inPresentationContext context: PresentationContext?, viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {

    let ctx = context ?? UIApplication.sharedApplication().keyWindow?.rootViewController

    ctx?.presentViewController(viewControllerToPresent, animated: flag, completion: completion)
}
