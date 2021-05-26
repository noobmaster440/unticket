
import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
    let db=Firestore.firestore()
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var appIcon: UIImageView!
    
    @IBAction func signInBtn(_ sender: Any) {
        let passwordEntered=password.text!
        let emailEntered = email.text!
        
        db.collection("visitor").getDocuments {
            (queryResults, error) in
            if let err = error {
                print("Error getting documents from visitor collection")
                print(err)
                return
            }
            else {
                // we were successful in getting the documents
                if (queryResults!.count == 0) {
                    print("No users found")
                }
                else {
                    // we found some results, so let's output it to the screen
                    var isFound=false
                    for result in queryResults!.documents {
                        print(result.documentID)
                        // output the contents of that documents
                        let row = result.data()
                        if (row["email"] as? String)==emailEntered{
                            isFound=true
                            if (row["password"] as? String)==passwordEntered{
                                print("User Found")
                                UserDefaults.standard.set(result.documentID, forKey: "ID")
                                print("user found2")
                                guard let listParking = self.storyboard?.instantiateViewController(identifier: "profiletab")  else {
                                    print("Cannot find Parking List!")
                                    return
                                }
//                                let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                                //
                                //                                 let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "parkingtab")
                                //                                 appDelegate.window?.rootViewController = initialViewController
                                //                                 appDelegate.window?.makeKeyAndVisible()
//                                self.performSegue(withIdentifier: "successLogin", sender: nil)
                                
                                self.show(listParking, sender: self)
                                break
                            }else{
                                print("Incorrect password")
                                let alert = UIAlertController(title: "Login Unsuccessful", message: "Incorrect password. Try again!", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                break
                            }
                            
                        }
                    }
                    if !isFound{
                        let alert = UIAlertController(title: "Login Unsuccessful", message: "Incorrect email. Try again!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        appIcon?.image=UIImage(named: "appicon")
        
    }
    
    
}

