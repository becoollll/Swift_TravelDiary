//
//  MapView.swift
//  TravelDiary
//
//  Created by 鄭宇婕 on 2023/12/26.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    var location: String = ""
    
    //get region with testing
    @State private var region : MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.510357, longitude: -0.116773), span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
    
    //get a annotation with testing
    @State private var annotatedItem: AnnotatedItem = AnnotatedItem(coordinate: CLLocationCoordinate2D(latitude: 51.510357, longitude: -0.116773))
    
    private func convertAddress(location: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location, completionHandler: {
            placemarks, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let placemarks = placemarks,
                  let target = placemarks[0].location else {
                return
            }
            self.region = MKCoordinateRegion(center: target.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015))
            self.annotatedItem = AnnotatedItem(coordinate: target.coordinate)
        })
    }
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [annotatedItem]) { item in
            MapMarker(coordinate: item.coordinate, tint: .red)}
            .onAppear {
                convertAddress(location: location)
            }
    }
}

struct AnnotatedItem: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(location: "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong")
    }
}

