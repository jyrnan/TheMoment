//
//  EditCommitView+Location.swift
//  TheMoment
//
//  Created by jyrnan on 2023/3/4.
//

import Foundation
import MapKit

extension EditCommitViewModel: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch locationManager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      locationManager.requestLocation()
    case .denied:
      break //TODO: -
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    default:
      break
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           DispatchQueue.main.async {
             guard let location = locations.first else {return}
             self.lookUpCurrentLocation{placemark in
               print(placemark)
             }
             self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
           }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("error: \(error.localizedDescription)")
  }
  
  func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
                  -> Void ) {
      // Use the last reported location.
      if let lastLocation = self.locationManager.location {
          let geocoder = CLGeocoder()
              
          // Look up the location and pass it to the completion handler
          geocoder.reverseGeocodeLocation(lastLocation,
                      completionHandler: { (placemarks, error) in
              if error == nil {
//                  let firstLocation = placemarks?[0]
//                  completionHandler(firstLocation)
                placemarks?.forEach(completionHandler)
              }
              else {
             // An error occurred during geocoding.
                  completionHandler(nil)
              }
          })
      }
      else {
          // No location was available.
          completionHandler(nil)
      }
  }
}
