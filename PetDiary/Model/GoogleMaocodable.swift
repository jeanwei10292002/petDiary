// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation


//--------------------Place Search - NearbySearch--------------------start
//最外層
struct ListResponse: Codable {
    var results: [itemResults]
    var status: String
    
}

//裏層
struct itemResults: Codable {
    var geometry: Geometry
    var name: String        //地標名稱
    var place_id: String    //id （for 抓詳細資料使用）
    var vicinity: String    //地址
}
struct Geometry:Codable{
    var location: Location
}
struct Location:Codable{
    var lat, lng: Double
}

//--------------------Place Search - NearbySearch--------------------end


//--------------------Place Details - Place Details Requests--------------------start

struct DetailResponse: Codable {
    var result: InfoResults
}

struct InfoResults: Codable {
    var name: String                //餐廳名稱
    var photos: [PhotosResults]     //照片
    var reviews: [Reviews]          //評論
    
}

struct PhotosResults: Codable{
    var photo_reference: String
    
}

struct Reviews: Codable{
    var author_name: String
    var profile_photo_url: String
    var relative_time_description: String
    var text: String
    var time: Date
    
}
//--------------------Place Details - Place Details Requests--------------------end
