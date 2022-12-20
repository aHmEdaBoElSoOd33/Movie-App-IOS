//
//  RegisterVC.swift
//  Movie App(MaharaTech)
//
//  Created by Ahmed on 20/12/2022.
//

import UIKit
import SQLite3


class RegisterVC: UIViewController {
    
    
    
   @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    var db : OpaquePointer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = openDB()
        createTable(db: db)
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
    
    
    
    
    func createTable(db:OpaquePointer?){
        let createTableString = """
        CREATE TABLE Emails (name CHAR(255) ,
        Email CHAR(255),
        Password Char(255));
        """
        
        var createTableStatment : OpaquePointer?
        
        
        if sqlite3_prepare(db, createTableString, -1,&createTableStatment, nil) == SQLITE_OK {
            
            if sqlite3_step(createTableStatment) == SQLITE_DONE{
                
                print("Table created")
                
            }else{
                
                print("Table Not created")
            }
            
            
        }else{
            print("Create table statment is not prepared")
        }
        
        sqlite3_finalize(createTableStatment)
        
    }
    
    func insertIntoDB (Name:NSString,Email:NSString,Password:NSString,db:OpaquePointer?){
        
        let insertStatmentString = """
        INSERT INTO Emails (Name,Email,Password) values (?,?,?);
"""
        var insertStatment : OpaquePointer?
        
        
        if sqlite3_prepare_v2(db, insertStatmentString, -1, &insertStatment, nil) == SQLITE_OK {
            
            sqlite3_bind_text(insertStatment, 1, Name.utf8String, -1, nil)
        sqlite3_bind_text(insertStatment, 2, Email.utf8String, -1, nil)
            sqlite3_bind_text(insertStatment, 3, Password.utf8String, -1, nil)
            if sqlite3_step(insertStatment) == SQLITE_DONE {
                print("insert done")
                
            }else {
               
                print("Not inserted")
            }
            //query(db: self.db)
            
        }else{
            print("insert Statment not prepared ")
            
        }
        
           sqlite3_finalize(insertStatment)
    }
    
    
    
    @IBAction func savedataRegistration(_ sender: Any) {
       
        if nameTxt.text == "" {
            print("Enter name")
        }else if emailTxt.text == ""{
            print("Enter email")
        }else if passwordTxt.text == ""{
            print("Enter password")
        }else{
            insertIntoDB(Name: nameTxt.text! as NSString, Email: emailTxt.text! as NSString, Password: passwordTxt.text! as NSString, db: db)
        }
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
    
}
