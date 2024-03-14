//
//  SettingsViewModel.swift
//  DH_App
//
//  Created by Yongxiang Jin on 3/11/24.
//

import SwiftUI

enum ProfileOptions: Int, CaseIterable, Identifiable {
    var id: Int { return self.rawValue }
    
    case dietPlans
    case friends
    case healthRecords
    case settings
    
    var title: String {
        switch self {
        case .dietPlans:
            return "Diet Plans"
        case .friends:
            return "Friends"
        case .healthRecords:
            return "Health Records"
        case .settings:
            return "Settings"
        }
    }
}


enum AccountOptions: Int, CaseIterable, Identifiable {
    var id: Int { return self.rawValue }
    
    case username
    case lastName
    case firstName
    case email
    case password
    case birthday
    
    var title: String {
        switch self {
        case .username:
            return "Change Username"
        case .email:
            return "Change Email"
        case .password:
            return "Change Password"
        case .firstName:
            return "Change First Name"
        case .lastName:
            return "Change Last Name"
        case .birthday:
            return "Change Birthday"
        }
    }
    
    
}



enum PersonalInfoOptions: Int, CaseIterable, Identifiable {
    var id: Int { return self.rawValue }
    
    case weight
    case height
    case waterReminder
    case units
    
    var title: String {
        switch self {
        case .weight:
            return "Set my weight"
        case .height:
            return "Set my height"
        case .waterReminder:
            return "Water Reminder"
        case .units:
            return "Set up Units"
        }
    }
    
    
}


