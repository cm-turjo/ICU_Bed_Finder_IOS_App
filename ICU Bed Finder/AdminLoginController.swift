//
//  AdminLoginController.swift
//  ICU Bed Finder
//
//  Created by Abdulla Rahman on 23/11/23.
//

import UIKit

class AdminLoginController: UIViewController {

    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var labelError: UILabel!
    @IBOutlet weak var inputPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        labelError.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func checkLogin(_ sender: Any) {
        let email:String? = inputEmail.text
        let password:String? = inputPassword.text
        
        if((email!.isEmpty) || (password!.isEmpty)){
            labelError.text = "All Field Required"
            labelError.isHidden = false
        }
        
        else{
            if(email=="Admin" && password=="123"){
                self.view.makeToast("Login Successfull")
                DispatchQueue.main.asyncAfter(deadline: .now()+1){
                    let vc = self.storyboard?.instantiateViewController(identifier: "Dashboard") as! DashboardController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }
            
            else{
                labelError.text = "Invalid Request"
                labelError.isHidden = false
                
                self.view.makeToast("Logout Successfull")
                DispatchQueue.main.asyncAfter(deadline: .now()+1){
                    let vc = self.storyboard?.instantiateViewController(identifier: "Login") as! LoginController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
                
            }
        }
        
    }
    
    @IBAction func goToUserLogin(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "Login") as! LoginController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
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
