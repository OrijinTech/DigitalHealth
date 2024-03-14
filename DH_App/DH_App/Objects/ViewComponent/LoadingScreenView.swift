//
//  LoadingScreenView.swift
//  DH_App
//
//  Created by Yongxiang Jin on 3/14/24.
//

import SwiftUI

struct LoadingScreenView: View {
    
    @ObservedObject var viewModel: MenuViewModel
    @State private var scale = CGSize(width: 0.8, height: 0.8)
    @State private var opacity = 1.0
    
    var body: some View {
        ZStack {
            ZStack {
                Image("logo_black_t")
                    .resizable().scaledToFit()
                    .frame(width: 170)
                    .opacity(opacity)
            }
            .scaleEffect(scale)

        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                scale = CGSize(width: 1, height: 1)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                withAnimation(.easeIn(duration: 0.35)) {
                    scale = CGSize(width: 50, height: 50)
                    opacity = 0
                }
            })

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.9, execute: {
                withAnimation(.easeIn(duration: 0.2)) {
                    viewModel.showLoadingScreen.toggle()
                }
            })
        }

    }
}

#Preview {
    LoadingScreenView(viewModel: MenuViewModel())
}
 
