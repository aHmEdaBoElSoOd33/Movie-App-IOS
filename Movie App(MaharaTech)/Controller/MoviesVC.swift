//
//  ViewController.swift
//  Movie App(MaharaTech)
//
//  Created by Ahmed on 26/11/2022.
//

import UIKit
import SDWebImage
import CoreData

class MoviesVC: UIViewController , UICollectionViewDelegate ,UICollectionViewDataSource  {
   
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var searchArray : [Movie] = []
    var moviesArray : [Movie] = []
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        GetDataFromApiMovies()
        setup()
        hideKeyboardWhenTappedAround()
    }
    
    func hideKeyboardWhenTappedAround() {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
    
    @objc func refresh (send:UIRefreshControl){
        
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
        
    }
    
    
    func setup (){
       
        view.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addSubview(refreshControl)
       
        
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        
        searchbar.delegate = self
        
    }
    
    
    
    
    func GetDataFromApiMovies(){
        
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=c56cce7934377fa939c2ad5fa16d4f6d")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { (data, response, error) in
            print("data has arrived successfully")
            
            do{
                let json = try JSONSerialization.jsonObject(with: data!  ,options: .allowFragments) as! Dictionary<String,Any>
                let dic = json["results"] as! Array<Dictionary<String,Any>>
                
                for rawData in dic {
                    let movieObj = Movie()
                    movieObj.id = rawData["id"] as? Int
                    movieObj.title = rawData["title"] as? String
                    movieObj.overview = rawData["overview"] as? String
                    movieObj.poster_path = rawData["poster_path"] as? String
                    movieObj.release_date = rawData["release_date"] as? String
                    movieObj.vote_average = rawData["vote_average"] as? Double
                    
                    self.moviesArray.append(movieObj)
                    ///search
                    self.searchArray = self.moviesArray
                }
                // thread
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }catch{
                print(error)
            }
        
        }
        task.resume()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MovieCell
        cell.titleLbl.text = searchArray[indexPath.row].title
        cell.Poster.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w185/\(searchArray[indexPath.row].poster_path!)"), placeholderImage: UIImage(systemName: "exclamationmark.square"))
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.white.cgColor
        
        return cell
    }
    
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let VC1 = self.storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        VC1.movie = searchArray[indexPath.row]
        VC1.modalPresentationStyle = .fullScreen
        self.present(VC1, animated:true)
    }
    @IBAction func logoutBtn(_ sender: Any) {
        
        // user default (login)
        UserDefaults.standard.set(false, forKey: "loginstate")
        
        let VC1 = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginVC
        VC1.modalPresentationStyle = .fullScreen
        self.present(VC1, animated: true)
    }
    
}

// cell size

extension MoviesVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 5 , height: collectionView.frame.size.height/2)}
}


// search bar 
extension MoviesVC : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchArray = []
        for word in moviesArray{
            if word.title!.contains(searchText) {
                searchArray.append(word)
            }else if searchText == ""{
                searchArray = moviesArray
            }
        }
        
        self.collectionView.reloadData()
    }
    
    
}
