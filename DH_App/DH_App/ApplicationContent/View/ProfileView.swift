//
//  ProfileView.swift
//  DH_App
//
//  Created by Yongxiang Jin on 3/11/24.
//

import SwiftUI

struct ProfileView: View {
    
    var body: some View {
        VStack {
            
            HStack(spacing: 30) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(Color(.systemGray4))
                    .padding(.leading, 40)
                Text("Username")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.vertical, 40)
            
            List {
                Section {
                    ForEach(ProfileOptions.allCases){ option in
                        Text(option.title)
                            .foregroundStyle(.brand)
                    }
                }
                
                Section {
                    Button {
                        AuthServices.sharedAuth.signOut()
                    } label: {
                        Text("Log Out")
                            .foregroundStyle(.brand)
                    }
                }
                
                
            }
            

        } // END OF V STACK
        
    }
}

#Preview {
    ProfileView()
}
