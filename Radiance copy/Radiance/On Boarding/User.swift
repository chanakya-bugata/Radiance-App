//
//  User.swift
//  Radiance
//
//  Created by admin12 on 15/12/24.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore

class User {
    // Singleton instance
    static let shared = User()

    // Properties to store user data
    var name: String?
    var age: Int?
    var gender: String?
    var skinConcerns: [String] = []
    var skinTypes: [String] = []
    var skinGoals: [String] = []

    // Private initializer to prevent creating multiple instances
    private init() {}

    // Method to save user data to Firebase (you can modify this as needed)
    func saveToFirebase() {
        guard let email = Auth.auth().currentUser?.email else { return }
        let userRef = Firestore.firestore().collection("users").document(email)

        let data: [String: Any] = [
            "name": name ?? "",
            "age": age ?? 0,
            "gender": gender ?? "",
            "skinConcerns": skinConcerns,
            "skinTypes": skinTypes,
            "skinGoals": skinGoals,
            "createdAt": FieldValue.serverTimestamp()
        ]

        userRef.setData(data, merge: true) { error in
            if let error = error {
                print("Error saving data: \(error.localizedDescription)")
            } else {
                print("User data successfully saved to Firebase.")
            }
        }
    }
}
