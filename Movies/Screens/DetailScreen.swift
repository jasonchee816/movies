//
//  DetailScreen.swift
//  Movies
//
//  Created by Axflix on 11/11/2023.
//

import SwiftUI

struct DetailScreen: View {
    var movie: Movie
    var body: some View {
        ZStack{
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
                
                HStack{
                    Text("IMBD ID: ")
                    Spacer()
                    Text(movie.imdbID)
                }.padding()
                HStack{
                    Text("Year Released: ")
                    Spacer()
                    Text(movie.Year)
                }
                .padding()

                Spacer()
            }
        }.ignoresSafeArea()
    }
}

#Preview {
    DetailScreen(movie: Movie(Title: "Test", Year: "2022", imdbID: "123", Poster: "https://m.media-amazon.com/images/M/MV5BZDc0NTc4YTMtOTRiYS00MzQ5LTg5MDAtYWMzZTM5MjljYWViXkEyXkFqcGdeQXVyMTUyOTc1NDYz._V1_SX300.jpg"))
}
