//
//  TempView.swift
//  TravelDiary
//
//  Created by 鄭宇婕 on 2023/12/27.
//

import SwiftUI
import CoreLocation

struct TempView: View {
    var item: Item

    @State private var locationCode: String?
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var forecastData: ForecastData?
    @State private var currentWeatherData: CurrentWeatherData?
    @State private var cityName: String?

    var body: some View {
        VStack {
            Text(" \(Int(currentWeatherData?.main?.temp ?? 0.0)) °C")
                 .font(.custom("SpecialElite-Regular", size: 30))
                 .bold()
            Text(cityName ?? "Unknown") // Display the city name in the title
                .bold()

        }
        .onAppear {
            getcode(address: item.add)
        }
    }

    func getcode(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first {
                latitude = placemark.location?.coordinate.latitude ?? 0.0
                longitude = placemark.location?.coordinate.longitude ?? 0.0
                locationCode = "Lat: \(latitude), Lon: \(longitude)"

                // Reverse geocoding to get city name
                geocoder.reverseGeocodeLocation(placemark.location!) { placemarks, error in
                    if let placemark = placemarks?.first {
                        cityName = placemark.locality ?? "Unknown"
                        
                        // After getting the location details, trigger the API request
                        getCurrentWeather(apiKey: "PUT_API_HERE", latitude: latitude, longitude: longitude)
                    }
                }
            } else {
                locationCode = "Unable to get location code"
            }
        }
    }

    func getCurrentWeather(apiKey: String, latitude: Double, longitude: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
                print(currentWeatherData)
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}

struct TempView_Previews: PreviewProvider {
    @State static var item = Item(name: "Cafe Deadend", date: Date(), tel: "232-923423", add: "No. 79, Zhiguang St., Shoufeng Township, Hualien County 974 , Taiwan (R.O.C.)", comment: "very good", isFavorite: false, rating: 4)

    static var previews: some View {
        TempView(item: item)
    }
}
