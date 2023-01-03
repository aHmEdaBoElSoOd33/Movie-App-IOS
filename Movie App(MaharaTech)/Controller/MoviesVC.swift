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
    
    var name : String?
    var searchArray : [Movie] = []
    var moviesArray : [Movie] = []
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchApiData()
        setup()
        hideKeyboardWhenTappedAround()
        
    }
    
    
    func fetchApiData (){
        
        MoviesApi().GetDataFromApiMovies(completion: { (movies) in
            print(movies)
            self.moviesArray = movies
            self.searchArray = self.moviesArray
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
           
        })
        
       
        
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
