import UIKit
import FirebaseFirestore
import FirebaseAuth

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBox: UISearchBar!
    
    var isSearch: Bool = false
    var hospitals: [Hospital] = []
    var SearchHospitals: [Hospital] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBox.delegate = self
        
        let  nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        
        tableView.backgroundColor = UIColor.clear

        // Fetch data from Firestore
        fetchDataFromFirestore()
    }

    func fetchDataFromFirestore() {
        let db = Firestore.firestore()

        db.collection("Hospitals").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                // Clear the existing data
                self.hospitals.removeAll()

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
                        self.hospitals.append(hospital)
                    } else {
                        print("Invalid data format for document: \(document.documentID)")
                    }
                }

                // Reload the table view to reflect the updated data
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isSearch){
            return SearchHospitals.count
        }else{
            return hospitals.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        var hospital: Hospital
        if(isSearch){
            hospital = SearchHospitals[indexPath.row]
        }
        else{
            hospital = hospitals[indexPath.row]
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = self.storyboard?.instantiateViewController(identifier: "details") as! DetailController
            vc.id = hospitals[indexPath.row].id
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            // Return the desired height for the cell at the specified indexPath
        return 207.0 // Adjust this value as needed
        }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        SearchHospitals = hospitals.filter { hospital in
                return hospital.name.lowercased().prefix(searchText.count) == searchText.lowercased()
            }
            isSearch = true
           tableView.reloadData()

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearch = false
        tableView.reloadData()
    }
    
    
    @IBAction func logoutBtn(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            
            self.view.makeToast("Logout Successful")
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                let vc = self.storyboard?.instantiateViewController(identifier: "Login") as! LoginController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
        catch let signOutError as NSError {
            self.view.makeToast("Error: \(signOutError)")
        }
        
       
    }
    
}
