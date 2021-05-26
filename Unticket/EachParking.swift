
import UIKit

class EachParking: UITableViewCell {
    
    @IBOutlet weak var carplatenumber: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var address: UITextField!
    
//    var delegate:parkCellDelegate?
    var index:IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//protocol parkCellDelegate {
//    func destButtonPressed(at indexPath:IndexPath)
//}
