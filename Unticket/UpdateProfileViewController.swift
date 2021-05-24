//
//  UpdateProfileViewController.swift
//  Unticket
//
//  Created by user187860 on 5/24/21.
//

import UIKit
import FirebaseFirestore

class UpdateProfileViewController: UIViewController {
    
    let db=Firestore.firestore()
    
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtContact: UITextField!
    @IBOutlet weak var txtCarPlateNumber: UITextField!
    
    
    @IBOutlet weak var errorText: UILabel!
    
    var password:String = ""
    var userId = ""
    
    func fetchUser(documentId: String){
      let docRef = db.collection("visitor").document(documentId)
      docRef.getDocument { document, error in
        if let error = error as NSError? {
            self.errorText.text = "Error getting document: \(error.localizedDescription)"
        }
        else {
          if let document = document {
            do {
                let row = document.data()
                self.txtName.text = row?["name"] as! String
                self.txtEmail.text = row?["email"] as! String
                self.txtContact.text = row?["contactNo"] as! String
                self.txtCarPlateNumber.text = row?["carplate"] as! String
                self.password = row?["password"] as! String
                
            }
            catch {
              print(error)
            }
          }
        }
      }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userId = UserDefaults.standard.string(forKey: "ID")!
        fetchUser(documentId: userId)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func deleteAccountPressed(_ sender: Any) {
        
        db.collection("visitor").document(userId).delete() { (error) in
            if let err = error {
                self.errorText.text = "Error when updating document"
                print(err)
                return
            }
            else {
                self.errorText.text = "Details deleted successfully"
                guard let loginPage = self.storyboard?.instantiateViewController(identifier: "login_page") as? ViewController else {
                            print("Cannot find Login  Page!")
                            return
                        }
                        self.show(loginPage, sender: self)
            }
        }
        
        
    }
    
    
    @IBAction func updateAccountPressed(_ sender: Any) {
        
        let carPlateNo=txtCarPlateNumber.text!
        let email=txtEmail.text!
        let contactNo=txtContact.text!
        let name=txtName.text!
        
        //         optional, but helpful
        if (carPlateNo.isEmpty || email.isEmpty || contactNo.isEmpty || password.isEmpty || name.isEmpty) {
            self.errorText.text = "You must enter all the information"
            return
        }
        //         2. add it to firebase
        let visitor = [
            "name":name,
            "email":email,
            "contactNo":contactNo,
            "password":password,
            "carplate":carPlateNo,
            
        ]
        
        db.collection("visitor").document(userId).updateData(visitor) { (error) in
            if let err = error {
                self.errorText.text = "Error when updating document"
                print(err)
                return
            }
            else {
                self.errorText.text = "Details updated successfully"
                
            }
        }
        
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
