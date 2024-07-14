//
//  ViewController.swift
//  ICU Bed Finder
//
//  Created by Abdulla Rahman on 16/11/23.
//

import UIKit
import FirebaseAuth
import Toast_Swift

class LoginController: UIViewController {

    @IBOutlet weak var labelError: UILabel!
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelError.isHidden = true
        // Do any additional setup after loading the view.
        
    }

    @IBAction func didTapLogin(_ sender: Any) {
        let email:String? = inputEmail.text
        let password:String? = inputPassword.text
        
        if((email!.isEmpty) || (password!.isEmpty)){
            labelError.text = "All Field Required"
            labelError.isHidden = false
        }
        
        
        else {
            
            Auth.auth().signIn(withEmail: email!, password: password!) { (authResult, error) in
                if let error = error {
                    self.labelError.text = error.localizedDescription
                    self.labelError.isHidden = false
                }
                else{
                    self.view.makeToast("Login Successfull")
                    DispatchQueue.main.asyncAfter(deadline: .now()+1){
                        let vc = self.storyboard?.instantiateViewController(identifier: "Home") as! HomeController
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func goToReg(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "Signup") as! SignupController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    @IBAction func goToAdmin(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AdminLogin") as! AdminLoginController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
