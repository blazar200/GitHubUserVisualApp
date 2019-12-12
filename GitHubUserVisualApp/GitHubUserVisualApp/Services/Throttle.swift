//
//  Throttle.swift
//  GitHubUserVisualApp
//
//  Created by Baron Lazar on 12/12/19.
//  Copyright © 2019 Baron Lazar. All rights reserved.
//

import Foundation

struct Throttle {
    let item: DispatchWorkItem
    
    init(_ delay: TimeInterval, _ queue: DispatchQueue, _ work: @escaping ()->Void) {
        item = DispatchWorkItem(block: work)
        queue.asyncAfter(deadline: .now() + delay, execute: item)
    }
    
    init(_ work: @escaping ()->Void) {
        self.init(0.5, .global(), work)
    }
    
    func cancel() {
        item.cancel()
    }
}
