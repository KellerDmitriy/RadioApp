//
//  MainView.swift
//  RadioApp
//
//  Created by Evgeniy K on 31.07.2024.
//
import SwiftUI

struct MainView: View {
    // MARK: - Properties
    @StateObject var viewModel: MainViewModel
    
    @State private var selectedTab: Tab = .popular
    @State private var isProfileViewActive = false
    
    // MARK: - Initializer
    init(
        authService: AuthService = .shared,
        userService: UserService = .shared,
        playerService: PlayerService = .shared,
        networkService: NetworkService = .shared
    ) {
        self._viewModel = StateObject(
            wrappedValue: MainViewModel(
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
                PopularView(
                    isPlayMusic: viewModel.isPlay,
                    volume: viewModel.volume
                )
               
            case .favorites:
                FavoritesView(
                    isPlayMusic: viewModel.isPlay,
                    volume: viewModel.volume
                )
                
            case .allStations:
                AllStationsView(volume: viewModel.volume)
            }
            
            CustomTabBarView(selectedTab: $selectedTab)
            RadioPlayerView(isPlay: $viewModel.isPlay)
                .overlay(PlayButtonAnimation(animation: $viewModel.isPlay))
                .frame(height: 110)
                .padding(.bottom, 80)

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
    MainView()
}
