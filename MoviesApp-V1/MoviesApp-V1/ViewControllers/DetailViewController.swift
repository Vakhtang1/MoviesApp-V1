//
//  DetailViewController.swift
//  MoviesApp-V1
//
//  Created by Vakho on 10/9/20.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var recomCollectionView: UICollectionView!
    
    
    var movieImgView : UIImage? = nil
    var movieTitle   : String = ""
    var movieRating  : String = ""
    var movieRatingImg : UIImage? = nil
    var movieDescription : String = ""
    var movieRelease : String = ""
    
    let apiService = ApiService()
    
    var popularMovie: PopularMovies?
    var topRatedMovie: TopRatedMovies?
    
    var casts: Cast?
    var castsArr = [CastElement]()
    
    var recommendations: AllRecommendations?
    var recommendationsArr = [Recommendations]()
    var index = 0
    
//    var movie: PopularMovies?
//    var topRated : TopRatedMovies?
    
    var favouriteMovie = false
    var tempItem: Movie?
    var favourites = [Movie]()
//    {
//        didSet {
//            for item in favourites {
//                if item.id == popularMovie!.id ??  topRatedMovie!.id
//                {
//                    self.tempItem = item
//                    self.favouriteMovie = true
//                }
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        descriptionLabel.adjustsFontSizeToFitWidth = true
        //descriptionLabel.sizeToFit()
        imgView.image = movieImgView
        titleLabel.text = movieTitle
        ratingLabel.text = movieRating
        descriptionLabel.text = movieDescription
        releaseLabel.text = movieRelease
        //MARK: collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        recomCollectionView.delegate = self
        recomCollectionView.dataSource = self
        
        //fetching actors
        apiService.fetchCast(id: popularMovie?.id ?? topRatedMovie?.id ?? 0 ) { (casts) in
            for cast in casts.cast {
//                print(cast)
                self.castsArr.append(cast)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        apiService.fetchRecommendations(id: popularMovie?.id ?? topRatedMovie?.id ?? 0) { (recs) in
            for recommendation in recs.results {
                self.recommendationsArr.append(recommendation)
            }
            DispatchQueue.main.async {
                self.recomCollectionView.reloadData()
            }
        }
        //MARK: CORE DATA FETCHING
//        fetchMovies()

    }
    override func viewDidAppear(_ animated: Bool) {
        imgView.image = movieImgView
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: back action button
    @IBAction func onBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onFavouriteButton(_ sender: UIButton) {
//        if favouriteMovie {
//            deleteMovie(favMovie: tempItem!)
//        } else {
//            favouriteMovie = true
//            addFavouriteMovie()
//        }
        
        //MARK: FIX
        favouriteMovie = true
        addFavouriteMovie()
    }
    
    
}

extension DetailViewController: UICollectionViewDelegate{
    
}
extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return castsArr.count
        }
        else {
            return recommendationsArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath) as! CastCell
            let castCrew = castsArr[indexPath.row]
            
            cell.castNameLabel.text = castCrew.name
            
            castCrew.profilePath.downloadImage { (image) in
                DispatchQueue.main.async {
                    cell.castImgView.image = image
                }
            }
            return cell
            
        }
        else {
            let recCell = recomCollectionView.dequeueReusableCell(withReuseIdentifier: "RecommCell", for: indexPath) as! RecommCell
            let recommendedMovie = recommendationsArr[indexPath.row]
            recCell.recomNameLabel.text = recommendedMovie.title
            recommendedMovie.backdropPath.downloadImage { (image) in
                DispatchQueue.main.async {
                    recCell.recomImgView.image = image
                }
                
            }
            
            return recCell
        }
    }
    
    
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            
            return CGSize(width: collectionView.frame.size.width/3.5, height: collectionView.frame.size.height)
            
        }
        else {
            return CGSize(width: collectionView.frame.size.width/3.5, height: collectionView.frame.size.height)
        }
    }
    
    
    
}

extension DetailViewController {
    func addFavouriteMovie() {
        let context = AppDelegate.coreDataContainer.viewContext
        let newMovie = Movie(context:context)
        
        
        //MARK: FIX
        newMovie.id = Int32(popularMovie?.id ?? 0)
//        newMovie.favourite = true
        
        do {
            try context.save()
            print("Saved")
        } catch {print(error.localizedDescription)}
    }
    
    func fetchMovies() {
        let context = AppDelegate.coreDataContainer.viewContext
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        do {
            let movie = try context.fetch(request)
            favourites.append(contentsOf: movie)
            print(favourites)
        } catch {print(error.localizedDescription)}
    }
    
    func deleteMovie(favMovie: Movie) {
        let context = AppDelegate.coreDataContainer.viewContext
        context.delete(favMovie)
        
        do {
            try context.save()
        } catch {}
    }
}
