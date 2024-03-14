//
//  EditProfileView.swift
//  DH_App
//
//  Created by Yongxiang Jin on 3/13/24.
//

import SwiftUI

struct EditProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @Binding var showingProileInfo: Bool
    
    var body: some View {
        NavigationStack {
            HStack {
                Button {
                    showingProileInfo = false
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.brand)
                    }
                }.padding(.leading, 30)
                
                Spacer()
            }
            
            VStack(spacing: 15) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(Color(.systemGray4))
                    .padding(.bottom, 5)
                    .padding(.top, 30)
                Text(viewModel.currentUser?.userName ?? "Username")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 30)
            }
            
            
            List {
                
                Section(header: Text("Account Info")){
                    ForEach(AccountOptions.allCases){ option in
                        Text(option.title)
                    }
                }
                
                Section(header: Text("Personal Info")){
                    ForEach(PersonalInfoOptions.allCases){ option in
                        Text(option.title)
                    }
                }
            }
        }// End of V Stack

        
    }
}

#Preview {
    EditProfileView(showingProileInfo: .constant(true))
}
