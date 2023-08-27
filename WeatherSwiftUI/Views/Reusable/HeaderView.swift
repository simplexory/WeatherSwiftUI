//
//  HeaderView.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 26.08.23.
//

import SwiftUI

struct HeaderView: View {
    var systemIcon: String
    var text: String
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: systemIcon)
                .padding(.leading, 10)
            Text(text.uppercased())
        }
        .foregroundColor(.white.opacity(0.65))
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(systemIcon: "list.clipboard", text: "10-day forecast")
            .background(.black)
    }
}
