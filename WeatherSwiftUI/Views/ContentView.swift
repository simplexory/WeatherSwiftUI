//
//  ContentView.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 22.08.23.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            Text("WEATHER")
        }
        .preferredColorScheme(.dark)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(WeatherViewModel())
    }
}
