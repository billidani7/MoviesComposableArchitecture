//
//  Movie.swift
//  MoviesDemo
//
//  Created by Vasilis Daningelis on 27/4/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

//https://developers.themoviedb.org/3/movies/get-movie-details

public struct Movie: Codable, Identifiable, Equatable {
    
    public static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id: Int
    
    let originalTitle: String?
    let originalName: String?
    var title: String?
    let name: String?
    
    var finalTitle: String {
        return name != nil ? name! : title!
    }
    
    let overview: String?
    
    let posterPath: String?
    let backdropPath: String?
    
    let voteAverage: Float
    let voteCount: Int
    
    let genres: [Genre]?
    
    var credits: [String: [People]]?
    
    public var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    public var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }
    
    var firstAirDate: String?
    
    
    var releaseDate: String?
        //return release_date != nil ? Movie.dateFormatter.date(from: release_date!) : Date()
    
    var releaseDateObj: Date?{
        if (releaseDate != nil)  {
            return Movie.dateFormatter.date(from: releaseDate!)
        }else if (firstAirDate != nil) {
            return Movie.dateFormatter.date(from: firstAirDate!)
        }else{
            return nil
        }
    }
    
    var episodeRunTime: [Int]?
    var runtime: Int?
    
    var duration: String{
        if runtime != nil {
            return "\(runtime!) minutes"
        }else if episodeRunTime != nil && episodeRunTime?.count ?? 0 > 0{
            if episodeRunTime!.count > 1 {
                return "~" + String(episodeRunTime!.reduce(0, +) / episodeRunTime!.count) + " minutes / episode"
            }else{
                return String(episodeRunTime!.reduce(0, +) / episodeRunTime!.count) + " minutes / episode"
            }
        
        }else{
            return "- minutes"
        }
    }
    
    var numberOfEpisodes: Int?
    var numberOfSeasons: Int?
    
    var recommendations:PaginatedResponse<Movie>?
    
    var videos:SimpleResponce<Video>?
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd"
        return formatter
    }()
    
    var mediaType: String?
    
    
}

let sampleCast = [People(id: 0,
       name: "Cast 1",
       character: "Character 1",
       department: nil,
       profilePath: "/2daC5DeXqwkFND0xxutbnSVKN6c.jpg"),
                  People(id: 1, name: "Cast 2", character: nil, department: "Director 1", profilePath: "/2daC5DeXqwkFND0xxutbnSVKN6c.jpg")]

let sampleMovie = Movie(id: 0, originalTitle: nil, originalName: "Joker", name: "Jocker",  overview: "Test desc", posterPath: "/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg", backdropPath: "/f5F4cRhQdUbyVbB5lTNCwUzD6BP.jpg", voteAverage: 8.2, voteCount: 2312, genres: [Genre(id: 0, name: "Adventure")], credits: ["cast": sampleCast])

let loadingMore = Movie(id: -100, originalTitle: "Loading More", originalName: "Loading More", name: "Loading More", overview: "Test desc", posterPath: " ", backdropPath: "nothing", voteAverage: 0, voteCount: 0, genres: [])

let samplePeopleJim = People(id: 206, name: "Jim Carrey", character: "Character 1", department: nil, profilePath: "/ienbErTKd9RHCV1j7FJLNEWUAzn.jpg")

