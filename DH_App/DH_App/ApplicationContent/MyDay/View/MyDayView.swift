//
//  MyDayView.swift
//  DH_App
//
//  Created by Yongxiang Jin on 3/11/24.
//

import SwiftUI

struct MyDayView: View {
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        HStack {
                            Text("Good Morning!")
                                .font(.title2)
                                .bold()
                                .padding(.leading, 30)
                                .padding(.top, 20)
                            Spacer()
                        }.padding(.bottom, 10)
                        
                        HStack {
                            Text(viewModel.currentUser?.userName ?? "The Healthy One")
                                .font(.headline)
                                .bold()
                                .padding(.leading, 30)
                            Spacer()
                        }.padding(.bottom, 30)
                        
                        Section {
                            ForEach(CardOptions.allCases){ card in
                                VStack {
                                    HStack {
                                        Text(card.title)
                                            .bold()
                                            .foregroundStyle(.brand)
                                            .padding(.leading, 15)
                                        Spacer()
                                    }

                                    Divider()
                                    Button {
                                        //
                                    } label: {
                                        Text("+ add \(card.title)")
                                            .padding(.vertical)
                                            .foregroundStyle(.brand)
                                    }
                                }
                                .frame(height: card.cardHeight)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .shadow(radius: 5)
                                
                                
                            }
                        }
                        
                    }
                }
            }
            .navigationTitle("MY DAY")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // TODO: DATE SELECTION TO DISPLAY DIFFERENT DAYS of MY DAY
                    } label: {
                        Image(systemName: "calendar")
                            .foregroundStyle(.brand)
                    }
                }
            })
        } // End of Navigation Stack

    }
}

#Preview {
    MyDayView()
}
