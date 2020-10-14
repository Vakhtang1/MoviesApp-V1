//
//  ViewController.swift
//  MoviesApp-V1
//
//  Created by Vakho on 10/9/20.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let apiService = ApiService()
    
    var allMovies : AllPopularMovies?
    var movies  = [PopularMovies]()
    var filteredMovies = [PopularMovies]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 400, height: 150)
        
        collectionView.collectionViewLayout = layout
        searchBar.delegate = self
        
        apiService.fetchMovies { (allMovies) in
            
            for movie in allMovies.results {
                self.movies.append(movie)
                self.filteredMovies.append(movie)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
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

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        cell.layer.cornerRadius = 20
        
        let movie = filteredMovies[indexPath.row]
        movie.posterPath.downloadImage { (image) in
            DispatchQueue.main.async {
                cell.imgView.image = image
            }
        }
        return cell
    }
    
    
    
    
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        
        
        vc.popularMovie = filteredMovies[indexPath.row]
        
        let popMovies = filteredMovies[indexPath.row]
        vc.movieTitle = "\(popMovies.title)"
        vc.movieDescription = "\(popMovies.overview)"
        vc.movieRating = "\(popMovies.voteAverage)"
        vc.popularMovie = popMovies
        popMovies.posterPath.downloadImage(completion: { (image) in
            DispatchQueue.main.async {
                vc.movieImgView = image
            }
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.filteredMovies = self.movies.filter({ $0.title.lowercased().contains(searchText.lowercased()) || $0.title.lowercased().contains(searchText.lowercased()) })
            self.collectionView.reloadData()
        } else {
            filteredMovies = movies
            collectionView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWith = collectionView.frame.width / 2
        
        return CGSize(width: itemWith - 11, height: itemWith - 11)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 10, bottom: 0 , right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
