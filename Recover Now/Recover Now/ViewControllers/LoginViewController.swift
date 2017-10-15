//
//  LoginViewController.swift
//  Recover-Now
//
//  Created by Cliff Panos on 10/14/17.
//  Copyright © 2017 Clifford Panos. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: ManagedViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var primaryView: UIView!
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var loginTitle: UILabel!
    
    var textFieldSelected: Bool = false
    var textFieldManager: CPTextFieldManager!
    let feedbackGenerator = UINotificationFeedbackGenerator()
    
    static var preFilledEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldManager = CPTextFieldManager(textFields: [emailTextField, passwordTextField], in: self)
        textFieldManager.setupTextFields(withAccessory: .done)
        textFieldManager.setFinalReturn(keyType: .go) {
            self.signInPressed(Int(0))
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNeedsStatusBarAppearanceUpdate()
        passwordTextField.text = ""
        if let email = LoginViewController.preFilledEmail {
            emailTextField.text = email
            LoginViewController.preFilledEmail = nil
            passwordTextField.becomeFirstResponder()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Check to see if an information controller or version update controller should be shown
        /*let firstLaunchedEver = C.getFromUserDefaults(withKey: Shared.FIRST_LAUNCH_OF_APP_EVER) as? Bool ?? true
        if firstLaunchedEver {
            //self.performSegue(withIdentifier: "toTruePassInfo", sender: nil)
            C.persistUsingUserDefaults(false, forKey: Shared.FIRST_LAUNCH_OF_APP_EVER)
        }*/
    }
    
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        let url = URL(string: "http://www.recovernowapp.com")!
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        self.present(safariVC, animated: true, completion: nil)
    }
    
    
    
    //MARK: Sign-in & Account Creation ------------------------------------------ :
    @IBAction func signInPressed(_ sender: Any) {
        
        feedbackGenerator.prepare()
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces),
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces) else {
                self.showSimpleAlert("Incomplete Fields", message: "Surprise! You need to enter both an email and a password to log in.")
                return
        }
        
        Accounts.shared.standardLogin(withEmail: email, password: password, completion: { success in
            if success {
                
                //CHECK TO SEE IF EMAIL IS VERIFIED
                /*if let current = Accounts.shared.current, !current.isEmailVerified {
                    self.showOptionsAlert("Email Not Yet Verified", message: "For your security, you must verify your email address before logging into your account", left: "Send Email Again", right: "OK", handlerOne: {
                        current.sendEmailVerification(completion: { error in
                            if let error = error {
                                self.showSimpleAlert("Error While Resending Email", message: error.localizedDescription)
                            } else {
                                self.showSimpleAlert("Verification Email Sent", message: nil)
                            }
                        })
                    })
                    self.feedbackGenerator.notificationOccurred(.warning)
                    
                    return // ! -- CRITICAL -- !//
                }*/
                
                let newUserService = FirebaseService(entity: "RNUser")
                
                newUserService.retrieveData(forIdentifier: Accounts.shared.current!.uid) { object in
                    let newUser = object as! RNUser
                    Accounts.saveToUserDefaults(user: newUser, updateImage: true)
                    
                    //At this point, the user is about to be logged in
                    self.feedbackGenerator.notificationOccurred(.success)
                    self.loginTitle.text = "Success"
                    self.animateOff()
                }
                
            } else {
                self.shakeTextFields()
                self.feedbackGenerator.notificationOccurred(.error)
            }
        })

    }
    
    
    
    
    @IBAction func newAccount(_ sender: Any) {
        print("fill in this code to make a new account")
        //let vc = C.storyboard.instantiateViewController(withIdentifier: "newAccountViewController")
        self.view.endEditing(true)
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    //MARK: - Animations ---------------------- :
    
    func shakeTextFields() {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = 3
        animation.duration = 0.08
        animation.autoreverses = true
        animation.byValue = 9 //how much it moves
        self.passwordTextField.layer.add(animation, forKey: "position")
        self.emailTextField.layer.add(animation, forKey: "position")
    }
    
    override func keyboardWillShow(notification: Notification) {
        
        guard !textFieldSelected else { return }
        
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.68, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
            
            self.primaryView.transform = CGAffineTransform(translationX: 0, y: -75)
            
        }, completion: {_ in self.textFieldSelected = true })
    }
    
    override func keyboardWillHide(notification: Notification) {
        
        guard textFieldSelected else { return }
        
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.68, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
            
            self.primaryView.transform = CGAffineTransform(translationX: 0, y: 0)
            
        }, completion: {_ in self.textFieldSelected = false })
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func animateOff() {
        
        dismissKeyboard()
        
        UIView.animate(withDuration: 0.7, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.5, options: .curveEaseOut, animations: {
            
            self.primaryView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            self.titleStackView.transform = CGAffineTransform(translationX: 0, y: -150)
            
        }, completion: {_ in
            self.textFieldSelected = false

            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyBoard.instantiateInitialViewController() as! UITabBarController
            
            let appDelegate = UIApplication.shared.delegate
            appDelegate!.window!?.rootViewController = tabBarController
            
            tabBarController.selectedIndex = 0

            
        })
        
    }

}
