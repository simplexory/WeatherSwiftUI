//
//  ContentView.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 27.08.23.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    @State private var showAlert = false
    @State var cityIsSaved = false
    @State private var isPresented = false
    @State var isShowingModal = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                if isShowingModal {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: isShowingModal ? "arrow.backward" : "list.bullet")
                            .resizable()
                            .frame(width: 30, height: 20)
                            .foregroundColor(.white)
                    }
                } else {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: isShowingModal ? "arrow.backward" : "list.bullet")
                            .resizable()
                            .frame(width: 30, height: 20)
                            .foregroundColor(.white)
                    }
                    .fullScreenCover(isPresented: $isPresented) {
                        CitiesListView()
                    }
                }
                
                Spacer()
                
                if !cityIsSaved {
                    Button("+") {
                        cityIsSaved.toggle()
                        // do
                    }
                    .font(.largeTitle)
                    .foregroundColor(.white)
                } else {
                    Button("✓") {
                        cityIsSaved.toggle()
                        // do
                    }
                    .font(.largeTitle)
                    .foregroundColor(.green)
                }
            }
            .padding(.leading, 15)
            .padding(.trailing, 15)
            
            if viewModel.observedWeather != nil {
                WeatherDetailView()
            } else {
                LoadingDataView()
            }
        }
        .onReceive(viewModel.$error, perform: { error in
            if error != nil {
                showAlert.toggle()
            }
        })
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.error?.localizedDescription ?? "")
            )
        }
        .onSubmit {
            viewModel.removeError()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            HStack {
                Spacer()
                
                WeatherView().environmentObject({ () -> WeatherViewModel in
                    let viewModel = WeatherViewModel(mock: true)
                    viewModel.locationDataManager.authorizationStatus = .authorizedWhenInUse
                    viewModel.observedWeather = Weather(
                        mockCurrentWeather: previewCurrentWeather,
                        mockDailyWeather: previewDailyWeather
                    )
                    return viewModel
                }() )
                
                Spacer()
            }
            .padding(.top, 10)
        }
        .preferredColorScheme(.dark)
    }
}
