//
//  RangeSlider.swift
//
//
//  Created by Alex Nagy on 12.06.2023.
//

import SwiftUI

public struct RangeSlider<Track: View, LeftThumb: View, RightThumb: View>: View {
    
    @Binding var value: ClosedRange<Int>
    let bounds: ClosedRange<Int>
    @ViewBuilder var track: () -> Track
    @ViewBuilder var leftThumb: () -> LeftThumb
    @ViewBuilder var rightThumb: () -> RightThumb
    
    /// A control for selecting two values from a bounded linear range of values.
    ///
    /// A slider consists of two "thumb" `View`s that the user moves between two
    /// extremes of a linear "track". The ends of the track represent the minimum
    /// and maximum possible values. As the user moves the thumbs, the slider
    /// updates its bound value.
    ///
    /// - Parameters:
    ///   - value: The selected value within `bounds`.
    ///   - bounds: The range of the valid values. Defaults to `0...100`.
    ///   - track: The track `View`.
    ///   - leftThumb: The left thumb `View`.
    ///   - rightThumb: The right thumb `View`.
    public init(_ value: Binding<ClosedRange<Int>>, bounds: ClosedRange<Int> = ClosedRange(uncheckedBounds: (0, 100)), track: @escaping () -> Track, leftThumb: @escaping () -> LeftThumb, rightThumb: @escaping () -> RightThumb) {
        self._value = value
        self.bounds = bounds
        self.track = track
        self.leftThumb = leftThumb
        self.rightThumb = rightThumb
    }
    
    @State private var viewSize: CGSize = .zero
    
    public var body: some View {
        let pixelsPerStep = (viewSize.width - 22) / CGFloat(bounds.count - 1)
        let offset = -bounds.lowerBound
        ZStack {
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        viewSize = geo.size
                    }
            }
            
            track()
                .frame(width: viewSize.width)
            
            ThumbView(bounds: bounds,
                      pixelsPerStep: pixelsPerStep,
                      offset: offset,
                      viewMid: viewSize.height / 2,
                      value: $value,
                      isLower: true) {
                leftThumb()
            }
            
            ThumbView(bounds: bounds,
                      pixelsPerStep: pixelsPerStep,
                      offset: offset,
                      viewMid: viewSize.height / 2,
                      value: $value,
                      isLower: false) {
                rightThumb()
            }
        }
    }
}
