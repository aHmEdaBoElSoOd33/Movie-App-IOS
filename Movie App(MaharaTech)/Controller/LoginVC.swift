//
//  LoginVC.swift
//  Movie App(MaharaTech)
//
//  Created by Ahmed on 11/12/2022.
//

import UIKit

class LoginVC: UIViewController {
    
    
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var errorHandel: UILabel!
    @IBOutlet weak var passwordTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loginBtn.layer.cornerRadius = 5
        hideKeyboardWhenTappedAround()
        usernameTxt.inputAccessoryView = UIView()
        passwordTxt.inputAccessoryView = UIView()
    }
    
    
    func hideKeyboardWhenTappedAround() {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
    

    @IBAction func loginBtnAction(_ sender: Any) {
        
        if usernameTxt.text == "ahmed@gmail.com" && passwordTxt.text == "111111" {
            
            let userdefults = UserDefaults.standard
            userdefults.set(true, forKey: "loginstate")
    
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "MovieVC") as! MoviesVC
            VC.modalPresentationStyle = .fullScreen
           self.present(VC, animated: true)
        }else if usernameTxt.text == "" && passwordTxt.text == "" {
            errorHandel.text = "Enter Username & Password"
        }else{
            errorHandel.text = "Username or Password is Wrong , Try Again"
        }
        
    }
}
