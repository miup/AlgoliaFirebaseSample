//
//  Result+Ex.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/12.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import Foundation
import Result

public enum ResultError<T>: Error {
    case illegalCombination(T?, Error?)
}

public func makeResult<T>(_ value: T?, _ error: Error?) -> Result<T, AnyError> {
    switch (value, error) {
    case (let value?, nil):
        return .success(value)
    case (nil, let error?):
        return .failure(AnyError(error))
    default:
        return .failure(AnyError(ResultError.illegalCombination(value, error)))
    }

}
