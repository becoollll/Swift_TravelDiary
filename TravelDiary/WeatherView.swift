//
//  WeatherView.swift
//  TravelDiary
//
//  Created by 鄭宇婕 on 2023/12/26.
//

import SwiftUI
import CoreLocation

struct WeatherView: View {
    var item: Item
    
    @State private var locationCode: String?
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var forecastData: ForecastData?
    @State private var currentWeatherData: CurrentWeatherData?
    @State private var cityName: String?
    
    var body: some View {
        ZStack{
            Color.c2
                .ignoresSafeArea()
            VStack {
                Text(cityName ?? "Unknown") // Display the city name in the title
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.bg)
                    .padding(20)
                
                Text("Current Temperature")
                    .foregroundColor(Color.c1)
                
                Text(" \(Int(currentWeatherData?.main?.temp ?? 0.0)) °C")
                    .font(.system(size: 60))
                    .foregroundColor(Color.white)
                    .bold()
                    .padding(.top,10)
                    .padding(.bottom,20)
                
                if let forecastData = forecastData {
                    let groupedForecasts = Dictionary(grouping: forecastData.list ?? [], by: { Calendar.current.startOfDay(for: $0.date ?? Date()) })
                    
                    
                    HStack(alignment: .center) {
                        VStack{
                            ForEach(Array(groupedForecasts.keys.sorted(by: <)), id: \.self) { (date: Date) in
                                Text(formattedDate(date))
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.c1)
                                    .frame(width: 100, height: 30)
                                    .bold()
                            }
                        }
                        VStack{
                            ForEach(Array(groupedForecasts.keys.sorted(by: <)), id: \.self) { (date: Date) in
                                if let dailyForecasts = groupedForecasts[date],
                                   let weatherConditions = dailyForecasts.first?.weather?.first?.main {
                                        getWeatherIcon(weatherConditions)
                                            .font(.system(size: 22))
                                            .foregroundColor(getWeatherColor(weatherConditions))
                                            .frame(width: 50, height: 30)
                                }
                            }
                        }
                        VStack{
                            ForEach(Array(groupedForecasts.keys.sorted(by: <)), id: \.self) { (date: Date) in
                                if let dailyForecasts = groupedForecasts[date],
                                   let maxTemperature = dailyForecasts.max(by: { ($0.main?.temp ?? 0.0) < ($1.main?.temp ?? 0.0) })?.main?.temp,
                                   let minTemperature = dailyForecasts.min(by: { ($0.main?.temp ?? 0.0) < ($1.main?.temp ?? 0.0) })?.main?.temp {
                                    Text("\(Int(minTemperature)) ° ~ \(Int(maxTemperature)) °")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color.c1)
                                        .frame(width: 150, height: 30)
                                        .bold()
                                }
                            }
                        }
                    }


                } else {
                    Text("Forecast not available")
                }
                Text("USING OPENWEATHER API")
                    .foregroundColor(Color.c3)
                    .padding(.top, 50)

            }
            .onAppear {
                getWeatherData(apiKey: "PUT_API_HERE", address: item.add)
                getCurrentWeather(apiKey: "PUT_API_HERE", latitude: latitude, longitude: longitude)
            }
            
        }
        
    }

    func getWeatherData(apiKey: String, address: String) {
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
                    }
                }

                // Get the time zone based on the coordinates
                if let timeZone = TimeZone(identifier: placemark.timeZone?.identifier ?? "") {
                    // Set the time zone for formatting dates
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = timeZone
                    // Call the function to get weather forecast after obtaining latitude, longitude, and city name
                    getWeatherForecast(apiKey: apiKey, latitude: latitude, longitude: longitude)
                    getCurrentWeather(apiKey: apiKey, latitude: latitude, longitude: longitude)
                } else {
                    print("Unable to determine time zone")
                }
            } else {
                locationCode = "Unable to get location code"
            }
        }
    }

    // address to code
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
                    }
                }

                // Get the time zone based on the coordinates
                if let timeZone = TimeZone(identifier: placemark.timeZone?.identifier ?? "") {
                    // Set the time zone for formatting dates
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = timeZone
                    // Call the function to get weather forecast after obtaining latitude, longitude, and city name
                    getWeatherForecast(apiKey: "PUT_API_HERE", latitude: latitude, longitude: longitude)
                } else {
                    print("Unable to determine time zone")
                }
            } else {
                locationCode = "Unable to get location code"
            }
        }
    }

    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E d" // Adjust the date format to "Tue, Dec 26"
        dateFormatter.timeZone = TimeZone.current // Use the local time zone
        return dateFormatter.string(from: date)
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

    func getWeatherForecast(apiKey: String, latitude: Double, longitude: Double) {
        // Construct the URL for the 5-day forecast API request
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        // Create a URLSession instance
        let session = URLSession.shared

        // Create a data task
        let task = session.dataTask(with: url) { (data, response, error) in
            // Check for errors
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            // Check if data is received
            guard let data = data else {
                print("No data received")
                return
            }

            do {
                // Parse JSON data using the Codable protocol
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                forecastData = try decoder.decode(ForecastData.self, from: data)
                print(forecastData)
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }

        // Start the task
        task.resume()
    }
    
    

    func getWeatherColor(_ weatherConditions: String) -> Color {
        switch weatherConditions {
        case "Clear":
            return Color.ed
        case "Rain":
            return Color.wea
        case "Clouds":
            return Color.bg
        // Add more cases for other weather conditions as needed
        default:
            return Color.black
        }
    }
    func getWeatherIcon(_ weatherConditions: String) -> Image {
        switch weatherConditions {
        case "Clear":
            return Image(systemName: "sun.max.fill")
        case "Rain":
            return Image(systemName: "cloud.rain.fill")
        case "Clouds":
            return Image(systemName: "cloud.fill")
        case "Thunderstorm":
            return Image(systemName: "cloud.bolt.fill")
        case "Drizzle":
            return Image(systemName: "cloud.drizzle.fill")
        case "Snow":
            return Image(systemName: "snowflake")
        case "Mist":
            return Image(systemName: "cloud.fog.fill")
        case "Smoke":
            return Image(systemName: "smoke.fill")
        case "Haze":
            return Image(systemName: "sun.haze.fill")
        case "Dust":
            return Image(systemName: "sun.dust.fill")
        case "Fog":
            return Image(systemName: "cloud.fog.fill")
        case "Squall":
            return Image(systemName: "tornado")
        case "Tornado":
            return Image(systemName: "tornado")
        default:
            return Image(systemName: "questionmark")
        }
    }
}

struct ForecastData: Codable {
    let list: [Forecast]?
}

struct Forecast: Codable, Identifiable {
    let id = UUID()  // Use a UUID as the identifier
    let main: Main?
    let dt_txt: String?
    let weather: [Weather]?
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: dt_txt ?? "")
    }

    // Implement Decodable and Encodable methods
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.main = try container.decode(Main.self, forKey: .main)
        self.dt_txt = try container.decode(String.self, forKey: .dt_txt)
        self.weather = try container.decode([Weather].self, forKey: .weather)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(main, forKey: .main)
        try container.encode(dt_txt, forKey: .dt_txt)
        try container.encode(weather, forKey: .weather)
    }

    enum CodingKeys: String, CodingKey {
        case main, dt_txt, weather
    }
}

struct Weather: Codable {
    let main: String?
}
struct Main: Codable {
    let temp: Double?
}
struct CurrentWeatherData: Codable {
    let main: Main?
}

extension DateFormatter {
    static var iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

struct WeatherView_Previews: PreviewProvider {
    @State static var item = Item(name: "Cafe Deadend", date: Date(), tel: "232-923423", add: "No. 79, Zhiguang St., Shoufeng Township, Hualien County 974 , Taiwan (R.O.C.)", comment: "very good", isFavorite: false, rating: 4)

    static var previews: some View {
        WeatherView(item: item)
    }
}
