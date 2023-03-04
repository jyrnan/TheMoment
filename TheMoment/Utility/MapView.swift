//
//  MapView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/3/4.
//

import MapKit
import SwiftUI

struct MapView: View {
//  @StateObject var vm = MapViewModel()
//  @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 1),
//                                         span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
  @Binding var region: MKCoordinateRegion
  var body: some View {
    Map(coordinateRegion: $region, showsUserLocation: true)
      .ignoresSafeArea()
      .tint(.accentColor)
  }
}

struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    MapView(region: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3315, longitude: -121.89),
                                                 span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))))
  }
}
