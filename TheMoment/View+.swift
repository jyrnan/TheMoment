//
//  View+.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/7.
//

import SwiftUI

extension View {
    
    func readGeometry<Key: PreferenceKey, Value>(_ keyPath: KeyPath<GeometryProxy, Value>, key: Key.Type) -> some View where Key.Value == Value {
        overlay{
            GeometryReader {proxy in
                Color.clear
                    .preference(key: key,
                                value: proxy[keyPath: keyPath])
            }
        }
    }
}
