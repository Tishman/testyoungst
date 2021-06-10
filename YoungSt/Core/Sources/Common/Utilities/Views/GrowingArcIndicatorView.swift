//
//  File.swift
//  
//
//  Created by Nikita Patskov on 29.04.2021.
//

import SwiftUI
import Resources

public typealias IndicatorView = GrowingArcIndicatorView

public struct PlainIndicatorView: View {
    
    public init(color: Color = Asset.Colors.loaderContent.color.swiftuiColor,
                size: CGFloat = UIFloat(33),
                paddingValue: CGFloat = 0) {
        self.color = color
        self.size = size
        self.paddingValue = paddingValue
    }

    private let size: CGFloat
    private let color: Color
    private let paddingValue: CGFloat
    @State private var animatableParameter: Double = 0

    public var body: some View {
        GrowingArc(percent: animatableParameter)
            .strokeBorder(lineWidth: max(size / UIFloat(15), 1))
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: false),
                       value: animatableParameter)
            .foregroundColor(color)
            .padding(.all, paddingValue)
            .frame(width: size, height: size)
            .onAppear {
                DispatchQueue.main.async {
                    self.animatableParameter = 1
                }
            }
    }
}

public struct GrowingArcIndicatorView: View {
    
    public init(size: CGFloat = UIFloat(60)) {
        self.color = Asset.Colors.loaderContent.color.swiftuiColor
        self.size = size
    }

    private let size: CGFloat
    private let color: Color

    public var body: some View {
        PlainIndicatorView(color: color, size: size, paddingValue: size / 4)
            .background(BlurEffect(style: .systemThickMaterial))
            .clipShape(RoundedRectangle(cornerRadius: .corner(.medium)))
    }
}

struct GrowingArcIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PlainIndicatorView()
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
                .bubbled()
            GrowingArcIndicatorView()
        }
    }
}

struct GrowingArc: InsettableShape {
    
    typealias InsetShape = GrowingArc

    var maxLength = 2 * Double.pi - 0.7
    var lag = 0.35
    var percent: Double
    var inset: CGFloat = 0

    var animatableData: Double {
        get { return percent }
        set { percent = newValue }
    }
    
    func inset(by amount: CGFloat) -> GrowingArc {
        var arc = self
        arc.inset = amount
        return arc
    }

    func path(in rect: CGRect) -> Path {

        let h = percent * 2
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

        var path = Path()
        path.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.width/2),
                    radius: rect.size.width / 2 - inset,
                    startAngle: Angle(radians: start),
                    endAngle: Angle(radians: end),
                    clockwise: true)
        return path
    }
}
