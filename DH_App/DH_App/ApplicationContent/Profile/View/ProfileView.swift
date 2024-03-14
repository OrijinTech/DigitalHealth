//
//  ProfileView.swift
//  DH_App
//
//  Created by Yongxiang Jin on 3/11/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @State private var showingProileInfo: Bool = false
    
    private var user: User? {
        return viewModel.currentUser
    }
    
    
    var body: some View {
        NavigationStack {
            // TODO: Make this HeaderView
            HStack(spacing: 30) {
                Button { // Move to EditProfileView
                    showingProileInfo = true
//                        .toolbar(.hidden, for: .tabBar)
                } label: {
                    if let userPhoto = user?.profilePhotoURL{
                        Image(userPhoto) // TODO: Upload and Download the image from Firebase Storage
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(Color(.systemGray4))
                            .clipShape(Circle())
                            .padding(.leading, 40)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(Color(.systemGray4))
                            .padding(.leading, 40)
                    }
                }
                
                Text(user?.userName ?? "Username")
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

        } // END OF NAVIGATION STACK
        .fullScreenCover(isPresented: $showingProileInfo, content: {
            EditProfileView(showingProileInfo: $showingProileInfo)
        })
    }
    
    
    
    
    
}

#Preview {
    ProfileView()
}
