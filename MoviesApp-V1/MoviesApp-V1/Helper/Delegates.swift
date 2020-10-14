//
//  Delegates.swift
//  MoviesApp-V1
//
//  Created by Vakho on 10/9/20.
//

import Foundation

protocol PopularMovieDelegate {
    func getPopularMovie(movie: PopularMovies)
}

protocol TopRatedMovieDelegate {
    func getTopRatedMovie(movie: TopRatedMovies)
}
