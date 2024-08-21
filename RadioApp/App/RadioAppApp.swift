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
    
    //MARK: - Init
    init() {
        FirebaseApp.configure()
    }
    
    //MARK: - Body
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if !isOnboarding {
                    WelcomeView()
                        .preferredColorScheme(.dark)
                } else if AuthService.shared.isAuthenticated() {
                    ContentView()
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
