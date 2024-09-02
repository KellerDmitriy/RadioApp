//
//  HomeContentView.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 29.08.2024.
//

import SwiftUI

struct HomeContentView: View {
    // MARK: - Properties
    @StateObject var playerService: PlayerService
    
    @StateObject var viewModel: HomeViewModel
    @State private var selectedTab: Tab = .popular
    @State private var isProfileViewActive = false
    
    // MARK: - Initializer
    init(
        authService: AuthService = .shared,
        userService: UserService = .shared,
        networkService: NetworkService = .shared
    ) {
        self._playerService = StateObject(
            wrappedValue: PlayerService()
        )
        
        self._viewModel = StateObject(
            wrappedValue: HomeViewModel(
                authService: authService,
                networkService: networkService,
                userService: userService
            )
        )
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom) {
            HStack {
                VStack {
                    VolumeSliderView(volume: $playerService.volume)
                        .frame(width: 20, height: 300)
                }
                switch selectedTab {
                case .popular:
                    PopularView()
                        .environmentObject(playerService)
                case .favorites:
                    FavoritesView()
                        .environmentObject(playerService)
                case .allStations:
                    AllStationsView()
                        .environmentObject(playerService)
                }
            }
            
            .padding(.horizontal, 12)
            .background(DS.Colors.darkBlue)
            
            CustomTabBarView(selectedTab: $selectedTab)
            
            RadioPlayerView(playerService: playerService)
                .frame(height: 110)
                .padding(.bottom, 80)
            
         
            NavigationLink(destination:
                            ProfileView(viewModel.currentUser ?? DBUser.getTestDBUser()),
                           isActive: $isProfileViewActive,
                           label: { EmptyView() })
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .onDisappear(perform: destroyPlayerService)
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
    
    private func destroyPlayerService() {
        playerService.deinit()
    }
}
// MARK: - Preview
#Preview {
    HomeContentView()
}
