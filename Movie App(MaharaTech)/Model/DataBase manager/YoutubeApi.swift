//
//  YoutubeApi.swift
//  Movie App(MaharaTech)
//
//  Created by Ahmed on 03/01/2023.
//

import Foundation

class YoutubeApi {
    
   func GetDataFromApiYoutube(id : Int , completion : @escaping ( _ youtube :[Youtube])-> Void){
     
       var youtubeArray : [Youtube] = []
       
       let url = URL(string: "https://api.themoviedb.org/3/movie/\(String(id))/videos?api_key=c56cce7934377fa939c2ad5fa16d4f6d")
       let request = URLRequest(url: url!)
       let session = URLSession(configuration: URLSessionConfiguration.default)
       let task = session.dataTask(with: request) { (data, response, error) in
          
           
           do {
               
               let json = try JSONSerialization.jsonObject(with: data! , options: .allowFragments) as! Dictionary<String,Any>
               
               let dic = json["results"] as! Array<Dictionary<String,Any>>
               
               for rawdata in dic {
                   let videoObj = Youtube()
                   videoObj.key = rawdata["key"] as! String
                   youtubeArray.append(videoObj) 
                   completion(youtubeArray)
               }
               
              
           }catch{
               print(error)
           }
           
       }
       
       
       
       task.resume()
   }
   
    
    
    
    
    
    
    
    
}
