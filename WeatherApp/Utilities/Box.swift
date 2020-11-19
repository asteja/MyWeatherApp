//
//  Box.swift
//  WeatherApp
//
//  Created by Saiteja Alle on 11/17/20.
//  Copyright © 2020 Saiteja Alle. All rights reserved.
//

import Foundation

final class Box<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }
  
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
