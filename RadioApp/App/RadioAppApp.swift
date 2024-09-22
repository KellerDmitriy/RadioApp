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
    private let authService: IAuthService = DIService.resolve(forKey: .authService) ?? AuthService()
    
    //MARK: - Init
    init() {
        FirebaseApp.configure()
        DIService.register({ UserService() }, forKey: .userService, lifecycle: .transient)
        DIService.register({ AuthService() }, forKey: .authService, lifecycle: .singleton)
        DIService.register({ FirebaseStorageService() }, forKey: .storageService, lifecycle: .singleton)
        DIService.register({ NotificationsService() }, forKey: .notificationsService, lifecycle: .transient)
        DIService.register({ NetworkService() }, forKey: .networkService, lifecycle: .singleton)
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
