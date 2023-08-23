//
//  LoadingView.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 23.08.23.
//

import SwiftUI

struct LoadingDataView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
    }
}

struct LoadingDataView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingDataView()
    }
}
