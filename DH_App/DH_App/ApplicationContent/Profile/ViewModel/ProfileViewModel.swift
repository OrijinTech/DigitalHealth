//
//  ProfileViewModel.swift
//  DH_App
//
//  Created by Yongxiang Jin on 3/11/24.
//

import Foundation
import Combine
import Firebase


// Publish the user data from the UserService to here. We can then pass the user info into the profile view from this view model
class ProfileViewModel: ObservableObject {
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupUser()
    }
    
    private func setupUser() {
        UserService.sharedUser.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
    }
    
    
}
