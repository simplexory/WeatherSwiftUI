//
//  HourlyForecastView.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 26.08.23.
//

import SwiftUI

struct HourlyForecastView: View {
    @StateObject var viewModel: HourlyForecastView.ViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HeaderView(systemIcon: "clock", text: "hourly forecast")
            
            Divider()
            
            Text("Some detailed text from the server about weather condition.............")
                .multilineTextAlignment(.leading)
                .font(.caption)
            
            Divider()
                .foregroundColor(.black)
            ScrollView(.horizontal) {
                HStack(alignment: .center) {
                    ForEach(viewModel.hourlySnapshot, id: \.time) { snapshot in
                        VStack(alignment: .center) {
                            Text(snapshot.time.hourFormatted())
                                .font(.callout)
                                .fontWeight(.semibold)
                                .padding(.vertical, 2)
                            
                            CacheAsyncImage(
                                url: snapshot.imageURL
                            ) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                        .scaledToFit()
                                case .failure(let error):
                                    ErrorView(error: error)
                                case .empty:
                                    HStack {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .red))
                                    }
                                @unknown default:
                                    Image(systemName: "questionmark")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .listRowSeparator(.hidden)
                            
                            Spacer()
                            
                            Text(snapshot.temperature.celsiusString)
                                .fontWeight(.medium)
                        }
                    }
                }
            }
            .scrollIndicators(.never)
        }
        .foregroundColor(.white)
        .padding(10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
    }
        
}

struct HourlyForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            HourlyForecastView(viewModel: .mockData)
        }
        .background(.black)
    }
}

extension HourlyForecastView {
    class ViewModel: ObservableObject {
        let currentWeatherSummary: String
        let hourlySnapshot: [WeatherSnapshot]
        
        init(currentWeatherSummary: String, hourlySnapshot: [WeatherSnapshot]) {
            self.currentWeatherSummary = currentWeatherSummary
            self.hourlySnapshot = hourlySnapshot
        }
    }
}

extension HourlyForecastView.ViewModel {
    static var mockData: HourlyForecastView.ViewModel {
        return HourlyForecastView.ViewModel(
            currentWeatherSummary: "Sunny conditions will continue for the reset of the day. Some text continues...........",
            hourlySnapshot: [
                WeatherSnapshot(time: .now, imageURL: URL(string: "https://openweathermap.org/img/wn/04n@2x.png")!, temperature: .C(19)),
                WeatherSnapshot(time: .now.addingTimeInterval(3000), imageURL: URL(string: "https://openweathermap.org/img/wn/02d@2x.png")!, temperature: .C(19)),
                WeatherSnapshot(time: .now.addingTimeInterval(6000), imageURL: URL(string: "https://openweathermap.org/img/wn/02n@2x.png")!, temperature: .C(16)),
                WeatherSnapshot(time: .now.addingTimeInterval(9000), imageURL: URL(string: "https://openweathermap.org/img/wn/03n@2x.png")!, temperature: .C(10)),
                WeatherSnapshot(time: .now.addingTimeInterval(12000), imageURL: URL(string: "https://openweathermap.org/img/wn/03d@2x.png")!, temperature: .C(-20)),
                WeatherSnapshot(time: .now.addingTimeInterval(15000), imageURL: URL(string: "https://openweathermap.org/img/wn/04d@2x.png")!, temperature: .C(21)),
                WeatherSnapshot(time: .now.addingTimeInterval(18000), imageURL: URL(string: "https://openweathermap.org/img/wn/01n@2x.png")!, temperature: .C(12)),
                WeatherSnapshot(time: .now.addingTimeInterval(21000), imageURL: URL(string: "https://openweathermap.org/img/wn/02d@2x.png")!, temperature: .C(19)),
            ]
        )
    }
}
