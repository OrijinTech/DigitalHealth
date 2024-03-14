//
//  UserService.swift
//  DH_App
//
//  Created by Yongxiang Jin on 3/11/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserService {
    @Published var currentUser: User?
    
    static let sharedUser = UserService()
    
    @MainActor
    func fetchCurrentUserData() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await Firestore.firestore().collection(Collection().user).document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        self.currentUser = user
        
        print("NOTICE: CURRENT USER IS FETCHED, THE USER IS \(String(describing: currentUser))")
        
    }
    
}
