//
//  File.swift
//  
//
//  Created by Alex Nagy on 12.06.2023.
//

import SwiftUI

struct ThumbView<Thumb: View>: View {
    let bounds: ClosedRange<Int>
    let pixelsPerStep: CGFloat
    let offset: Int
    let viewMid: CGFloat
    @Binding var value: ClosedRange<Int>
    let isLower: Bool
    @ViewBuilder var thumb: () -> Thumb
    
    @State private var sliderX: CGFloat = 11
    
    var body: some View {
        thumb()
            .position(x: sliderX, y: viewMid)
            .highPriorityGesture(DragGesture()
                .onChanged({ drag in
                    var location = Int(round((drag.location.x - 11) / pixelsPerStep)) - offset
                    location = max(isLower ? bounds.lowerBound : value.lowerBound + 1, min(isLower ? value.upperBound - 1 : bounds.upperBound, location))
                    
                    value = isLower ? location...value.upperBound : value.lowerBound...location
                    sliderX = CGFloat((isLower ? value.lowerBound : value.upperBound) + offset) * pixelsPerStep + 11
                })
            )
            .onChange(of: pixelsPerStep) { pix in
                sliderX = CGFloat((isLower ? value.lowerBound : value.upperBound) + offset) * pix + 11
            }
            .zIndex((!isLower && value.upperBound == bounds.upperBound) ? 0 : 2)
    }
}
