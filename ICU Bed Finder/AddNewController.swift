//
//  AddNewController.swift
//  ICU Bed Finder
//
//  Created by Abdulla Rahman on 23/11/23.
//

import FirebaseFirestore
import UIKit

class AddNewController: UIViewController {
    @IBOutlet weak var labelError: UILabel!
    
    @IBOutlet weak var inputName: UITextField!
    
    @IBOutlet weak var inputTotalBed: UITextField!
    @IBOutlet weak var inputContact: UITextField!
    @IBOutlet weak var inputPostal: UITextField!
    @IBOutlet weak var inputDistrict: UITextField!
    @IBOutlet weak var inputStreet: UITextField!
    @IBOutlet weak var inputAvailableBed: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        labelError.isHidden = true
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnSubmit(_ sender: Any) {
        let name:String? = inputName.text
        let total:String? = inputTotalBed.text
        let available:String? = inputAvailableBed.text
        let contact:String? = inputContact.text
        let district:String? = inputDistrict.text
        let postal:String? = inputPostal.text
        let street:String? = inputStreet.text
        
        
        
        
        if((name!.isEmpty) || (total!.isEmpty)||(available!.isEmpty) || (contact!.isEmpty)||(postal!.isEmpty) || (district!.isEmpty)||(street!.isEmpty)){
            
                labelError.text = "All Field Required"
                labelError.isHidden = false
        }
        
        else{
            //if totalbed and available integer or not
            if let totalValue = Int(total!) {
                if(totalValue>0){
                    if let availableValue = Int(available!) {
                        if(availableValue>=0){
                            if(availableValue<=totalValue){
                                if let postalValue = Int(postal!){
                                    if let contactValue = Int(contact!){
                                        
                                        
                                        
                                        //validation complete
                                        //now add to firestore
                                        let hospitalData = Hospital(name: name!, totalBed: totalValue, availableBed: availableValue, street: street!, district: district!, postalCode: postalValue, contact: contactValue)
                                        
                                        
                                        //print(hospitalData.dictionaryRepresentation)
                                        
                                        
                                        Firestore.firestore().collection("Hospitals").addDocument(data: hospitalData.dictionaryRepresentation) {error in
                                            
                                            if let error = error {
                                                
                                                self.view.makeToast("Error: \(error)")
                                            }
                                            else{
                                                self.view.makeToast("Data added Successfully")
                                                //go to dashboard
                                                //do some delay for toast show
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now()+1.0){
                                                    let vc = self.storyboard?.instantiateViewController(identifier: "Dashboard") as! DashboardController
                                                    vc.modalPresentationStyle = .fullScreen
                                                    self.present(vc, animated: true)
                                                }
                                                
                                            }
                                        }
                                        
                                    }
                                    else{
                                        labelError.text = "Contact number is invalid"
                                        labelError.isHidden = false
                                    }
                                }
                                else{
                                    labelError.text = "Postal Code is invalid"
                                    labelError.isHidden = false
                                }
                                
                            }
                            else{
                                labelError.text="Available bed can't be more than total bed"
                                labelError.isHidden = false
                            }
                        }
                        else{
                            labelError.text = "Availble bed value can't be negative"
                            labelError.isHidden = false
                        }
                    }
                    else{
                        labelError.text = "Availale Bed value must be an integer"
                        labelError.isHidden = false
                    }
                }
                else{
                    labelError.text = "Total Bed must be greater than 0"
                    labelError.isHidden = false
                }
            }
            else{
                labelError.text = "Total Bed must be an integer"
                labelError.isHidden = false
            }
        }
        
    }
    
    @IBAction func goToDashboard(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "Dashboard") as! DashboardController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
}
