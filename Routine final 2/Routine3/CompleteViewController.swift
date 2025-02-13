import UIKit

class CompleteViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var tableviewCR: UITableView!
    
    @IBOutlet weak var tableviewCR2: UITableView!
    
    
 
    var selectedDate: Date?
    var completeLogCR: [CompleteLogCR] = [
        CompleteLogCR(producttypeCR: "1. Cleanser", productsimageCR: UIImage(named: "cetaphil"), productdescriptionCR: "Cetaphil Gentle Skin Cleanser", timeCR: "9:00 PM", checklistCheckedCR: false),
        CompleteLogCR(producttypeCR: "2. Toner", productsimageCR: UIImage(named: "minimalist"), productdescriptionCR: "Minimalist Glycolic Acid", timeCR: "9:05 PM", checklistCheckedCR: false),
        CompleteLogCR(producttypeCR: "3. Moisturiser", productsimageCR: UIImage(named: "ponds"), productdescriptionCR: "Pond’s Light Moisturiser", timeCR: "9:10 PM", checklistCheckedCR: false),
        CompleteLogCR(producttypeCR: "4. Sunscreen", productsimageCR: UIImage(named: "pondssunscreen"), productdescriptionCR: "Pond’s Serum Boost Sunscreen", timeCR: "9:13 PM", checklistCheckedCR: false)
    ]
    
    var completeLogCR2: [CompleteLogCR2] = [
        CompleteLogCR2(producttypeCR2: "1. Cleanser", productsimageCR2: UIImage(named: "cetaphil"), productdescriptionCR2: "Cetaphil Gentle Skin Cleanser", timeCR2: "9:00 PM", checklistCheckedCR2: false),
        CompleteLogCR2(producttypeCR2: "2. Toner", productsimageCR2: UIImage(named: "minimalist"), productdescriptionCR2: "Minimalist Glycolic Acid", timeCR2: "9:05 PM", checklistCheckedCR2: false),
        CompleteLogCR2(producttypeCR2: "3. Moisturiser", productsimageCR2: UIImage(named: "ponds"), productdescriptionCR2: "Pond’s Light Moisturiser", timeCR2: "9:10 PM", checklistCheckedCR2: false),
        CompleteLogCR2(producttypeCR2: "4. Sunscreen", productsimageCR2: UIImage(named: "pondssunscreen"), productdescriptionCR2: "Pond’s Serum Boost Sunscreen", timeCR2: "9:13 PM", checklistCheckedCR2: false)
    ]
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up table views
        tableviewCR.delegate = self
        tableviewCR.dataSource = self
        
        tableviewCR2.delegate = self
        tableviewCR2.dataSource = self
        navigationController?.navigationBar.tintColor = UIColor(red: 0.949, green: 0.553, blue: 0.525, alpha: 1.0) // #F28D86
        tableviewCR.separatorStyle = .none
        tableviewCR2.separatorStyle = .none
        
        self.title = "Routine"
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(red: 62/255, green: 64/255, blue: 64/255, alpha: 1.0),
                .font: UIFont.boldSystemFont(ofSize: 28)
            ]
            navigationController?.navigationBar.titleTextAttributes = titleTextAttributes



        // Format the selected date for display
        if let date = selectedDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateLabel.text = "\(dateFormatter.string(from: date))"
        } else {
            dateLabel.text = "No Date Selected"
        }
        
        // Register custom table view cells
        tableviewCR.register(UINib(nibName: "completeRoutine1TableViewCell", bundle: nil), forCellReuseIdentifier: "completeRoutine1Cell")
        tableviewCR2.register(UINib(nibName: "completeRoutine2TableViewCell", bundle: nil), forCellReuseIdentifier: "completeRoutine2Cell")
    }
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableviewCR {
            return completeLogCR.count
        } else if tableView == tableviewCR2 {
            return completeLogCR2.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableviewCR {
            // Configure tableviewCR
            let cell = tableView.dequeueReusableCell(withIdentifier: "completeRoutine1Cell", for: indexPath) as! completeRoutine1TableViewCell
            let log = completeLogCR[indexPath.row]
            cell.configureCell(with: log)
            
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = UIColor(hex: "#ECECEC")
            cell.contentView.layer.cornerRadius = 12   // Rounded corners
            cell.contentView.layer.masksToBounds = true
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.borderWidth = 0
            
            return cell
        } else if tableView == tableviewCR2 {
            // Configure tableviewCR2
            let cell = tableView.dequeueReusableCell(withIdentifier: "completeRoutine2Cell", for: indexPath) as! completeRoutine2TableViewCell
            let log = completeLogCR2[indexPath.row]
            cell.configure(with: log)
            

            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = UIColor(hex: "#ECECEC")
            cell.contentView.layer.cornerRadius = 12   // Rounded corners
            cell.contentView.layer.masksToBounds = true
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.borderWidth = 0
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: - Checkbox Toggle Actions
    @objc func toggleCheckboxCR(sender: UIButton) {
        let index = sender.tag
        completeLogCR[index].checklistCheckedCR.toggle()
        tableviewCR.reloadData()
    }
    
    @objc func toggleCheckboxCR2(sender: UIButton) {
        let index = sender.tag
        completeLogCR2[index].checklistCheckedCR2.toggle()
        tableviewCR2.reloadData()
    }
}
