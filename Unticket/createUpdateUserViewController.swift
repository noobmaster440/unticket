import UIKit
import FirebaseFirestore
class createUpdateUserViewController: UIViewController {
    
    
    @IBOutlet weak var tname: UITextField!
    
    @IBOutlet weak var tcarPlateNo: UITextField!
    @IBOutlet weak var tcontactNo: UITextField!
    @IBOutlet weak var temail: UITextField!
    @IBOutlet weak var tpassword: UITextField!
    let db=Firestore.firestore()
    
    
    @IBAction func createBtn(_ sender: Any) {
        
        //reading
        db.collection("visitor").getDocuments {
            (queryResults, error) in
            if let err = error {
                print("Error getting documents from student collection")
                print(err)
                return
            }
            else {
                // we were successful in getting the documents
                if (queryResults!.count == 0) {
                    print("No results found")
                }
                else {
                    // we found some results, so let's output it to the screen
                    for result in queryResults!.documents {
                        // output the primary key (id) of the documents
                        print(result.documentID)
                        // output the contents of that documents
                        let row = result.data()
                        print("The name is \(row["name"]), and age is: \(row["age"])")
                        print(result.data())
                    }
                }
            }
        }
        
        
        // writing
        let carPlateNo=tcarPlateNo.text!
        let email=temail.text!
        let contactNo=tcontactNo.text!
        let password=tpassword.text!
        let name=tname.text!
        
        //         optional, but helpful
        if (carPlateNo.isEmpty || email.isEmpty || contactNo.isEmpty || password.isEmpty || name.isEmpty) {
            print("You must enter all the information")
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
        
        db.collection("visitor").addDocument(data: visitor) { (error) in
            if let err = error {
                print("Error when saving document")
                print(err)
                return
            }
            else {
                print("document saved successfully")
                self.tcarPlateNo.text = ""
                self.tcontactNo.text = ""
                self.tpassword.text = ""
                self.temail.text = ""
                self.tname.text = ""
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
