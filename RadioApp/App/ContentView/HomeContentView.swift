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
        playerService: PlayerService = .shared
    ) {
        self._playerService = StateObject(wrappedValue: playerService)
        self._viewModel = StateObject(wrappedValue: HomeViewModel())
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack {
                    // MARK: - Volume Slider
                    VolumeSliderView(volume: $playerService.volume)
                        .environmentObject(playerService)
                        .frame(width: 30, height: 300)
                        .padding(.trailing, 16)
                    
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
                            // MARK: - Shimmer for Loading State
                            ShimerPopularView()
                        }
                    }
                    .padding(.trailing, 18)
                }
                .padding(.horizontal, 22)
                .padding(.top, 120)
                
                Spacer()
                CustomTabBarView(selectedTab: $selectedTab)
                    .frame(height: 80)
            }
            
            RadioPlayerView(playerService: playerService)
                .padding(.bottom, 66)
            
            
            NavigationLink(destination:
                            ProfileView(viewModel.user),
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
        .task {
            try? await viewModel.loadCurrentUser()
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
    NavigationView {
        HomeContentView()
    }
}
