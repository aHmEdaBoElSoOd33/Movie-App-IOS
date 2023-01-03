//
//  DetailsVC.swift
//  Movie App(MaharaTech)
//
//  Created by Ahmed on 06/12/2022.
//

import UIKit
import SDWebImage
import Cosmos
import youtube_ios_player_helper_swift

class DetailsVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource{
//MARK: - IBOutlets

    @IBOutlet weak var reviewsHandel: UILabel!
    @IBOutlet weak var autherName: UILabel!
    @IBOutlet weak var autherContent: UITextView!
    @IBOutlet weak var YTcollectionView: UICollectionView!
    @IBOutlet weak var Poster: UIImageView!
    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var rateing: CosmosView!
    @IBOutlet weak var realeaseDate: UILabel!
    
    @IBOutlet weak var showMoreReviews: UIButton!
    var review : Review?
    
    var movie : Movie?
    var youtubeArray : [Youtube] = []
    var reviewsArray : [Review] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //GetDataFromApiYoutube()
       // GetDataFromApiReviews()
        GetDataFromApis()
        outlets()
        
    }
    
    func GetDataFromApis(){
        
        ReviewsApi().GetDataFromApiReviews(id: (movie?.id)!) { revew in
            self.reviewsArray = revew
        }
        
        
        YoutubeApi().GetDataFromApiYoutube(id: (movie?.id)!) { youtube in
            self.youtubeArray = youtube
        }
        
    }
    func outlets(){
                    let url = URL(string: "https://image.tmdb.org/t/p/w185/"+(movie?.poster_path)!)
                    Poster.sd_setImage(with: url, placeholderImage: UIImage(systemName: "exclamationmark.square"))
                    movieTitle.text = movie?.title
                    realeaseDate.text = movie?.release_date
                    overview.text = movie?.overview
                    rateing.settings.fillMode = .precise
                    rateing.rating = ((movie?.vote_average)! / 2.0)
              
        if reviewsArray.isEmpty {
            autherContent.text = "There are no reviews for this Movie yet"
            showMoreReviews.isHidden = true
        }else{
            autherName.text = "The Auther : " + (reviewsArray.first?.name)!
            autherContent.text = reviewsArray.first?.content
        }
       
        
        self.YTcollectionView.dataSource = self
        self.YTcollectionView.delegate = self
        YTcollectionView.layer.borderWidth = 1
        YTcollectionView.layer.borderColor = UIColor.white.cgColor
        
    }
     
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
             return youtubeArray.count
         }
         
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! YTCell
             
             //cell.key = youtubeArray[indexPath.row]
             cell.trailer.load(videoId: youtubeArray[indexPath.row].key!)
             
             return cell
             
         }
    
    
    
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func moreReviews(_ sender: Any) {
        
        if reviewsArray.isEmpty{
            autherContent.text = "There are no reviews for this movie yet"
        }else {
            let VC1 = self.storyboard?.instantiateViewController(withIdentifier: "ReviewsVC") as! ReviewsVC
            VC1.reviewArray = reviewsArray
            
            VC1.modalPresentationStyle = .fullScreen
            
            self.present(VC1, animated:true)
            
        }
    }
}


extension DetailsVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)}
}
