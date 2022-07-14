//
//  GoogleMapApi.swift
//  PetDiary
//
//  Created by jeanwei on 2022/6/3.
//

import Foundation
import CoreLocation
class GoogleMapApi{
    let API_Key = "AIzaSyAdaC7ucRjLALZRwBVAXOWc1ZE38scKkKQ"
    static var shared = GoogleMapApi()
    
    //Place Search - NearbySearch
    /*  location: 經緯度
     radius：範圍（公尺）
     keyword：搜尋關鍵字
     language：語言
     key：個人的api key*/
    func fetchNearbySearch(location: String, keyword: String, completion: @escaping (ListResponse?) -> Void){
        if let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location)&radius=1000&keyword=\(keyword)&language=zh-TW&key=\(API_Key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data,
                   let response = response as? HTTPURLResponse,
                   response.statusCode == 200,
                   error == nil{

                    do {
                        let decoder = JSONDecoder()
                        completion(try decoder.decode(ListResponse.self, from: data))
                    } catch  {
                        completion(nil)
                    }

                }else{
                    print("錯誤：\(error)")
                }
            }.resume()

        }else{
            print("URL失敗")
        }
    }
   

}
    
