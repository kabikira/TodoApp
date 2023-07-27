//
//  FirebaseUserManager.swift
//  TodoApp
//
//  Created by koala panda on 2023/07/27.
//

import Firebase

struct FirebaseUserManager {
    var id: String
    var name: String

    init(doc: DocumentSnapshot) {
        self.id = doc.documentID
        let data = doc.data()
        if let name = data?["name"] as? String {
            self.name = name
        } else {
            self.name = ""
        }
    }
    static func registerUserToAuthentication(email: String, password: String) async throws -> Firebase.User {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            return result.user
        }
    static func createUserToFirestore(userId: String, userName: String) async throws {
            try await Firestore.firestore().collection("users").document(userId).setData(["name": userName])
        }
    static func loginUserToAuthentication(email: String, password: String) async throws {
            try await Auth.auth().signIn(withEmail: email, password: password)
        }
    static func getUserDataForFirestore() async throws -> FirebaseUserManager {
            guard let currentUser = Auth.auth().currentUser else {
                throw NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "No current user"])
            }
        let snapshot = try await Firestore.firestore().collection("users").document(currentUser.uid).getDocument()
                return FirebaseUserManager(doc: snapshot)
            }
}
