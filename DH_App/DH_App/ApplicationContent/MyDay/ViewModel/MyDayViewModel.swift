//
//  MyDayViewModel.swift
//  DH_App
//
//  Created by Yongxiang Jin on 3/13/24.
//

import Foundation


enum CardOptions: Int, CaseIterable, Identifiable {
    var id: Int { return self.rawValue }
    
    case breakfast
    case lunch
    case dinner
    case snack
    case water
    
    var title: String {
        switch self {
        case .breakfast:
            return "Breakfast"
        case .lunch:
            return "Lunch"
        case .dinner:
            return "Dinner"
        case .snack:
            return "Snack"
        case .water:
            return "Water"
        }
    }
    
    var cardHeight: CGFloat? {
        switch self {
        case .breakfast, .lunch, .dinner, .snack:
            return 120
        case .water:
            return 160
        }
    }
    
    
    
}

