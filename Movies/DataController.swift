//
//  DataController.swift
//  Movies
//
//  Created by Axflix on 12/11/2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Movie")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func clearMovies() {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            for result in results {
                container.viewContext.delete(result)
            }
            try container.viewContext.save()
        } catch{
            print("Failed to clear movies \(error)")
        }
    }
    
    func addMovie(movieObj: Movie) {
        let movie = MovieEntity(context: container.viewContext)
        movie.id = UUID()
        movie.imdbID = movieObj.imdbID
        movie.poster = movieObj.Poster
        movie.year = movieObj.Year
        movie.title = movieObj.Title
        
        do {
            try container.viewContext.save()
        } catch{
            print("Failed to save movie \(error)")
        }
   }
    
    func getAllMovies() -> [Movie] {
        var movies = [Movie]()
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
           
           do {
               let results = try container.viewContext.fetch(fetchRequest)
               for result in results{
                   let movie = Movie(Title: result.title!,
                                     Year: result.year!,
                                     imdbID: result.imdbID!,
                                     Poster: result.poster!)
                   movies.append(movie)
               }
               return movies
           } catch {
               return []
           }
       }
}
