//
//  TravelDiaryApp.swift
//  TravelDiary
//
//  Created by 鄭宇婕 on 2023/12/21.
//

import SwiftUI
import SwiftData

@main
struct TravelDiaryApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        //.modelContainer(sharedModelContainer)
        .modelContainer(for: Item.self)
    }
}
