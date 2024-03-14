//
//  MyCoachView.swift
//  DH_App
//
//  Created by Yongxiang Jin on 3/11/24.
//

import SwiftUI

struct MyCoachView: View {
    @StateObject var viewModel = CoachViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.loadingState {
                case .loading, .none:
                    Text("Loading Chats...")
                case .noResults:
                    Text("No Chats...")
                case .resultsFound:
                    List {
                        ForEach(viewModel.chats) { chat in
                            NavigationLink(value: chat.id) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(chat.topic ?? "New Chat")
                                            .font(.headline)
                                        Spacer()
                                        Text(chat.model?.rawValue ?? "")
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(chat.model?.tintColor ?? .white)
                                            .padding(6)
                                            .background((chat.model?.tintColor ?? .white).opacity(0.1))
                                            .clipShape(Capsule(style: .continuous))
                                    }
                                    Text(chat.lastMessageTimeAgo)
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                            }
                            .swipeActions { // Swipe to delete
                                Button(role: .destructive) {
                                    viewModel.deleteChat(chat: chat)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                        }
                    }
                }
            } // End of Group
            .navigationTitle("Health Advisor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            do {
                                _ = try await viewModel.createChat(user: profileViewModel.currentUser?.uid)
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundStyle(.brand)
                    }
                }
            })
            .navigationDestination(for: String.self, destination: { chatId in
                ChatView(viewModel: .init(chatId: chatId))
            })
            .onAppear{
                if viewModel.loadingState == .none {
                    viewModel.fetchData(user: profileViewModel.currentUser?.uid)
                }
            }
        } // End of Navigation Stack
    } // End of body
    
    
}

#Preview {
    MyCoachView()
}
