//
//  MapViewModel.swift
//  TheMoment
//
//  Created by jyrnan on 2023/3/4.
//

import MapKit

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
  @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3315, longitude: -121.89),
                                             span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
  @Published var authorizationStatus: CLAuthorizationStatus?
  
  var locationManager = CLLocationManager()
  
  override init() {
    super.init()
    locationManager.delegate = self
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
         switch manager.authorizationStatus {
         case .authorizedWhenInUse:  // Location services are available.
             // Insert code here of what should happen when Location services are authorized
           authorizationStatus = .authorizedWhenInUse
             break
             
         case .restricted:  // Location services currently unavailable.
             // Insert code here of what should happen when Location services are NOT authorized
           authorizationStatus = .restricted
             break
             
         case .denied:  // Location services currently unavailable.
             // Insert code here of what should happen when Location services are NOT authorized
           authorizationStatus = .denied
             break
             
         case .notDetermined:        // Authorization not determined yet.
           authorizationStatus = .notDetermined
             manager.requestWhenInUseAuthorization()
             break
             
         default:
             break
         }
     }
     
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
//       DispatchQueue.main.async {
//         guard let location = locations.first else {return}
//         self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//       }
           
       
     }
     
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error: \(error.localizedDescription)")
     }
     
  
}
