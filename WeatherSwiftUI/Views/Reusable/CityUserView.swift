//
//  CityUserView.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 30.08.23.
//

import SwiftUI

struct CityUserView: View {
    @StateObject var viewModel: CityUserView.ViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Gradient(colors: [.indigo, .purple]))
                .ignoresSafeArea()
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("User Location")
                        .font(.title)
                        .bold()
                    Text(viewModel.name)
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

struct CityUserView_Previews: PreviewProvider {
    static var previews: some View {
        CityUserView(viewModel: .mockData)
            .preferredColorScheme(.dark)
    }
}

extension CityUserView {
    class ViewModel: ObservableObject {
        let name: String
        let temperature: Temperature
        let minTemp: Temperature
        let maxTemp: Temperature
        let condition: String
        
        init(name: String, temperature: Temperature, minTemp: Temperature, maxTemp: Temperature, condition: String) {
            self.name = name
            self.temperature = temperature
            self.minTemp = minTemp
            self.maxTemp = maxTemp
            self.condition = condition
        }
    }
}

extension CityUserView.ViewModel {
    static var mockData: CityUserView.ViewModel {
        return CityUserView.ViewModel(
            name: "Vitebsk",
            temperature: .C(21),
            minTemp: .C(17),
            maxTemp: .C(25),
            condition: "Good weather"
        )
    }
}
