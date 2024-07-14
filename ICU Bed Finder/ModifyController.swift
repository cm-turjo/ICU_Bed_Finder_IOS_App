//
//  ModifyController.swift
//  ICU Bed Finder
//
//  Created by Abdulla Rahman on 24/11/23.
//

import UIKit
import  Firebase

class ModifyController: UIViewController {

    @IBOutlet weak var labelError: UILabel!
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var inputTotalBed: UITextField!
    @IBOutlet weak var inputStreet: UITextField!
    @IBOutlet weak var inputAvailableBed: UITextField!
    @IBOutlet weak var inputDistrict: UITextField!
    @IBOutlet weak var inputPostal: UITextField!
    @IBOutlet weak var inputContact: UITextField!
    
    
    let db = Firestore.firestore().collection("Hospitals")
    var id: String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        if let did = id {
            let docRef = db.document(did)
            docRef.getDocument { (document, error) in
                if let error = error {
                    print("Error getting document: \(error)")
                } else {
                    if let document = document, document.exists {
                        // Access the document data
                        let data = document.data()
                        // Assuming you have a Hospital initializer that requires parameters
                        if let name = data?["name"] as? String,
                           let totalBed = data?["totalBed"] as? Int,
                           let availableBed = data?["availableBed"] as? Int,
                           let street = data?["street"] as? String,
                           let district = data?["district"] as? String,
                           let postalCode = data?["postalCode"] as? Int,
                           let contact = data?["contact"] as? Int {

                            let hospital = Hospital(
                                name: name,
                                totalBed: totalBed,
                                availableBed: availableBed,
                                street: street,
                                district: district,
                                postalCode: postalCode,
                                contact: contact
                            )
                            
                            self.inputName.text = hospital.name
                            self.inputTotalBed.text = String(hospital.totalBed)
                            self.inputAvailableBed.text = String(hospital.availableBed)
                            self.inputStreet.text = hospital.street
                            self.inputDistrict.text = hospital.district
                            self.inputPostal.text = String(hospital.postalCode)
                            self.inputContact.text = String(hospital.contact)

                        } else {
                            print("Invalid data format for document with ID: \(document.documentID)")
                        }
                    } else {
                        print("Document with ID \(did) does not exist")
                    }
                }
            }
        }
        labelError.isHidden = true
    }
    

    @IBAction func btnUpdate(_ sender: Any) {
        
        let docRef = Firestore.firestore().collection("Hospitals").document(id!)
        let name = inputName.text
        let totalBed = (Int)(inputTotalBed.text!)
        let availableBed = (Int)(inputAvailableBed.text!)
        let street = inputStreet.text
        let district = inputDistrict.text
        let contact = (Int)(inputContact.text!)
        let postalCode = (Int)(inputPostal.text!)
        
        let hospitalData: [String: Any] = [
                "name": name!,
                "totalBed": totalBed!,
                "availableBed": availableBed!,
                "street": street!,
                "district": district!,
                "contact": contact!,
                "postalCode": postalCode!
            ]
        
        docRef.updateData(hospitalData) { error in
            if let error = error {
                self.view.makeToast("Error updating data: \(error)")
            } else {
                self.view.makeToast("Data updated successfully")
                DispatchQueue.main.asyncAfter(deadline: .now()+1){
                    let vc = self.storyboard?.instantiateViewController(identifier: "Dashboard") as! DashboardController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }
        }
    }
    

    @IBAction func goToDashboard(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "Dashboard") as! DashboardController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
