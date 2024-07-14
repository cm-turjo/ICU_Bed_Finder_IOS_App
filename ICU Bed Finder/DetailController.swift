//
//  DetailController.swift
//  ICU Bed Finder
//
//  Created by Abdulla Rahman on 26/11/23.
//

import UIKit
import  FirebaseFirestore


class DetailController: UIViewController {
    
    let db = Firestore.firestore().collection("Hospitals")
    var location:String = ""
    
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblPostalCode: UILabel!
    @IBOutlet weak var lblStreet: UILabel!
    @IBOutlet weak var lblTotalBed: UILabel!
    @IBOutlet weak var lblAvailableBed: UILabel!
    @IBOutlet weak var lblname: UILabel!
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
                            
                            self.location = district

                            let hospital = Hospital(
                                name: name,
                                totalBed: totalBed,
                                availableBed: availableBed,
                                street: street,
                                district: district,
                                postalCode: postalCode,
                                contact: contact
                            )
                            
                            self.lblname.text = hospital.name
                            self.lblTotalBed.text = String(hospital.totalBed)
                            self.lblAvailableBed.text = String(hospital.availableBed)
                            self.lblStreet.text = hospital.street + "," + hospital.district

                            self.lblPostalCode.text = String(hospital.postalCode)
                            self.lblContact.text = String(hospital.contact)


                        } else {
                            print("Invalid data format for document with ID: \(document.documentID)")
                        }
                    } else {
                        print("Document with ID \(did) does not exist")
                    }
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "Home") as! HomeController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func showWeather(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "Weather") as! WeatherController
        vc.location = location
        vc.id = id!
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
}
