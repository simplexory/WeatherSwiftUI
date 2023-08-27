//
//  CustomazibleProgressView.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 26.08.23.
//

import SwiftUI

struct CustomazibleProgressView: ProgressViewStyle {
    let range: ClosedRange<Double>
    let foregroundColor: AnyShapeStyle
    let backgroundColor: Color
    let isShowCircle: Bool
    
    var fillWidthScale: Double {
        let normilizedRange = range.upperBound - range.lowerBound
        return Double(normilizedRange)
    }
    
    func makeBody(configuration: Configuration) -> some View {
        return GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(backgroundColor)
                
                Capsule()
                    .fill(foregroundColor)
                    .frame(width: proxy.size.width * fillWidthScale)
                    .offset(x: proxy.size.width * range.lowerBound)
                
                if isShowCircle {
                    Circle()
                        .foregroundColor(backgroundColor)
                        .frame(
                            width: proxy.size.height + 4.0,
                            height: proxy.size.height + 4.0
                        )
                        .position(
                            x: proxy.size.width * (configuration.fractionCompleted ?? 0.0),
                            y: proxy.size.height / 2.0
                        )
                    Circle()
                        .foregroundColor(.white)
                        .position(
                            x: proxy.size.width * (configuration.fractionCompleted ?? 0.0),
                            y: proxy.size.height / 2.0
                        )
                }
            }
            .clipped()
        }
    }
}

struct CustomazibleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                ForEach(0...10, id: \.self) { value in
                    let range = 0.0...Double(value) / 10.0
                    let gradient = LinearGradient(colors: [.yellow, .orange], startPoint: .leading, endPoint: .trailing)
                    
                    ProgressView(value: 0.5)
                        .frame(height: 10)
                        .progressViewStyle(
                            CustomazibleProgressView(
                                range: range,
                                foregroundColor: AnyShapeStyle(gradient),
                                backgroundColor: .gray,
                                isShowCircle: true
                            )
                        )
                }
                
                Divider()
                
                ForEach(0...10, id: \.self) { value in
                    let range = (Double(value) / 10.0)...1.0
                    let gradient = LinearGradient(colors: [.orange, .yellow], startPoint: .leading, endPoint: .trailing)
                    
                    ProgressView(value: 0.5)
                        .frame(height: 10)
                        .progressViewStyle(
                            CustomazibleProgressView(
                                range: range,
                                foregroundColor: AnyShapeStyle(gradient),
                                backgroundColor: .gray,
                                isShowCircle: false
                            )
                        )
                }
            }
        }
        .padding()
    }
}
