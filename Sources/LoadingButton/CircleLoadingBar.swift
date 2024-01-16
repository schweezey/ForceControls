//
//  CircleLoadingBar.swift
//
//
//  Created by Josh McBroom on 1/16/24.
//

import SwiftUI

struct CircleLoadingBar: View {
    @State private var isRotating = 0.0
    @State var style: LoadingButtonStyle
    
    var body: some View {
        Circle()
            .trim(from: 0.0, to: 0.2)
            .stroke(style.strokeColor, style: StrokeStyle(lineWidth: style.strokeWidth, lineCap: .round, lineJoin: .round))
            .frame(width: style.height - 20, height: style.height - 20)
            .rotationEffect(.degrees(isRotating))
            .onAppear() {
                withAnimation(.linear(duration: 1.0)
                    .speed(1.5).repeatForever(autoreverses: false)) {
                        self.isRotating = 360.0
                    }
            }
    }
}
