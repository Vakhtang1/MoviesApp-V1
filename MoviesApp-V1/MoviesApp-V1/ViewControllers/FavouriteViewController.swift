//
//  FavouriteViewController.swift
//  MoviesApp-V1
//
//  Created by Vakho on 10/13/20.
//

import UIKit
import CoreData

class FavouriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let apiService = ApiService()
    var favourites = [Movie]()
    
    var favouriteMovies = [PopularMovies]()
    var favMovies : AllPopularMovies?
    //    {
    //        didSet {
    //            DispatchQueue.main.async {
    //                self.tableView.reloadData()
    //            }
    //        }
    //    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        //MARK: FIXME: CORE DATA CANNOT FETCH
        loadFavourites()
        
    }
    
    
    
    
}

extension FavouriteViewController: UITableViewDelegate {
    
}
extension FavouriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteMovies.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCell", for: indexPath) as! FavouriteCell
        let favMovies = favouriteMovies[indexPath.row]
        
        cell.favouriteTitleLabel.text = favMovies.title
        
        favouriteMovies[indexPath.row].posterPath.downloadImage { (image) in
            DispatchQueue.main.async {
                cell.favouriteImgView.image = image
            }
            
        }
        return cell
    }
    
    
}


extension FavouriteViewController {
    
    
//    func fetchMovies(completion: @escaping ([Movie]) -> Void) {
//        let context = AppDelegate.coreDataContainer.viewContext
//        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
//        do {
//            let movie = try context.fetch(request)
//            completion(movie)
//        } catch {print(error.localizedDescription)}
//    }
      
    func fetchMovies(completion: @escaping ([Movie])->Void){
            let context = AppDelegate.coreDataContainer.viewContext
            let request: NSFetchRequest<Movie> = Movie.fetchRequest()
            do{
                let movie = try context.fetch(request)
                completion(movie)
            }catch {
                print("could not fetch movie")
            }
        }
    
    
    
    func apiFunction() {
        print("fetching")
        for item in self.favourites {
            self.apiService.getMovieById(id: Int(item.id)) { (info) in
                self.favouriteMovies.append(info)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    print("Fav movies: ", self.favouriteMovies)
                }
            }
        }
    }
    
    func loadFavourites() {
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        fetchMovies(completion: { (responses) in
                    self.favourites.removeAll()
                    for response in responses {
                        self.favourites.append(response)
                    }
                    DispatchQueue.main.async {
                        dispatchGroup.leave()
                    }
                })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            dispatchGroup.enter()
            for item in self.favourites {
                self.apiService.getMovieById(id: Int(item.id)) { (PopularMovies) in
                    self.favouriteMovies.append(PopularMovies)
                }
            }
            
            
            
            DispatchQueue.main.async {
                print(self.favouriteMovies)
                dispatchGroup.leave()
            }
        }
        
        
        
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
}
