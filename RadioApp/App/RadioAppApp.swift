//
//  RadioAppApp.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 28.07.2024.
//

import SwiftUI
import AVFAudio
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@main
struct RadioAppApp: App {
    //MARK: -
    @AppStorage("isOnboarding") var isOnboarding = false
    private let authService: IAuthService = DIContainer.resolve(forKey: .authService) ?? AuthService()
    
    //MARK: - Init
    init() {
        FirebaseApp.configure()
        DIContainer.register({ UserService() }, forKey: .userService, lifecycle: .transient)
        DIContainer.register({ AuthService() }, forKey: .authService, lifecycle: .singleton)
        DIContainer.register({ FirebaseStorageService() }, forKey: .storageService, lifecycle: .singleton)
        DIContainer.register({ NotificationsService() }, forKey: .notificationsService, lifecycle: .transient)
        DIContainer.register({ NetworkService() }, forKey: .networkService, lifecycle: .singleton)
        
    }
    
    //MARK: - Body
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if !isOnboarding {
                    WelcomeView()
                        .preferredColorScheme(.dark)
                } else if authService.isAuthenticated() {
                    HomeContentView()
                        .preferredColorScheme(.dark)
                } else {
                    AuthView().onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
                    .navigationBarHidden(true)
                    .preferredColorScheme(.dark)
                }
            }
        }
    }
}
