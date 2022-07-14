//
//  petFriendMKAnnotation.swift
//  PetDiary
//
//  Created by jeanwei on 2022/6/7.
//

import Foundation
import MapKit

class StoreAnnotation : NSObject, MKAnnotation {
    var photos: [PhotosResults]?
    var item: itemResults!
    var detail: DetailResponse?
    
    var coordinate: CLLocationCoordinate2D
        var title: String? {
            item?.name
        }
        var subtitle: String? {
            item?.vicinity
        }
        var store: itemResults?
        
        init(feature: MKGeoJSONFeature) {
            coordinate = feature.geometry[0].coordinate
            if let data = feature.properties, let store = try? JSONDecoder().decode(itemResults.self, from: data) {
                self.store = store
            }
        }
    
}

