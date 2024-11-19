//
//  SignupVC.swift
//  ConnectApp
//
//  Created by Ranula Ranatunga on 2024-11-18.
//

import UIKit
import FirebaseAuth

class SignupVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBAction func signupButton(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text,
              !email.isEmpty,
              !password.isEmpty else {
            showAlert(message: "Please fill all fields")
            return
        }
        
        
        guard password == confirmPassword else {
                    showAlert(message: "Passwords do not match")
                    return
                }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                    if let error = error {
                        self?.showAlert(message: error.localizedDescription)
                        return
                    }
             
                    let alert = UIAlertController(title: "Success", message: "Account created successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { _ in
                        self?.navigationController?.popViewController(animated: true)
                    }))
                    self?.present(alert, animated: true)
                }
    }
    
    func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let loginVC = LoginVC()
        navigationController?.pushViewController(loginVC, animated: true)
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
