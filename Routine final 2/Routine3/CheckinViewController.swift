//
//  CheckinViewController.swift
//  Routine3
//
//  Created by user@95 on 16/11/24.
//

import UIKit

class CheckinViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var RoutineCollectionView: UICollectionView!
       
    
    func updateRoutineCheckbox(at index: Int, isCompleted: Bool) {
        guard routines.indices.contains(index) else { return }
        routines[index].iscompleted = isCompleted
        
        // Reload the specific item in the collection view
        RoutineCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }

 
 let sectionHeaders = ["Routine", "Log"]

    var routines: [Routine] = [
        Routine(image: UIImage(named: "mrngroutine"), title: "   Morning", subtitle: "not done", iscompleted: false),
        Routine(image: UIImage(named: "nightroutine"), title: "   Night", subtitle: "not done", iscompleted: false),
        Routine(image: UIImage(named: "mrnglog"), title: "   Morning", subtitle: "not done", iscompleted: false),
        Routine(image: UIImage(named: "nightlog"), title: "   Night", subtitle: "not done", iscompleted: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        RoutineCollectionView.dataSource = self
        RoutineCollectionView.delegate = self
        RoutineCollectionView.reloadData()
    }

    // MARK: - UICollectionView DataSource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionHeaders.count // Two sections: Routine and Log
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 2 : 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoutineCollectionViewCell", for: indexPath) as! RoutineCollectionViewCell
        
        let routineItem = routines[indexPath.section * 2 + indexPath.item]
        cell.setup(with: routineItem) // Provide the Routine object to the cell
        
        return cell
    }

    // MARK: - Section Header View
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderView", for: indexPath) as! SectionHeaderView
            headerView.title = sectionHeaders[indexPath.section]
            return headerView
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let routineItem = routines[indexPath.section * 2 + indexPath.item]

        // Navigate to the appropriate view controller based on the routine title
        switch routineItem.title {
        case "   Morning" where indexPath.section == 0:
            if let morningRoutineVC = storyboard?.instantiateViewController(withIdentifier: "MorningRoutineViewController") {
                navigationController?.pushViewController(morningRoutineVC, animated: true)
            }
        case "   Night" where indexPath.section == 0:
            if let nightRoutineVC = storyboard?.instantiateViewController(withIdentifier: "NightRoutineViewController") {
                navigationController?.pushViewController(nightRoutineVC, animated: true)
            }
        case "   Morning" where indexPath.section == 1:
            if let morningLogVC = storyboard?.instantiateViewController(withIdentifier: "MorningLogViewController") {
                navigationController?.pushViewController(morningLogVC, animated: true)
            }
        case "   Night" where indexPath.section == 1:
            if let nightLogVC = storyboard?.instantiateViewController(withIdentifier: "NightLogViewController") {
                navigationController?.pushViewController(nightLogVC, animated: true)
            }
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CheckinViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 25) // Header height
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5 // Vertical spacing between items
    }
    
    

}
