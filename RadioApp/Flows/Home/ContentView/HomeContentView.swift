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
            VStack {
                VStack {
                    if !viewModel.userId.isEmpty {
                        switch selectedTab {
                        case .popular:
                            PopularView(userId: viewModel.userId)
                                .environmentObject(playerService)
                            
                        case .favorites:
                            FavoritesView(userId: viewModel.userId)
                                .environmentObject(playerService)
                        case .allStations:
                            AllStationsView(userId: viewModel.userId)
                                .environmentObject(playerService)
                        }
                    } else {
                        Text("Loading...")
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 120)
                .padding(.horizontal, 12)
                
                Spacer()
                CustomTabBarView(selectedTab: $selectedTab)
                    .frame(height: 80)
            }
                RadioPlayerView(playerService: playerService)
                    .padding(.bottom, 66)
                

            NavigationLink(destination:
                            ProfileView(viewModel.currentUser ?? DBUser.getTestDBUser()),
                           isActive: $isProfileViewActive,
                           label: { EmptyView() })
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
                            destroyPlayerService()
                        }
                    }
                )
            }
        }
        .onAppear {
            Task {
                try? await viewModel.loadCurrentUser()
            }
        }
        .background(DS.Colors.darkBlue)
        .opacity(0.8)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
    
    private func destroyPlayerService() {
        playerService.removeAllObserver()
        print("remove Observers")
    }
}
// MARK: - Preview
#Preview {
    HomeContentView()
}
