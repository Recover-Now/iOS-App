//
//  CPTextFieldManager.swift
//  True Pass
//
//  Created by Cliff Panos on 6/28/17.
//  Copyright © 2017 Clifford Panos. All rights reserved.
//

import UIKit

class CPTextFieldManager: NSObject, UITextFieldDelegate {
    
    var textFields: [UITextField]
    unowned var viewController: UIViewController
    var unselectedTextColor: UIColor?
    var selectedTextColor: UIColor?
    var finalReturnAction: (() -> Void)?
    internal var tapToDismiss: Bool = false {   //Internal because it does not yet work
        didSet {
            if (tapToDismiss) {
                print("Added Tap Gesture Recognizer")
                viewController.view.addGestureRecognizer(tapGestureRecognizer)
            } else {
                print("Removed Tap Gesture Recognizer")
                viewController.view.removeGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    var selectedTextField: UITextField?
    var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    
    
    init?(textFields: [UITextField], in viewController: UIViewController) {
        //Once initialized, the CPTextFieldManager instance should be retained as a property in the UIViewController class that holds the UITextFields.
        
        if textFields.count == 0 { return nil }
        
        self.textFields = textFields
        self.viewController = viewController
    }
    
    func setupTextFields(withAccessory accessoryViewStyle: CPTextFieldManagerAccessoryViewStyle = .none) {
                
        individualSetup: for textField in textFields {
            
            textField.delegate = self
            
            textField.returnKeyType = .next
            
            
            if accessoryViewStyle == .none { continue individualSetup }
            
            if UIDevice.current.userInterfaceIdiom == .pad && textField.inputView == nil { continue individualSetup }
            
            let numberToolbar: UIToolbar = UIToolbar()
            numberToolbar.barStyle = UIBarStyle.default
            
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
            let done = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(dismissKeyboard))
            
            let textInputAccessories = [flexibleSpace, done]
            
            numberToolbar.items = textInputAccessories
            numberToolbar.sizeToFit()
            textField.inputAccessoryView = numberToolbar
            
        } //End for loop for setting up each individual textField's inputAccessoryView and delegate
        
    }
    
    func setFinalReturn(keyType: UIReturnKeyType, action: (() -> Void)? = nil) {
        textFields.last!.returnKeyType = keyType
        self.finalReturnAction = action
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textFields.last {
            finalReturnAction?()
            dismissKeyboard()
            return true
        }
        
        guard let currentIndex = textFields.index(of: textField) else { return true }
        let nextTextField = textFields[currentIndex + 1]
        nextTextField.becomeFirstResponder()
        
        //let indexPath = IndexPath(row: 0, section: 2)
        //tableView.scrollToRow(at: indexPath, at: .middle, animated: true)

        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
        textField.textColor = selectedTextColor ?? textField.textColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor = unselectedTextColor ?? textField.textColor
    }
    
    func goToFirst() {
        textFields.first!.becomeFirstResponder()
    }
    
    func goToLast() {
        textFields.last!.becomeFirstResponder()
    }
    
    @objc func dismissKeyboard() {
        self.viewController.view.endEditing(true)
    }

}

enum CPTextFieldManagerAccessoryViewStyle: Int {

    case none
    case done
    case upDownArrows
    case doneAndArrows
    
}
