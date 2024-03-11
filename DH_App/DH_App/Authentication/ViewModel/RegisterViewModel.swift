//
//  RegisterViewModel.swift
//  DH_App
//
//  Created by Yongxiang Jin on 3/10/24.
//

import Foundation


class RegisterViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    @Published var privacy = false
    @Published var conditions = false
    
    // TODO: CREATE LOCAL USER OBJECT
//    @Published var User
    
    
    
    func createUser() async throws {
        try await AuthServices.sharedAuth.createUser(withEmail: email, password: password, username: username)
    }
    
    
}

