//
//  MovieModel.swift
//  DiffableUIDataSources
//
//  Created by Jason on 2022/8/30.
//

import Foundation

class MovieSection: Hashable {
    var id = UUID()
    var title: String
    var movies: [Movie]
    
    init(title: String, movies: [Movie]) {
        self.title = title
        self.movies = movies
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    static func == (lhs: MovieSection, rhs: MovieSection) -> Bool {
      lhs.id == rhs.id
    }
}

class Movie: Hashable {
    var id = UUID()
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}
    
extension MovieSection {
    static var allMovieSections: [MovieSection] = [
        MovieSection(title: "2022 Top 10", movies: [
            Movie(title: "Top Gun: Maverick"),
            Movie(title: "Jurassic World Dominion"),
            Movie(title: "Doctor Strange in the Multiverse of Madness"),
            Movie(title: "Minions: The Rise of Gru"),
            Movie(title: "The Batman"),
            Movie(title: "Thor: Love and Thunder"),
            Movie(title: "The Battle at Lake Changjin II"),
            Movie(title: "Moon Man"),
            Movie(title: "Fantastic Beasts: The Secrets of Dumbledore"),
            Movie(title: "Sonic the Hedgehog 2")
        ]),
        MovieSection(title: "2022 Top Comedy", movies: [
            Movie(title: "Everything Everywhere All at Once"),
            Movie(title: "Jackass Forever"),
            Movie(title: "Turning Red"),
            Movie(title: "The Unbearable Weight of Massive Talent"),
            Movie(title: "The Bob's Burgers Movie"),
            Movie(title: "Sonic the Hedgehog 2"),
            Movie(title: "The Man from Toronto"),
            Movie(title: "Chip 'n Dale: Rescue Rangers"),
            Movie(title: "Dog"),
            Movie(title: "The Bad Guys")
        ])
    ]
}
