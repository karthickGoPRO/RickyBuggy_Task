//
//  RickyBuggyApp.swift
//  RickyBuggy
//

import SwiftUI

@main
struct RickyBuggyApp: App {
    
    @State var isListHidden = true
    
    init() {
        //MANAGED BY SWInject
        SwiftInjectDI.shared.register(NetworkManager.self) { _ in
            NetworkManager()
        }
        
        SwiftInjectDI.shared.register(APIClient.self) { _ in
            APIClient()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            VStack {
                Button(isListHidden ? "Hide Content" : "Show Content") {
                    isListHidden = !isListHidden
                }
                
                if(isListHidden) {
                    AppMainView()
                }
            }
        }
    }
}
