//
//  PetFriendlyViewController.swift
//  PetDiary
//
//  Created by jeanwei on 2022/6/7.
//

import GoogleMaps
import CoreLocation
import GooglePlaces

//為了取得 iPhone 裝置使用者的當前位置，我們首先必須先套用 Apple 的 CoreLocation 這個 library。
//並且對主要的 ViewController 進行 CLLocationManagerDelegate 的 subclass
class PetFriendlyViewController: UIViewController ,GMSMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var myMap: GMSMapView!
    var listResponse : ListResponse?
    var item : [itemResults] = []
    var location = ""
    //創建locationManager，用於偵測用戶位置變化
    var locationManager = CLLocationManager()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        //CLLocationManager設定
        myMap.delegate = self
        locationManager.delegate = self //委派給ViewController 宣告自己 (這一頁面)為 locationManager 的代理
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //設定為最佳精度，定位所在地的精確程度(一般來說，精準程度越高，定位時間越長，所耗費的電力也因此更多)
        locationManager.requestWhenInUseAuthorization() //user授權
        locationManager.startUpdatingLocation() //開始update user位置，此方法將開始導航位置。一旦完成此操作，它將發送一個msg到此ViewController
        let camera = GMSCameraPosition.camera(withLatitude: 25.034012, longitude: 121.564461, zoom: 15.0)
        myMap.camera = camera
        self.myMap.isMyLocationEnabled = true //開啟我的位置
        
        
    }
    //定義及管理定位方式
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
//        //由於我們的 "startUpdatingLocation()" 會回傳一個陣列的 CLLocation ，而最後回傳的會是最接近於我們當前位置的 CLLocation 。 因此我們要取的就是這個 CLLocation
       let location = locations[locations.count - 1] //方法“ startupdatinglocation（）”將抓住一組越來越準確的位置。所以我們想要此數組中的最後一個位置
//        //簡單檢查取得的值
//        //該線路將檢查位置是否可用
        if location.horizontalAccuracy > 0 {
//            // 由於定位功能十分耗電，我們既然已經取得了位置，就該速速把它關掉
          locationManager.stopUpdatingLocation()
           print("latitude:\(location.coordinate.latitude),longtitude:\(location.coordinate.longitude)")
       }
    }
    //定義錯誤處理方式
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    // MARK:- 讀 JSON 資料，必須要傳入地點
    func getResults(location: String){
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location)&radius=1000&keyword=寵物友善&language=zh-TW&key=AIzaSyAdaC7ucRjLALZRwBVAXOWc1ZE38scKkKQ"
        let newUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! // 網址有中文，需要先編碼
        var request = URLRequest(url: URL(string: newUrl)!,timeoutInterval: Double.infinity)
                request.httpMethod = "GET"
                let task = URLSession.shared.dataTask(with: request){(data, respond, error) in
                    
                    let decoder = JSONDecoder()
                    if let data = data, let weather = try? decoder.decode(ListResponse.self, from: data){
                        
                        print(weather)
                        
                        DispatchQueue.main.sync {
                            self.setupMap()
                        }
                    }
                    else {
                        print("error")
                    }
                }
                task.resume()
    }
        func setupMap(){
           
         
            let camera = GMSCameraPosition.camera(withLatitude: 25.034012, longitude: 121.564461, zoom: 15.0)
           
           
           let f = self.view.frame
           
           let mapFrame = CGRect(x: 500, y: 125, width: f.size.width, height: f.size.height)
           
           myMap = GMSMapView.map(withFrame: mapFrame, camera: camera)
           
           myMap?.delegate = self
           
           myMap?.isMyLocationEnabled = true
            
           
           // Set the map style by passing the URL of the local file.
           do {
              if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                 myMap?.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
              } else {
                 NSLog("Unable to find style.json")
              }
           } catch {
              NSLog("One or more of the map styles failed to load. \(error)")
           }
           
           for restaurant in item {
              let marker = GMSMarker()
             
               marker.position = CLLocationCoordinate2D(latitude:restaurant.geometry.location.lat , longitude: restaurant.geometry.location.lng)
               marker.title = restaurant.name
     //         marker.snippet = "Lorem"
              marker.map = myMap
               print(restaurant)
           }
           
           
        }
    
}

