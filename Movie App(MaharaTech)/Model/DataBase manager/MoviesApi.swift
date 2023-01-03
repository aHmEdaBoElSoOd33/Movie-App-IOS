//
//  MoviesApi.swift
//  Movie App(MaharaTech)
//
//  Created by Ahmed on 03/01/2023.
//

import Foundation
class MoviesApi {
    
    func GetDataFromApiMovies(completion : @escaping ( _ movies:[Movie])-> Void){
        
        var moviesArray : [Movie] = []
        
        
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
                    
                    moviesArray.append(movieObj)
                 
                    completion(moviesArray)
           
                }
                
            }catch{
                print(error)
            }
            
        }
        task.resume()
    }
    
     
}
