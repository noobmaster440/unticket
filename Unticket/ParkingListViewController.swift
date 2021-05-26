
import UIKit
import FirebaseFirestore

class ParkingListViewController: UITableViewController{
    let db=Firestore.firestore()
    var finalList:[parking]=[]
    func destButtonPressed(at indexPath: IndexPath) {
        
    }
    var ID:String=UserDefaults.standard.string(forKey: "ID")!
    
    var address="NA"
    var time="NA"
    var carplate="NA"
    
    @IBOutlet weak var parkingTable: UITableView!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("chichden 65 1``23")
        parkingTable.rowHeight=350
        self.parkingTable.dataSource=self
        self.parkingTable.delegate=self
        finalList.removeAll()
        db.collection("parking").whereField("user_id", isEqualTo: ID).getDocuments {
            (queryResults, error) in
            if let err = error {
                print("Error getting documents from visitor collection")
                print(err)
                return
                //
            }
            else {
                // we were successful in getting the documents
                if (queryResults!.count == 0) {
                    print("No parking found")
                }
                else {
                    // we found some results, so let's output it to the screen
                    for result in queryResults!.documents {
                        do {
                            let parkingRetrieved = try result.data(as: parking.self)
                            // add the task to the tasklist
                            self.finalList.append(parkingRetrieved!)
                            print("Successfully converted to a parking object")
                            print(parkingRetrieved)
                        } catch {
                            print(error)
                        }
                        print(result.documentID)
                    }
                    print("Number of parkings in array: \(self.finalList.count)")
                    self.tableView.reloadData()
                    print("test 67")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        print("chicken 65")
        super.viewDidLoad()
    }
    
    
}

extension ParkingListViewController{
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.finalList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "parkingcell123") as? EachParking
        if (cell == nil) {
            cell = EachParking(
                style: UITableViewCell.CellStyle.default,
                reuseIdentifier: "parkingcell123")
        }
        
//        cell?.delegate=self
        cell?.index=indexPath
        let parkedspot = self.finalList[indexPath.row]
        cell?.carplatenumber.text=parkedspot.license
        cell?.time.text=parkedspot.date_time
        cell?.address.text=parkedspot.street
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped the row")
        guard let s3 = storyboard?.instantiateViewController(identifier: "parkingdetail") as? ParkingDetailViewController else{
            print("Cannot find the detailed screen")
            return
        }
        s3.finalList=finalList
        s3.index=indexPath
        show(s3,sender: self)
    }
}

