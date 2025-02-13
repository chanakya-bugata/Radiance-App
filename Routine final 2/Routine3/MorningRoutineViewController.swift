//
//  MorningRoutineViewController.swift
//  Routine3
//
//  Created by user@95 on 16/11/24.
//

import UIKit

class MorningRoutineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tblList: UITableView!
  

    var morninglog: [MorningLog] = [
            MorningLog(producttype: "1. Cleanser", productsimage: UIImage(named: "cetaphil"), productdescription: "Cetaphil Gentle Skin Cleanser", time: "8:00 AM", MrnglogChecklist: false),
            MorningLog(producttype: "2. Toner", productsimage: UIImage(named: "minimalist"), productdescription: "Minimalist Glycolic Acid", time: "8:05 AM", MrnglogChecklist: false),
            MorningLog(producttype: "3. Moisturiser", productsimage: UIImage(named: "ponds"), productdescription: "Pond’s Light Moisturiser", time: "8:10 AM", MrnglogChecklist: false),
            MorningLog(producttype: "4. Sunscreen", productsimage: UIImage(named: "pondssunscreen"), productdescription: "Pond’s Serum Boost Sunscreen", time: "8:13 AM", MrnglogChecklist: false),
            MorningLog(producttype: "Add Your Pic", productsimage: UIImage(named: "addyourpic"), productdescription: "", time: "", MrnglogChecklist: false)
        ]

        override func viewDidLoad() {
            super.viewDidLoad()

            // Set background and navigation bar colors
            
            navigationController?.navigationBar.tintColor = UIColor(red: 0.949, green: 0.553, blue: 0.525, alpha: 1.0) // #F28D86
            tblList.separatorStyle = .none

            // Set up navigation bar title
            setupNavigationBar()

            // Configure table view
            tblList.delegate = self
            tblList.dataSource = self
            tblList.register(UINib(nibName: "MorningRoutineTableViewCell", bundle: nil), forCellReuseIdentifier: "MorningRoutineCell")
                
                // Add spacing between cells
            tblList.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0) // Adjust top and bottom as needed
            tblList.separatorStyle = .none
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 109 // Increased height for better spacing
        }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12 // Spacing between rows
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0) // Adjust insets
    }

        func setupNavigationBar() {
            // Set the title
            navigationItem.title = "Morning Routine"

            // Customize title font and color
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 28),
                .foregroundColor: UIColor(hex: "#3E4040") // Custom dark color
            ]
            navigationController?.navigationBar.titleTextAttributes = attributes
        }

        // MARK: - TableView DataSource and Delegate Methods

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return morninglog.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MorningRoutineCell", for: indexPath) as? MorningRoutineTableViewCell else {
                return UITableViewCell()
            }

            let log = morninglog[indexPath.row]
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = UIColor(hex: "#ECECEC")
            cell.contentView.layer.cornerRadius = 12   // Rounded corners
            cell.contentView.layer.masksToBounds = true
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.borderWidth = 0


            if log.producttype == "Add Your Pic" {
                cell.producttype.text = log.producttype
                cell.productdetail.text = "" // No description
                cell.time.text = ""

                // Set image with corner radius
                cell.productimage.image = log.productsimage
                cell.productimage.layer.cornerRadius = 10
                cell.productimage.layer.masksToBounds = true

                // Hide checkbox entirely
                cell.btnCheckmark.isHidden = true

                // Make image tappable
                cell.productimage.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cameraTapped))
                cell.productimage.addGestureRecognizer(tapGesture)
            } else {
                // For regular product rows
                cell.producttype.text = log.producttype
                cell.productdetail.text = log.productdescription
                cell.productimage.image = log.productsimage
                cell.time.text = log.time
                cell.btnCheckmark.isHidden = false

                // Configure checkmark
                let imageName = log.MrnglogChecklist ? "checkmark" : "unchecked"
                cell.btnCheckmark.setImage(UIImage(named: imageName), for: .normal)
                cell.btnCheckmark.tag = indexPath.row
                cell.btnCheckmark.addTarget(self, action: #selector(checkmarkTapped(_:)), for: .touchUpInside)
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
                if let index = morninglog.firstIndex(where: { $0.producttype == "Add Your Pic" }) {
                    morninglog[index].productsimage = selectedImage
                    tblList.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                }
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }

        @objc func checkmarkTapped(_ sender: UIButton) {
            let index = sender.tag
            morninglog[index].MrnglogChecklist.toggle()
            
            // Check if all checkboxes are selected
            if morninglog.allSatisfy({ $0.MrnglogChecklist }) {
                // If all checkboxes are selected, set the first item as checked
                morninglog[0].MrnglogChecklist = true
                tblList.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            }
            
            tblList.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
