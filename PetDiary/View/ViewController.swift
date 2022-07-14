//
//  ViewController.swift
//  PetDiary
//
//  Created by jeanwei on 2022/6/3.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces
import GoogleMapsUtils



class ViewController: UIViewController ,CLLocationManagerDelegate, UITableViewDataSource,GMSMapViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listResponse?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ListmapTableViewCell.self)", for: indexPath) as! ListmapTableViewCell
        let item = listResponse?.results[indexPath.row]
        cell.nameLabel.text = item?.name
        cell.addressLabel.text = item?.vicinity
        //測試
//        var ada = item?.geometry.location.lat
//        var log = item?.geometry.location.lng
//        print("ada=\(ada)\(log)")
        let localat = item?.geometry.location.lat ?? 25.04174
        let localng = item?.geometry.location.lng ?? 121.56661
        let locationitem = [localat,localng]
        print(locationitem)


                    let MedPositon = CLLocationCoordinate2D(latitude: localat, longitude: localng)
                    let MedMarker = GMSMarker()
                    MedMarker.position = MedPositon
        MedMarker.title = item?.name
                    MedMarker.map = mapView
                    print(MedPositon)
       
     
       
                
        return cell
    }
    

   
    
    //建立一個CLLocationManager
    var myLocationManager = CLLocationManager()
//    var location = "25.04174,121.56661"//座標預設為台北市
    var location = ""
    var listResponse: ListResponse?
    var searchBarLabel: String?
    let listController = GoogleMapApi()
    var photos: [PhotosResults]?
    var item: itemResults!
    var detail: DetailResponse?


    @IBOutlet weak var listSearchBar: UISearchBar!
    @IBOutlet weak var mapTableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        listSearchBar.delegate = self
        mapTableView.dataSource = self
        listSearchBar.text = searchBarLabel
        mapView.delegate = self
        myLocationManager.delegate = self
        myLocationManager.requestWhenInUseAuthorization()
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.startUpdatingLocation()

        let camera = GMSCameraPosition.camera(withLatitude: 25.034012, longitude: 121.564461, zoom: 15.0)
        mapView.camera = camera
    self.mapView.isMyLocationEnabled = true //開啟我的位置
        
        
        }
    
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.delegate = nil
        let currentLocation = locations.first!
        location = "\(String(currentLocation.coordinate.latitude)),\(String(currentLocation.coordinate.longitude))"
//        GoogleMapApi.shared.fetchNearbySearch(location: location, keyword: searchBarLabel ?? "" ) {listresponse in
//
//            self.listResponse = listresponse
//            DispatchQueue.main.async {
//
//                self.mapTableView.reloadData()
//
//            }
           
           
        
        
//        print("Current location: \(currentLocation.coordinate.latitude) \(currentLocation.coordinate.longitude)\n\(location)")
        if let location = locations.first {
              CATransaction.begin()
              CATransaction.setValue(Int(2), forKey: kCATransactionAnimationDuration)
              mapView.animate(toLocation: location.coordinate)
              mapView.animate(toZoom: 12)
              CATransaction.commit()
              myLocationManager.stopUpdatingLocation()
            }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    func hideActivityIndicatorView() { mapTableView.isHidden = true }
    func showActivityIndicatorView() { mapTableView.isHidden = false }
 
}
//SearchBar
extension ViewController: UISearchBarDelegate{
    
    //搜尋文字改變時會觸發
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        //搜尋時跳出loading
        
        searchBarLabel = searchText
        
        GoogleMapApi.shared.fetchNearbySearch(location: location, keyword: searchText){ [self]listresponse in
            
            self.listResponse = listresponse
           
            DispatchQueue.main.async { [self] in
             
             self.mapTableView.reloadData()
               
            }
           
        }
    
        
    }
    
    //點擊search後會觸發
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //收鍵盤
       searchBar.resignFirstResponder()
//        mapView.clear()
        if searchBar.text?.count == 0 {
            mapView.clear()
            self.hideActivityIndicatorView()
        }else{
            self.showActivityIndicatorView()
        }
    }
  
}

