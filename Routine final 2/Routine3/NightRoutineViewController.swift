//
//  NightRoutineViewController.swift
//  Routine3
//
//  Created by user@95 on 16/11/24.
//

import UIKit

class NightRoutineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tbllist2: UITableView!
    
    var nightlog: [NightLog] = [
        NightLog(producttype: "1. Cleanser", productsimage: UIImage(named: "cetaphil"), productdescription: "Cetaphil Gentle Skin Cleanser", time: "9:00 PM", MrnglogChecklist: false),
        NightLog(producttype: "2. Toner", productsimage: UIImage(named: "minimalist"), productdescription: "Minimalist Glycolic Acid", time: "9:05 PM", MrnglogChecklist: false),
        NightLog(producttype: "3. Moisturiser", productsimage: UIImage(named: "ponds"), productdescription: "Pond’s Light Moisturiser", time: "9:10 PM", MrnglogChecklist: false),
        NightLog(producttype: "4. Sunscreen", productsimage: UIImage(named: "pondssunscreen"), productdescription: "Pond’s Serum Boost Sunscreen", time: "9:13 PM", MrnglogChecklist: false),
        NightLog(producttype: "Add Your Pic", productsimage: UIImage(named: "addyourpic"), productdescription: "", time: "", MrnglogChecklist: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background color
        
        
        navigationController?.navigationBar.tintColor = UIColor(red: 0.949, green: 0.553, blue: 0.525, alpha: 1.0) // Equivalent to #F28D86
        tbllist2.separatorStyle = .none
        tbllist2.backgroundColor = UIColor.white
        
        
        // Set up navigation bar title
        setupNavigationBar()
        
        // Set up table view
        tbllist2.delegate = self
        tbllist2.dataSource = self
        tbllist2.register(UINib(nibName: "NightRoutineTableViewCell", bundle: nil), forCellReuseIdentifier: "NightRoutineCell")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109 // Increased height for better spacing
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10 // Spacing between rows
    }
    
    func setupNavigationBar() {
        // Set the title
        navigationItem.title = "Night Routine"
        
        // Customize title font and color
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 28),
            .foregroundColor: UIColor(hex: "#3E4040") // Custom dark color
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    // MARK: - TableView DataSource and Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nightlog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NightRoutineCell", for: indexPath) as? NightRoutineTableViewCell else {
            return UITableViewCell()
        }
        
        let log = nightlog[indexPath.row]
        
        // Set cell background color to clear
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = UIColor(hex: "#ECECEC")
        cell.contentView.layer.cornerRadius = 12   // Rounded corners
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.borderWidth = 0
        
        
        if log.producttype == "Add Your Pic" {
            cell.producttype2.text = log.producttype
            cell.productdetails2.text = "" // No description
            cell.time2.text = ""
            
            // Set image with corner radius
            cell.productimage2.image = log.productsimage
            cell.productimage2.layer.cornerRadius = 10
            cell.productimage2.layer.masksToBounds = true
            
            // Hide checkbox entirely
            cell.checkbox2.isHidden = true
            
            // Make image tappable
            cell.productimage2.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cameraTapped))
            cell.productimage2.addGestureRecognizer(tapGesture)
        } else {
            // For regular product rows
            cell.producttype2.text = log.producttype
            cell.productdetails2.text = log.productdescription
            cell.productimage2.image = log.productsimage
            cell.time2.text = log.time
            cell.checkbox2.isHidden = false
            
            // Configure checkmark
            let imageName = log.MrnglogChecklist ? "checkmark" : "unchecked"
            cell.checkbox2.setImage(UIImage(named: imageName), for: .normal)
            cell.checkbox2.tag = indexPath.row
            cell.checkbox2.addTarget(self, action: #selector(checkmarkTapped(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    
    @objc func cameraTapped() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            // Show an alert if the camera is not available
            let alert = UIAlertController(title: "Error", message: "Camera not available.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
            return
        }
        
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let selectedImage = info[.originalImage] as? UIImage {
            // Update the "Add Your Pic" row with the captured image
            if let index = nightlog.firstIndex(where: { $0.producttype == "Add Your Pic" }) {
                nightlog[index].productsimage = selectedImage
                tbllist2.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func checkmarkTapped(_ sender: UIButton) {
        let index = sender.tag
        nightlog[index].MrnglogChecklist.toggle()
        tbllist2.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    @objc private func submitTapped() {
        if let checkinVC = navigationController?.viewControllers.first(where: { $0 is CheckinViewController }) {
            navigationController?.popToViewController(checkinVC, animated: true)
        } else {
            let checkinVC = CheckinViewController()
            navigationController?.setViewControllers([checkinVC], animated: true)
        }
    }
}
