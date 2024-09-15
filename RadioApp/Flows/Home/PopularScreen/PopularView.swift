//
//  PopularView.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 31.07.2024.
//

import SwiftUI

struct PopularView: View {
    // MARK: - Properties
    @StateObject var viewModel: PopularViewModel
    @EnvironmentObject var playerService: PlayerService
    
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    @State private var isDetailViewActive = false
    
    // MARK: - Drawing Constants
    private struct Drawing {
        static let titleFontSize: CGFloat = 30
        static let pickerMaxWidth: CGFloat = 200
        static let pickerOffsetY: CGFloat = 4
        static let gridItemMinimumWidth: CGFloat = 139
        static let gridSpacing: CGFloat = 15
        static let verticalPadding: CGFloat = 10
        static let backgroundColor: Color = DS.Colors.darkBlue
    }

    // MARK: - Initializer
    init(
        userId: String,
        userService: UserService = .shared,
        networkService: NetworkService = .shared
    ) {
        self._viewModel = StateObject(
            wrappedValue: PopularViewModel(
                userId: userId,
                userService: userService,
                networkService: networkService
            )
        )
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            // MARK: - Header
           HStack() {
                // MARK: - Header
                Text(Resources.Text.popular.localized(language))
                    .font(
                        .custom(DS.Fonts.sfRegular,
                            size: Drawing.titleFontSize)
                    )
                    .foregroundStyle(.white)
Spacer()
                // MARK: - Display Order Picker
                Picker(
                    LocalizedStringKey("display_order"),
                    selection: $viewModel.selectedOrder
                ) {
                    ForEach(DisplayOrderType.allCases, id: \.self) { order in
                        Text(order.name).tag(order)
                    }
                }
                .accentColor(.white)
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity, alignment: .trailing)
                .frame(maxWidth: Drawing.pickerMaxWidth)
                .offset(y: Drawing.pickerOffsetY)
            }
            .padding(.vertical, Drawing.verticalPadding)
            
            // MARK: - Stations Grid
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: Drawing.gridItemMinimumWidth))], spacing: Drawing.gridSpacing) {
                    ForEach(viewModel.getStations().indices, id: \.self) { index in
                        let station = viewModel.getCurrentStation(index)
                        
                        // MARK: - Station Cell
                        ZStack {
                            PopularCellView(
                                isSelect: isSelectCell(index),
                                isFavorite: viewModel.isFavoriteStation(index),
                                isPlayMusic: playerService.isPlayMusic,
                                station: station,
                                favoriteAction: { viewModel.toggleFavorite(index) }
                            )
                        }
                        .onTapGesture {
                            viewModel.selectStation(at: index)
                            playerService.indexRadio = viewModel.selectedIndex
                            playerService.playAudio()
                        }
                        .onLongPressGesture {
                            if station.id == playerService.currentStation?.id {
                                isDetailViewActive = true
                            }
                        }
                    }
                }
            }
        }
        .background(Drawing.backgroundColor)
        .task {
            // MARK: - Fetch Stations Task
            Task {
                await viewModel.fetchTopStations()
                playerService.addStationForPlayer(viewModel.getStations())
            }
        }
        .refreshable {
            await refreshTask()
        }
        .alert(isPresented: isPresentedAlert()) {
            // MARK: - Error Alert
            Alert(
                title: Text(Resources.Text.error.localized(language)),
                message: Text(viewModel.error?.localizedDescription ?? ""),
                dismissButton: .default(Text(Resources.Text.ok.localized(language)),
                                        action: viewModel.cancelErrorAlert)
            )
        }
        
        // MARK: - Detail View Navigation
        if isDetailViewActive {
            NavigationLink(
                destination: DetailsView(
                    viewModel.userId,
                    station: viewModel.getCurrentStation(viewModel.currentIndex)
                )
                .environmentObject(playerService),
                isActive: $isDetailViewActive
            ) {
                EmptyView()
            }
        }
    }
    
    // MARK: - Private Methods
    private func refreshTask() async {
        await viewModel.refreshTask()
    }
    
    private func isSelectCell(_ index: Int) -> Bool {
        var isSelect = false
        guard let currentStation = playerService.currentStation  else { return false }
        if playerService.isPlayMusic {
            isSelect = viewModel.getCurrentStation(index).id == currentStation.id
        } else {
            isSelect = viewModel.isSelectCell(index)
        }
        return isSelect
    }
    
    private func isPresentedAlert() -> Binding<Bool> {
        Binding(get: { viewModel.error != nil },
                set: { isPresenting in
            if isPresenting { return }
        })
    }
}

// MARK: - Preview
#Preview {
    PopularView(userId: "EySUMWfrYxRzC06bjVW7Yy3P2FE3")
        .environmentObject(PlayerService.shared)
}
