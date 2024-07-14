//
//  DashboardController.swift
//  ICU Bed Finder
//
//  Created by Abdulla Rahman on 23/11/23.
//

import UIKit
import FirebaseFirestore

class DashboardController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var DataTable: UITableView!
    var hospitalInfo: [Hospital] = []
    var SearchHospitals: [Hospital] = []
    var isSearch: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataTable.dataSource = self
        DataTable.delegate = self
        searchBar.delegate = self
        
        let  nib = UINib(nibName: "TableViewCell", bundle: nil)
        DataTable.register(nib, forCellReuseIdentifier: "TableViewCell")
        fetchDataFromFirestore()
        DataTable.reloadData()
    }
    
    func fetchDataFromFirestore() {
        let db = Firestore.firestore()

        db.collection("Hospitals").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                // Clear the existing data
                self.hospitalInfo.removeAll()

                // Loop through the documents and populate the hospitals array
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    let did = document.documentID

                    // Assuming you have a Hospital initializer that requires parameters
                    if let name = data["name"] as? String,
                       let totalBed = data["totalBed"] as? Int,
                       let availableBed = data["availableBed"] as? Int,
                       let street = data["street"] as? String,
                       let district = data["district"] as? String,
                       let postalCode = data["postalCode"] as? Int,
                       let contact = data["contact"] as? Int {
                       
                        let hospital = Hospital(
                            name: name,
                            totalBed: totalBed,
                            availableBed: availableBed,
                            street: street,
                            district: district,
                            postalCode: postalCode,
                            contact: contact
                        )
                        hospital.id = did
                        self.hospitalInfo.append(hospital)
                    } else {
                        print("Invalid data format for document: \(document.documentID)")
                    }
                }

                // Reload the table view to reflect the updated data
                self.DataTable.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isSearch){
            return SearchHospitals.count
        }else{
            return hospitalInfo.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        var hospital: Hospital
        if(isSearch){
            hospital = SearchHospitals[indexPath.row]
        }
        else{
            hospital = hospitalInfo[indexPath.row]
        }
        cell.district.text = hospital.district
        cell.name.text = hospital.name
        cell.AvailableBeds.text = "Available Beds: " + String(hospital.availableBed)
        

        cell.layer.masksToBounds = true

        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowRadius = 4.0
        cell.layer.masksToBounds = false

        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            // Return the desired height for the cell at the specified indexPath
        return 207.0 // Adjust this value as needed
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "Modify") as! ModifyController
        vc.id = hospitalInfo[indexPath.row].id
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] _, _ in
                self?.removeCell(at: indexPath)
            }
            return [deleteAction]
        }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        SearchHospitals = hospitalInfo.filter { hospital in
                return hospital.name.lowercased().prefix(searchText.count) == searchText.lowercased()
            }
           isSearch = true
           DataTable.reloadData()

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearch = false
        DataTable.reloadData()
    }
    
    
    func removeCell(at indexPath: IndexPath) {
            // Step 1: Remove data from your data source
        let docRef = Firestore.firestore().collection("Hospitals").document(hospitalInfo[indexPath.row].id)
            docRef.delete { error in
                if let error = error {
                    print("Error deleting document: \(error)")
                } else {
                    print("Document successfully deleted")
                }
            }
            hospitalInfo.remove(at: indexPath.row)

            // Step 2: Perform UITableView animation to visually swap the cell
            DataTable.beginUpdates()
            DataTable.deleteRows(at: [indexPath], with: .automatic)

            // Step 3: Update the table view by reloading or removing the last row
            if indexPath.row < hospitalInfo.count {
                // Swap with the last cell
                let lastIndexPath = IndexPath(row: hospitalInfo.count, section: 0)
                DataTable.reloadRows(at: [lastIndexPath], with: .automatic)
            } else {
                // Remove the last cell
                DataTable.deleteRows(at: [IndexPath(row: hospitalInfo.count, section: 0)], with: .automatic)
            }
            //let documentID = hospitalInfo#imageLiteral(resourceName: "simulator_screenshot_216FE5FE-D704-409C-B394-5E14A0EE671F.png")[indexPath.row].id
           
            DataTable.endUpdates()
    }


    @IBAction func addNew(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AddNew") as! AddNewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    @IBAction func AdminLogout(_ sender: Any) {
        self.view.makeToast("Logout Successfull")
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            let vc = self.storyboard?.instantiateViewController(identifier: "Login") as! LoginController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
}
