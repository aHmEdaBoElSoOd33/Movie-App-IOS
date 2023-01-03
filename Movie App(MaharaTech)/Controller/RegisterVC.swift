//
//  RegisterVC.swift
//  Movie App(MaharaTech)
//
//  Created by Ahmed on 20/12/2022.
//

import UIKit
import SQLite3


class RegisterVC: UIViewController {
    
    
    @IBOutlet weak var errorHandel: UILabel!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var savedataRegistration: UIButton!
    var existEmail : String?
    var db : OpaquePointer?
    var alldata : [String] = []
    var datasource : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = openDB()
        savedataRegistration.layer.cornerRadius = 5
        createTable(db: db)
        //deleteFromDB(db: db)
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
                
                datasource.append(email)
                if datasource.contains("\(emailTxt.text!)"){
                    existEmail = "exist"
                    continue
                }else{
                    existEmail = "not exist"
                    datasource.append("\(emailTxt.text)")
                }
            }
            
            
        }else{
            print("query statment not prepared")
        }
        
        sqlite3_finalize(queryStatment)
    }
    
    
    
    func deleteFromDB(db:OpaquePointer?) {
        let deleteStatmentString = """
        delete  from Emails
"""
        var deleteStatment : OpaquePointer?
        if sqlite3_prepare_v2(db, deleteStatmentString, -1, &deleteStatment, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatment) == SQLITE_DONE {
                print("DELETED")
            }else{
                print("NOOT")
            }
        }else{
            print("not prepersd")
        }
        sqlite3_finalize(deleteStatment)
        
    }
    
    @IBAction func savedataRegistration(_ sender: Any) {
        if nameTxt.text == "" {
               errorHandel.text = "Enter Name"
           }else if emailTxt.text == ""{
               errorHandel.text = "Enter Email"
           }else if passwordTxt.text == ""{
               errorHandel.text = "Enter Password"
           }else{
               errorHandel.text = ""
               query(db: db)
              
               if existEmail == "exist" {
                   errorHandel.text = "There is an account with that email , try another one "
               }else{
                   insertIntoDB(Name: nameTxt.text! as NSString, Email: emailTxt.text! as NSString, Password: passwordTxt.text! as NSString, db: self.db)
               }
               
              
               print(datasource)
               print(datasource.count)
               //print(datasource)
           }
       
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
    
}
