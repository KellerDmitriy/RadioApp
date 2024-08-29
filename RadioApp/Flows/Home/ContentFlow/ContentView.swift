//
//  ContentView.swift
//  RadioApp
//
//  Created by Evgeniy K on 31.07.2024.
//
import SwiftUI

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
        ZStack(alignment: .bottom) {
            switch selectedTab {
            case .popular:
                PopularView(volume: viewModel.volume)
                   
            case .favorites:
                FavoritesView(volume: viewModel.volume)
                
            case .allStations:
                AllStationsView(volume: viewModel.volume)
            }
            
          
            
            RadioPlayerView(isPlay: $viewModel.isPlay)
                .overlay(PlayButtonAnimation(animation: $viewModel.isPlay))
                .frame(height: 110)
                .padding(.bottom, 80)
            CustomTabBarView(selectedTab: $selectedTab)
                
        
            
            NavigationLink(destination: ProfileView(),
                           isActive: $isProfileViewActive,
                           label: { EmptyView() })
        }
        .task {
            try? await viewModel.loadCurrentUser()
            viewModel.getVolume()
            print(viewModel.volume)
        }
        
        .toolbar {
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
                    }
                )
            }
        }

        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
