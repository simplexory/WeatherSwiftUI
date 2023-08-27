//
//  ErrorView.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 26.08.23.
//

import SwiftUI

struct ErrorView: View {
    let error: Error

    var body: some View {
        print(error)
        return Text("❌").font(.system(size: 10))
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: WeatherFetchError.invalidURL)
    }
}
