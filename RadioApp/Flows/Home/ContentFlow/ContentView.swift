//
//  ContentView.swift
//  RadioApp
//
//  Created by Evgeniy K on 31.07.2024.
//

import SwiftUI

// MARK: - ContentView
struct ContentView: View {
    // MARK: - Properties
    @StateObject var viewModel: ContentViewModel
    
    @State private var selectedTab: Tab = .popular
    @State private var isProfileViewActive = false
    
    init(
        authService: AuthService = .shared,
        userService: UserService = .shared,
        playerService: PlayerService = .shared,
        networkService: NetworkService = .shared
    ) {
        self._viewModel = StateObject(
            wrappedValue: ContentViewModel(
                authService: authService,
                networkService: networkService,
                userService: userService,
                playerService: playerService
            )
        )
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            Spacer()
            switch selectedTab {
            case .popular:
                PopularView(volume: viewModel.volume)
                   
            case .favorites:
                FavoritesView(volume: viewModel.volume)
                
            case .allStations:
                AllStationsView(volume: viewModel.volume)
            }
            
            // Custom Tab Bar
            CustomTabBarView(selectedTab: $selectedTab)
            Spacer()
            
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        
        .toolbar {
            // Toolbar Items
            ToolbarItem(placement: .topBarLeading) {
                ToolbarName(userName: viewModel.userName)
            }
            ToolbarItem(placement: .topBarTrailing) {
                ToolbarProfile(
                    profileImageURL: viewModel.profileImageURL,
                    toolbarRoute: {
                    withAnimation(.easeInOut) {
                        isProfileViewActive.toggle()
                    }
                })
            }
        }
        .background(
            NavigationLink(destination: ProfileView(),
                           isActive: $isProfileViewActive,
                           label: { EmptyView() })
        )
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
