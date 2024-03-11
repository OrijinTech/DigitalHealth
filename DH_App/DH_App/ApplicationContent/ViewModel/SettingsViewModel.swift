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


