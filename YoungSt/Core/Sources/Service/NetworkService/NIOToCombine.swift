//
//  File.swift
//  
//
//  Created by Роман Тищенко on 14.03.2021.
//

import Combine
import NIO

public extension NIO.EventLoopFuture {
    var publisher: Future<Value, Error> {
        Future { promise in
            self.whenComplete { result in
                promise(result.mapError(BLError.init))
            }
        }
    }
}
