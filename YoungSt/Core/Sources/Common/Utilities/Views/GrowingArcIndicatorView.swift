//
//  File.swift
//  
//
//  Created by Nikita Patskov on 29.04.2021.
//

import SwiftUI
import Resources

public typealias IndicatorView = GrowingArcIndicatorView
public struct GrowingArcIndicatorView: View {
    
    public init() {
        self.color = Asset.Colors.loaderContent.color.swiftuiColor
    }
    

    private let color: Color
    @State private var animatableParameter: Double = 0

    public var body: some View {
        let animation = Animation
            .easeInOut(duration: 2)
            .repeatForever(autoreverses: false)
        
        return GrowingArc(p: animatableParameter)
            .stroke(color, lineWidth: 3)
            .padding()
            .background(BlurEffect(style: .systemThickMaterial))
            .clipShape(RoundedRectangle(cornerRadius: .corner(.medium)))
            .frame(width: 60, height: 60)
            .onAppear {
                DispatchQueue.main.async {
                    withAnimation(animation) {
                        self.animatableParameter = 1
                    }
                }
            }
    }
}

struct GrowingArcIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        GrowingArcIndicatorView()
    }
}

struct GrowingArc: Shape {

    var maxLength = 2 * Double.pi - 0.7
    var lag = 0.35
    var p: Double

    var animatableData: Double {
        get { return p }
        set { p = newValue }
    }

    func path(in rect: CGRect) -> Path {

        let h = p * 2
        var length = h * maxLength
        if h > 1 && h < lag + 1 {
            length = maxLength
        }
        if h > lag + 1 {
            let coeff = 1 / (1 - lag)
            let n = h - 1 - lag
            length = (1 - n * coeff) * maxLength
        }

        let first = Double.pi / 2
        let second = 4 * Double.pi - first

        var end = h * first
        if h > 1 {
            end = first + (h - 1) * second
        }

        let start = end + length

        var p = Path()
        p.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.width/2),
                 radius: rect.size.width/2,
                 startAngle: Angle(radians: start),
                 endAngle: Angle(radians: end),
                 clockwise: true)
        return p
    }
}
