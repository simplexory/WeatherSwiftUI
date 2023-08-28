//
//  CityView.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 27.08.23.
//

import SwiftUI

struct CityView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Gradient(colors: [.indigo, .purple]))
                .ignoresSafeArea()
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("My Location")
                        .font(.title)
                        .bold()
                    Text("21:10")
                        .bold()
                    
                    Spacer()
                    
                    Text("Conddition")
                        .bold()
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(Temperature.C(21).celsiusString)
                        .font(.system(size: 60))
                        .fontDesign(.monospaced)
                        .bold()
                    
                    Spacer()
                    
                    HStack {
                        Text("H:\(Temperature.C(22).celsiusString)")
                            .fontDesign(.monospaced)
                            .bold()
                        Text("L:\(Temperature.C(13).celsiusString)")
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
        CityView()
            .preferredColorScheme(.dark)
    }
}
