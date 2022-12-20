//
//  LoginVC.swift
//  Movie App(MaharaTech)
//
//  Created by Ahmed on 11/12/2022.
//

import UIKit
import SQLite3
class LoginVC: UIViewController {
    
    
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var errorHandel: UILabel!
    @IBOutlet weak var passwordTxt: UITextField!
        
    var db : OpaquePointer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = openDB()
        //query(db: db)
        loginBtn.layer.cornerRadius = 5
        hideKeyboardWhenTappedAround()
        usernameTxt.inputAccessoryView = UIView()
        passwordTxt.inputAccessoryView = UIView()
        
    }
    
    
    func openDB() -> OpaquePointer? {

        var db : OpaquePointer?
        let fileUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension("Authentication.sqlite")
        if sqlite3_open(fileUrl?.path, &db) == SQLITE_OK{
            print("success")
            return db
        }else{
            print("failed")
            return nil
        }
        
    }
    
    
    
    func query (db:OpaquePointer?){
        let queryStatmentString = """
        
        Select * from Emails
"""
        var queryStatment : OpaquePointer?
        
        if sqlite3_prepare_v2(db,queryStatmentString, -1, &queryStatment, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatment) == SQLITE_ROW {
               
                guard let QuaryResultsCol1 = sqlite3_column_text(queryStatment, 0) else {
                    print("nulllll")
                    return
                }
                
                
                guard let QuaryResultsCol2 = sqlite3_column_text(queryStatment,1) else {
                    print("nulllll")
                    return
                }
                
                
                guard let QuaryResultsCol3 = sqlite3_column_text(queryStatment, 2) else {
                    print("nulllll")
                    return
                }
                let name = String(cString: QuaryResultsCol1)
                
                let email = String(cString: QuaryResultsCol2)
                
                let password = String(cString: QuaryResultsCol3)
                
                if usernameTxt.text == email && passwordTxt.text == password {
                   
                    let userdefults = UserDefaults.standard
                    userdefults.set(true, forKey: "loginstate")
                    
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "MovieVC") as! MoviesVC
                    VC.modalPresentationStyle = .fullScreen
                    self.present(VC, animated: true)
                    
                }else if usernameTxt.text == email && passwordTxt.text != password  {
                    errorHandel.text = "Wrong Password try again"
                }else {
                    errorHandel.text = "Account not exist"
                }
            }
 
        }else{
            print("query statment not prepared")
        }
        
        sqlite3_finalize(queryStatment)
    }
    
    
    func hideKeyboardWhenTappedAround() {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
    
    @IBAction func registerVC(_ sender: Any) {
        
       let VC = storyboard?.instantiateViewController(identifier: "RegisterVC") as! RegisterVC
       VC.modalPresentationStyle = .fullScreen
        //VC.db = self.db
        self.present(VC, animated: true)
        
        
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        if usernameTxt.text == "" || passwordTxt.text == "" {
            errorHandel.text = "Enter Username & Password"
        }else {
            errorHandel.text = ""
            query(db: db)
        }
    }
}
