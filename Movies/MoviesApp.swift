//
//  MoviesApp.swift
//  Movies
//
//  Created by Axflix on 11/11/2023.
//

import SwiftUI

@main
struct MoviesApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
