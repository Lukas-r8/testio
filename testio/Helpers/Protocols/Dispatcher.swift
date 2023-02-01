//
//  Dispatcher.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 01.02.23.
//

import Foundation

protocol Dispatcher {
    func async(execute work: @escaping () -> Void)
}

extension DispatchQueue: Dispatcher {
    func async(execute work: @escaping () -> Void) {
        self.async(group: nil, qos: .unspecified, flags: [], execute: work)
    }
}
