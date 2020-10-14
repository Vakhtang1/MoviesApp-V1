//
//  HomeViewController.swift
//  MoviesApp-V1
//
//  Created by Vakho on 10/9/20.
//

import UIKit

class HomeViewController: UIViewController{
    //MARK: properties for popular movies
    
    var allPopularMovies : AllPopularMovies?
    var popularMovies = [PopularMovies]()
    var popularMovieDelegate: PopularMovieDelegate?
    var movie : PopularMovies?
    //MARK: properties for top rated movies
    
    var allTopRatedMovies : AllTopRatedMovies?
    var topRatedMovies = [TopRatedMovies]()
    var topRatedMovieDelegate: TopRatedMovieDelegate?
    
    let apiService = ApiService()
    
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        //MARK: popularCollectionView
        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
        //MARK: topRatedCollectionView
        topRatedCollectionView.delegate = self
        topRatedCollectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 400, height: 150)
        
        apiService.fetchMovies { (allPopularMovies) in
            self.allPopularMovies = allPopularMovies
            self.popularMovies.append(contentsOf: allPopularMovies.results)
            DispatchQueue.main.async {
                self.popularCollectionView.reloadData()
            }
        }
       
        
        apiService.fetchTopRatedMovies { (allTopRatedMovies) in
            self.allTopRatedMovies = allTopRatedMovies
            self.topRatedMovies.append(contentsOf: allTopRatedMovies.results)
            DispatchQueue.main.async {
                self.topRatedCollectionView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
}
//MARK: COLLVIEW DELEGATE
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //MARK: details of popular movies
        if collectionView == self.popularCollectionView {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailViewController") as? DetailViewController
            
            let popMovies = allPopularMovies?.results[indexPath.row]
            vc?.movieTitle = "\(popMovies?.title ?? "")"
            vc?.movieDescription = "\(popMovies?.overview ?? "")"
            vc?.movieRating = "Rating: \(popMovies!.voteAverage)"
            vc?.popularMovie = popMovies
            vc?.movieRelease = popMovies?.releaseDate ?? ""
            popMovies?.posterPath.downloadImage(completion: { (image) in
                DispatchQueue.main.async {
                    vc?.movieImgView = image
                }
            })
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
        //MARK: details of top rated movies
        if collectionView == self.topRatedCollectionView {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailViewController") as? DetailViewController
            
            let topRatedMovies = allTopRatedMovies?.results[indexPath.row]
            vc?.movieTitle = "\(topRatedMovies?.title ?? "")"
            vc?.movieDescription = "\(topRatedMovies?.overview ?? "")"
            vc?.movieRating = "Rating: \(topRatedMovies!.voteAverage)"
            vc?.movieRelease = topRatedMovies?.releaseDate ?? ""
            vc?.topRatedMovie = topRatedMovies
            topRatedMovies?.posterPath.downloadImage(completion: { (image) in
                DispatchQueue.main.async {
                    vc?.movieImgView = image
                }
            })
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
}
//MARK: COLLVIEW DATASOURCE
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.popularCollectionView {
            return popularMovies.count
        }
        else {
            return topRatedMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.popularCollectionView {
            let popularCell = popularCollectionView.dequeueReusableCell(withReuseIdentifier: "PopularCell", for: indexPath) as! PopularCell
            let popularMovie = popularMovies[indexPath.row]
            
            popularMovie.posterPath.downloadImage { (image) in
                DispatchQueue.main.async {
                    popularCell.popularImage.image = image
                }
            }
            return popularCell
        }
        
        else {
            let topRatedCell = topRatedCollectionView.dequeueReusableCell(withReuseIdentifier: "TopRatedCell", for: indexPath) as! TopRatedCell
            let topRatedMovie = topRatedMovies[indexPath.row]
            topRatedMovie.posterPath.downloadImage { (image) in
                DispatchQueue.main.async {
                    topRatedCell.ratedImage.image = image
                }
            }
            return topRatedCell
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.popularCollectionView {
        return CGSize(width: collectionView.frame.size.width/3.5, height: collectionView.frame.size.height)
        }
        else {
            return CGSize(width: collectionView.frame.size.width/3.5, height: collectionView.frame.size.height)
        }
        
        }
}
