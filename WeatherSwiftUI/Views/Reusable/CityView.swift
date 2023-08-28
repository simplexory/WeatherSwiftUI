//
//  CityView.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 27.08.23.
//

import SwiftUI

struct CityView: View {
    @StateObject var viewModel: CityView.ViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Gradient(colors: [.indigo, .purple]))
                .ignoresSafeArea()
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(viewModel.name)
                        .font(.title)
                        .bold()
                    Text(viewModel.time)
                        .bold()
                    
                    Spacer()
                    
                    Text(viewModel.condition)
                        .bold()
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(viewModel.temperature.celsiusString)
                        .font(.system(size: 60))
                        .fontDesign(.monospaced)
                        .bold()
                    
                    Spacer()
                    
                    HStack {
                        Text("H:\(viewModel.maxTemp.celsiusString)")
                            .fontDesign(.monospaced)
                            .bold()
                        Text("L:\(viewModel.minTemp.celsiusString)")
                            .fontDesign(.monospaced)
                            .bold()
                    }
                }
            }
            .padding(8)
        }
        .frame(height: 120).cornerRadius(10)
        
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        CityView(viewModel: .mockData)
            .preferredColorScheme(.dark)
    }
}

extension CityView {
    class ViewModel: ObservableObject {
        let name: String
        let time: String
        let temperature: Temperature
        let minTemp: Temperature
        let maxTemp: Temperature
        let condition: String
        
        init(name: String, time: String, temperature: Temperature, minTemp: Temperature, maxTemp: Temperature, condition: String) {
            self.name = name
            self.time = time
            self.temperature = temperature
            self.minTemp = minTemp
            self.maxTemp = maxTemp
            self.condition = condition
        }
    }
}

extension CityView.ViewModel {
    static var mockData: CityView.ViewModel {
        return CityView.ViewModel(
            name: "Paris",
            time: "21:22",
            temperature: .C(21),
            minTemp: .C(17),
            maxTemp: .C(25),
            condition: "Good weather"
        )
    }
}
