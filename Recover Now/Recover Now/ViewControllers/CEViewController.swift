//
//  CEViewController.swift
//  True Pass
//
//  Created by Cliff Panos on 8/9/17.
//  Copyright © 2017 Clifford Panos. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func showSimpleAlert(_ title: String, message: String?, handler: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {_ in handler?() })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    public func showOptionsAlert(_ title: String?, message: String?, left: String, right: String, handlerOne: (() -> Void)? = nil, handlerTwo: (() -> Void)? = nil) {
        
        let rightStyle = style(right)   //Two actions CANNOT have the .cancel style. Only one can.
        let leftStyle = rightStyle == .cancel ? .default : style(left)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let left = UIAlertAction(title: left, style: leftStyle, handler: { _ in handlerOne?() })
        let right = UIAlertAction(title: right, style: rightStyle, handler: {_ in handlerTwo?() })
        alert.addAction(left)
        alert.addAction(right)
        
        self.present(alert, animated: true)
    }
    
    public func showDestructiveAlert(_ title: String, message: String?, destructiveTitle destructive: String, popoverSetup:((UIPopoverPresentationController) -> Void)?, withStyle style: UIAlertControllerStyle, forDestruction completionHandler: @escaping (UIAlertAction) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let destructiveAction = UIAlertAction(title: destructive, style: .destructive, handler:
            completionHandler)
        
        alert.addAction(cancelAction)
        alert.addAction(destructiveAction)
        
        self.setupPopoverPresentation(for: alert, popoverSetup: popoverSetup)
        
        self.present(alert, animated: true)
    }
    
    //MARK: - Popover helper methods
    
    public func setupPopoverPresentation(for popup: UIViewController, popoverSetup: ((UIPopoverPresentationController) -> Void)?) {
        
        if let presented = popup.popoverPresentationController, let setup = popoverSetup {
            print("PopoverPresentationController activated")
            setup(presented)
        }
        
    }
    
    //THE UIAlertStyle ".cancel" causes the action's text to be bold
    internal func style(_ actionString: String) -> UIAlertActionStyle {
        let boldTypes = ["OK", "Ok", "Cancel", "Settings", "Done", "Yes"]
        return boldTypes.contains(actionString) ? .cancel : .default
    }

}
