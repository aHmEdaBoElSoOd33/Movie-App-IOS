//
//  ReviewsApi.swift
//  Movie App(MaharaTech)
//
//  Created by Ahmed on 03/01/2023.
//

import Foundation

class ReviewsApi{
    
    
    func GetDataFromApiReviews(id : Int , completion : @escaping ( _ revew :[Review])-> Void){
        var reviewsArray : [Review] = []
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(String(id))/reviews?api_key=c56cce7934377fa939c2ad5fa16d4f6d")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { (data, response, error) in
           
           // print("data has arrived successfully")
           // print(data)
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data! , options: .allowFragments) as! Dictionary<String,Any>
                
                let dic = json["results"] as! Array<Dictionary<String,Any>>
                
                for rawdata in dic {
                    let reviewObj = Review()
                    reviewObj.name = rawdata["author"] as! String
                    reviewObj.content = rawdata["content"] as! String
                     reviewsArray.append(reviewObj)
                    completion(reviewsArray)
                    
                }
                
               
                
                
            }catch{
                print(error)
            }
            
        }
        
        
        
        task.resume()
    }
    
    
    
    
    
    
    
    
    
}
