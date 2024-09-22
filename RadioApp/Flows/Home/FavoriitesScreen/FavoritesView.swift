//
//  FavoritesView.swift
//  RadioApp
//
//  Created by Evgeniy K on 01.08.2024.
//

import SwiftUI

struct FavoritesView: View {
    // MARK: - Properties
    @StateObject var viewModel: FavoritesViewModel
    @EnvironmentObject var playerService: PlayerService
    
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    @State private var isDetailViewActive = false
    
    // MARK: - Initializer
    init(
        userId: String
    ) {
        self._viewModel = StateObject(
            wrappedValue: FavoritesViewModel(
                userId: userId
            )
        )
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            headerView
            
            if viewModel.favoritesStations.isEmpty {
                Spacer()
                Text("You have no saved stations")
                    .foregroundColor(.white)
                    .padding()
            } else {
                favoritesListView
            }
            
            Spacer()
        }
        .background(DS.Colors.darkBlue)
        .alert(isPresented: isPresentedAlert()) {
            errorAlert
        }
        .onAppear {
            Task {
                await viewModel.getFavorites()
                playerService.addStationForPlayer(viewModel.getStations())
            }
        }
        
        if let selectedIndex = viewModel.selectedIndex {
            NavigationLink(
                destination: DetailsView(
                    viewModel.userId,
                    station: viewModel.getCurrentStation(selectedIndex)
                )
                .environmentObject(playerService),
                isActive: $isDetailViewActive) {
                    EmptyView()
                }
        }
    }
    
    // MARK: - Subviews
    private var headerView: some View {
        HStack {
            Text(Resources.Text.favorites.localized(language))
                .font(.custom(DS.Fonts.sfRegular, size: 30))
                .foregroundStyle(.white)
            Spacer()
        }
        .padding(.leading)
        .background(DS.Colors.darkBlue)
    }
    
    private var favoritesListView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.favoritesStations.indices, id: \.self) { index in
                    ZStack {
                        FavoritesCellView(
                            isSelect: viewModel.isSelectCell(index),
                            station: viewModel.getCurrentStation(index),
                            deleteAction: {
                                Task {
                                    await viewModel.deleteFavorite(station: viewModel.getCurrentStation(index))
                                }
                            }
                        )
                        .onTapGesture {
                            
                            viewModel.selectStation(at: index)
                            playerService.indexRadio = viewModel.selectedIndex
                            playerService.playAudio()
                        }
                        .onLongPressGesture {
                            isDetailViewActive = true
                        }
                    }
                }
            }
        }
    }
    
    
    private var errorAlert: Alert {
        Alert(
            title: Text(Resources.Text.error.localized(language)),
            message: Text(viewModel.error?.localizedDescription ?? ""),
            dismissButton: .default(
                Text(Resources.Text.ok.localized(language)),
                action: viewModel.cancelErrorAlert
            )
        )
    }
    
    private func isPresentedAlert() -> Binding<Bool> {
        Binding(
            get: { viewModel.error != nil },
            set: { _ in }
        )
    }
}

// MARK: - Preview
#Preview {
    FavoritesView(userId: "EySUMWfrYxRzC06bjVW7Yy3P2FE3")
}
