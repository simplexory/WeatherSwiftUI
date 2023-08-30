//
//  ContentView.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 27.08.23.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showAlert = false
    @State private var isPresented = false
    @State private var isSaved = false
    
    var isShowingModal = false
    
    var body: some View {
        VStack {
            if viewModel.observedWeather != nil {
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
                    
                    if !isSaved {
                        Button("+") {
                            isSaved.toggle()
                            viewModel.saveObservedCity()
                        }
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    } else {
                        Button("✓") {
                            isSaved.toggle()
                            viewModel.removeObservedCity()
                        }
                        .font(.largeTitle)
                        .foregroundColor(.green)
                    }
                }
                .padding(.leading, 15)
                .padding(.trailing, 15)
                
                WeatherDetailView()
                    .onAppear {
                        isSaved = viewModel.cityIsSaved(cityName: viewModel.observedWeather?.city ?? "")
                    }
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
                message: Text(viewModel.error?.localizedDescription ?? ""),
                dismissButton: Alert.Button.cancel(Text("Cancel"), action: {
                    viewModel.removeError()
                    dismiss()
                })
            )
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
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
