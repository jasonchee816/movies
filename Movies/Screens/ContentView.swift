//
//  ContentView.swift
//  Movies
//
//  Created by Axflix on 11/11/2023.
//

import SwiftUI

struct MovieResponse: Codable {
    let search: [Movie]
    let totalResults: String
    let response: String
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

struct Movie: Codable, Identifiable {
    let id = UUID()
    let Title: String
    let Year: String
    let imdbID: String
    let Poster: String
}

enum invalidUrlError: Error {
    case invalidURL
    case internalServerError
    case codeError
}

struct MoviesGridView: View {
    @State private var movies: [Movie] = []
    @State private var isRefreshing = false

    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
    ]
    
    func getMovies() async throws -> [Movie] {
        defer {
                isRefreshing = false
        }
        
        try await Task.sleep(nanoseconds: 1 * 1_000_000_000)

        isRefreshing = true
        guard let url = URL(string: AppConfig.apiBaseUrl) else {throw invalidUrlError.invalidURL}
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            isRefreshing = false
            throw invalidUrlError.internalServerError
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let movieResponse = try decoder.decode(MovieResponse.self, from: data)
            return movieResponse.search
        } catch {
            throw invalidUrlError.codeError
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView{
                LazyVGrid(columns: columns){
                    ForEach(movies) { movie in
//                        NavigationLink(value: movie){
                        VStack{
                            AsyncImage(url: URL(string: movie.Poster)){phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                case .failure:
                                    Image(systemName: "exclamationmark.triangle")
                                        .symbolVariant(.fill)
                                        .foregroundColor(.red)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            Text(movie.Title)
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .padding()
//                    }
                    }
                }
                .onAppear{
                    Task{
                        do {
                            movies = try await getMovies()
                        } catch {
                            print("Error fetching movies")
                        }
                    }
                }
            }
            .refreshable {
                do{
                    movies = try await getMovies()
                } catch {
                    print("Error fetching movies")
                }
            }
            .navigationTitle("Movies Showing Now")
//            .navigationDestination(for: Framework.self){framework in
//                DetailScreen(
//                    framework: framework,
//                    isShowingDetail: .constant(true))
//            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
         MoviesGridView()
        }
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}


#Preview {
    ContentView()
}

