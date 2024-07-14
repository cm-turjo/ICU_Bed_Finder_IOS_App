//
//  SignupController.swift
//  ICU Bed Finder
//
//  Created by Abdulla Rahman on 16/11/23.
//

import FirebaseAuth
import Toast_Swift
import UIKit
class SignupController : UIViewController, UITextFieldDelegate {
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var labelError: UILabel!
    
    
    @IBOutlet weak var inputPassword: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        labelError.isHidden = true

    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        let email:String? = inputEmail.text
        let password:String? = inputPassword.text
        let confirm:String? = confirmPassword.text
        
        if((email!.isEmpty) || (password!.isEmpty) || (confirm!.isEmpty)){
            labelError.text = "All Field Required"
            labelError.isHidden = false
        }
        
        else if(!(password!==confirm!)){
            labelError.text = "Password didn't match"
            labelError.isHidden = false
        }
        
        else {
            Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
                if let error = error {
                    self.labelError.text = error.localizedDescription
                    self.labelError.isHidden = false
                }
                else{
                    self.view.makeToast("Sign Up Successfull")
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.0){
                        self.goLoginPage()
                    }
                }
            }
            
        }
    }
    
    func goLoginPage(){
        let vc = storyboard?.instantiateViewController(identifier: "Login") as! LoginController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func goTologin(_ sender: Any) {
        goLoginPage()
    }
}
