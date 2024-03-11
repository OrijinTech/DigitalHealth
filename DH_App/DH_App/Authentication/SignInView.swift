//
//  SignInView.swift
//  DH_App
//
//  Created by Yongxiang Jin on 3/10/24.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @StateObject var authViewModel = LoginViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Image("logo_black_t")
                    .resizable().scaledToFit()
                    .frame(width: 120, height: 120)
                
                Text("Let's get started!")
                    .font(.title2)
                    .padding(.bottom, 100)
                
                VStack{
                    HStack {
                        Image(systemName: "envelope")
                            .padding(.leading, 10)
                        TextField("Email", text: $authViewModel.email)
                            .font(.subheadline)
                            .padding(12)
                    }
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 30)
                    .padding(.bottom, 10)
                    
                    
                    HStack {
                        Image(systemName: "key.horizontal")
                            .padding(.leading, 10)
                        SecureField("Password", text: $authViewModel.password)
                            .font(.subheadline)
                            .padding(12)
                    }
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 30)
                }
                
                Button {
                    
                } label: {
                    Text("Forgot password?")
                        .font(.footnote)
                        .foregroundStyle(.brand)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.trailing, 28)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                

                Button {
                    Task { try await authViewModel.login() }
                }label: {
                    Text("Sign In                                                      ")
                }
                .modifier(StandardButtonStyle())
                .padding(.vertical)
                
                dividerOr()
                
                
                SignInWithAppleButton(.signIn,
                             onRequest: { request in
                                 request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    switch result {
                    case .success(_):
                          print("Authorization successful.")
                       case .failure(let error):
                          print("Authorization failed: " + error.localizedDescription)
                }
                })
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 50)
                .padding(.top, 8)
                .padding(.bottom, 100)
    
                
                Divider()
                
                HStack{
                    Text("Don't have an account?")
                    NavigationLink {
                        
                    } label: {
                        Text("Sign Up")
                            .foregroundStyle(.brand)
                    }
                }
                .font(.footnote)
                .padding(.vertical)
                

                
            }
            
        } // End of Navigation Stack
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.brand)
                    }
                }
            }
        }
    }
    
    
}

#Preview {
    SignInView()
}
