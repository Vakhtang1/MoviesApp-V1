//
//  ApiService.swift
//  MoviesApp-V1
//
//  Created by Vakho on 10/9/20.
//

import Foundation
class ApiService {
    
    //MARK: fetching popular movies
    func fetchMovies(completition: @escaping (AllPopularMovies) -> ()) {
        let urlAPI : String = "https://api.themoviedb.org/3/movie/popular?api_key=2170800e6537a8dd163cfeba89559671&language=en-US&page=1"
        guard let url = URL(string: urlAPI) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            do {
                let decoder = JSONDecoder()
                let movies = try decoder.decode(AllPopularMovies.self, from: data!)
                completition(movies)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
        
        
    }
    
    //MARK: fetching top rated movies
    
    func fetchTopRatedMovies(completition: @escaping (AllTopRatedMovies) -> ()) {
        let urlAPI : String = "https://api.themoviedb.org/3/movie/top_rated?api_key=2170800e6537a8dd163cfeba89559671&language=en-US&page=1"
        guard let url = URL(string: urlAPI) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            do {
                let decoder = JSONDecoder()
                let movies = try decoder.decode(AllTopRatedMovies.self, from: data!)
                completition(movies)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    
    
    //MARK: fetching casts(actors)
    func fetchCast(id: Int, completion: @escaping (Cast) -> ()) {
        guard let url = URL(string:"https://api.themoviedb.org/3/movie/\(id)/credits?api_key=2170800e6537a8dd163cfeba89559671") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let casts = try decoder.decode(Cast.self, from: data)
                completion(casts)
                
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    
    
    //MARK: RECOMMENDATIONS
    func fetchRecommendations(id: Int, completion: @escaping (AllRecommendations) -> ()) {
        guard let url  = URL(string: "https://api.themoviedb.org/3/movie/\(id)/recommendations?api_key=2170800e6537a8dd163cfeba89559671&language=en-US&page=1") else {return }
        
        URLSession.shared.dataTask(with: url) { (data, ress, err) in
            guard let data = data else {return}
            do {
                let decoder = JSONDecoder()
                let recommendations = try decoder.decode(AllRecommendations.self, from: data)
                completion(recommendations)
            } catch {
                print("RECOM : ", error.localizedDescription)
            }
                }.resume()
    }
    
    
    func getMovieById(id : Int, completion: @escaping (PopularMovies)->()){
        print("api", id)
            guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=2170800e6537a8dd163cfeba89559671&language=en-US") else{return}

            URLSession.shared.dataTask(with: url){(data,res,err) in
            guard let data = data else{return}

            do{
                let decoder = JSONDecoder()
                let response = try decoder.decode(PopularMovies.self, from: data)

                completion(response)


            }catch{print("CORE DATA API:", error.localizedDescription)}

            }.resume()
       }
    
    
    
    
    
}
