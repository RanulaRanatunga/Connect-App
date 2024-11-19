//
//  ViewController.swift
//  ConnectApp
//
//  Created by Ranula Ranatunga on 2024-11-18.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
 
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkRememberedUser()
    }
    
    
    private func setupUI() {
            emailTextField.layer.cornerRadius = 8
            emailTextField.layer.borderWidth = 1
            emailTextField.layer.borderColor = UIColor.gray.cgColor
            emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: emailTextField.frame.height))
            emailTextField.leftViewMode = .always
            
            passwordTextField.layer.cornerRadius = 8
            passwordTextField.layer.borderWidth = 1
            passwordTextField.layer.borderColor = UIColor.gray.cgColor
            passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: passwordTextField.frame.height))
            passwordTextField.leftViewMode = .always
            passwordTextField.isSecureTextEntry = true
            
            // Configure login button
            loginButton.layer.cornerRadius = 8
            loginButton.backgroundColor = .systemBlue
        }
    
    private func checkRememberedUser() {
        if defaults.bool(forKey: "RememberMe") {
            emailTextField.text = defaults.string(forKey: "SavedEmail")
            passwordTextField.text = defaults.string(forKey: "SavedPassword")
            rememberMeSwitch.isOn = true
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter both email and password")
            return
        }
        
        
        
        
        // Show loading indicator
                let spinner = UIActivityIndicatorView(style: .medium)
                spinner.center = view.center
                view.addSubview(spinner)
                spinner.startAnimating()
                
                // Firebase authentication
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                    guard let self = self else { return }
                    
                    DispatchQueue.main.async {
                        spinner.stopAnimating()
                        spinner.removeFromSuperview()
                        
                        if let error = error {
                            self.showAlert(message: error.localizedDescription)
                            return
                        }
                        
                        // Handle remember me
                        if self.rememberMeSwitch.isOn {
                        self.defaults.set(true, forKey: "RememberMe")
                        self.defaults.set(email, forKey: "SavedEmail")
                        self.defaults.set(password, forKey: "SavedPassword")
                        } else {
                            self.defaults.set(false, forKey: "RememberMe")
                            self.defaults.removeObject(forKey: "SavedEmail")
                            self.defaults.removeObject(forKey: "SavedPassword")
                                        }
                                        
                            // Navigate to main screen
                            self.performSegue(withIdentifier: "LoginToMain", sender: nil)
                                    }
                                }
                            }
    
    private func showAlert(message: String) {
            let alert = UIAlertController(title: "ALERT", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }


}

