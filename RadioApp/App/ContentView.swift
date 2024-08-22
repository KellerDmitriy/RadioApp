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
    @StateObject var appManager: HomeViewModel
    @State private var selectedTab: Tab = .popular
    @State private var isProfileViewActive = false
    
    // MARK: - Initializer
    init(
        authService: AuthService = .shared,
        networkService: NetworkService = .shared,
        amplitudeService: AmplitudeService = .shared
    ) {
        self._appManager = StateObject(
            wrappedValue: HomeViewModel(
                authService: authService,
                networkService: networkService,
                amplitudeService: amplitudeService
            )
        )
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            // Main Content
            Spacer()
            switch selectedTab {
            case .popular:
                PopularView()
                    .environmentObject(appManager)
                
            case .favorites:
                FavoritesView()
                    .environmentObject(appManager)
                
            case .allStations:
                AllStationsView()
                    .environmentObject(appManager)
            }
            
            // Custom Tab Bar
            CustomTabBarView(selectedTab: $selectedTab)
                .environmentObject(appManager)
            Spacer()
            
        }
        .toolbar {
            // Toolbar Items
            ToolbarItem(placement: .topBarLeading) {
                ToolbarName()
            }
            ToolbarItem(placement: .topBarTrailing) {
                ToolbarProfile(toolbarRoute: {
                    withAnimation(.easeInOut) {
                        isProfileViewActive.toggle()
                    }
                })
            }
        }
        .environmentObject(appManager)
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
