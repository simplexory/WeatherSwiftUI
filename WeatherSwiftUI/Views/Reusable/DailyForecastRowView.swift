//
//  DailyForecastRowView.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 26.08.23.
//

import SwiftUI

struct DailyForecastRowView: View {
    @StateObject var viewModel: DailyForecastRowView.ViewModel
    
    var gradientColors: [Color] {
        return [
            Color(red: 0.39, green: 0.8, blue: 0.74),
            Color(red: 0.96, green: 0.8, blue: 0.0)
        ]
    }
    
    var gradient: LinearGradient {
        return LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing)
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Text(viewModel.dayTime.uppercased())
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.leading, 15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
            
            Spacer()
            
            CacheAsyncImage(
                url: viewModel.icon
            ) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .trailing)
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
            .frame(maxWidth: .infinity, alignment: .trailing)
            .listRowSeparator(.hidden)
            .padding(.trailing, 15)
            
            Spacer()
            
            Text(viewModel.minTemp.celsiusString)
                .font(.title2)
            
            ProgressView(value: 0.5, total: 1.0)
                .progressViewStyle(
                    CustomazibleProgressView(
                        range: 0...1,
                        foregroundColor: AnyShapeStyle(gradient),
                        backgroundColor: Color(red: 0.25, green: 0.35, blue: 0.72)
                            .opacity(0.2),
                        isShowCircle: true
                    )
                )
                .frame(maxWidth: 100, maxHeight: 6)
                .padding(.horizontal, 10)
            
            Text(viewModel.maxTemp.celsiusString)
                .font(.title2)
        }
        .padding(.vertical, 2)
        
        Divider()
    }
}

struct DailyForecastRowView_Previews: PreviewProvider {
    static var previews: some View {
        DailyForecastRowView(viewModel: .mockData)
            .preferredColorScheme(.dark)
    }
}

extension DailyForecastRowView {
    class ViewModel: ObservableObject {
        let dayTime: String
        let icon: URL
        let minTemp: Temperature
        let maxTemp: Temperature
        
        init(dayTime: String, icon: String, minTemp: Temperature, maxTemp: Temperature) {
//            guard let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else { return }
            self.dayTime = dayTime
            self.icon = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")!
            self.minTemp = minTemp
            self.maxTemp = maxTemp
        }
    }
}

extension DailyForecastRowView.ViewModel {
    static var mockData: DailyForecastRowView.ViewModel {
        return DailyForecastRowView.ViewModel(
            dayTime: "Thursdaday".uppercased(),
            icon: "02d",
            minTemp: .C(24),
            maxTemp: .C(30)
        )
    }
}
