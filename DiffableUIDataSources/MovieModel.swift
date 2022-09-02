//
//  MovieModel.swift
//  DiffableUIDataSources
//
//  Created by Jason on 2022/8/30.
//

import Foundation

struct MovieSection: Hashable {
    let id = UUID()
    var title: String
    var movies: [Movie]
}

struct Movie: Hashable {
    let id = UUID()
    let title: String
    let releaseYear: Int
}
    
extension MovieSection {
    static let allMovieSections: [MovieSection] = [
        MovieSection(title: "2022 Top 10", movies: [
            Movie(title: "Top Gun: Maverick", releaseYear: 2022),
            Movie(title: "Jurassic World Dominion", releaseYear: 2022),
            Movie(title: "Doctor Strange in the Multiverse of Madness", releaseYear: 2022),
            Movie(title: "Minions: The Rise of Gru", releaseYear: 2022),
            Movie(title: "The Batman", releaseYear: 2022),
            Movie(title: "Thor: Love and Thunder", releaseYear: 2022),
            Movie(title: "The Battle at Lake Changjin II", releaseYear: 2022),
            Movie(title: "Moon Man", releaseYear: 2022),
            Movie(title: "Fantastic Beasts: The Secrets of Dumbledore", releaseYear: 2022),
            Movie(title: "Sonic the Hedgehog 2", releaseYear: 2022)
        ]),
        MovieSection(title: "2022 Top Comedy", movies: [
            Movie(title: "Everything Everywhere All at Once", releaseYear: 2022),
            Movie(title: "Jackass Forever", releaseYear: 2022),
            Movie(title: "Turning Red", releaseYear: 2022),
            Movie(title: "The Unbearable Weight of Massive Talent", releaseYear: 2022),
            Movie(title: "The Bob's Burgers Movie", releaseYear: 2022),
            Movie(title: "Sonic the Hedgehog 2", releaseYear: 2022),
            Movie(title: "The Man from Toronto", releaseYear: 2022),
            Movie(title: "Chip 'n Dale: Rescue Rangers", releaseYear: 2022),
            Movie(title: "Dog", releaseYear: 2022),
            Movie(title: "The Bad Guys", releaseYear: 2022)
        ])
    ]
}
