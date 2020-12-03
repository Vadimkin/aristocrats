//
//  Publisher.swift
//  aristocratsfm
//
//  Created by Maksym Ambroskin on 14.10.2020.
//

import Foundation
import Combine

extension Publisher {
    func replaceErrorWithNil<ReplaceFilure: Error>(
        _ failureType: ReplaceFilure.Type
    ) -> AnyPublisher<Output?, ReplaceFilure> {
        map { (output: Output) -> Output? in
            output
        }
        .replaceError(with: nil)
        .setFailureType(to: failureType)
        .eraseToAnyPublisher()
    }

    func wrapInResult<WrappedOutput>(
        _ replacement: @escaping (Output) -> WrappedOutput
    ) -> AnyPublisher<Result<WrappedOutput, Failure>, Never> {
        map {
            Result<WrappedOutput, Failure>.success(replacement($0))
        }.eraseToAnyPublisher()
        .catch { error -> AnyPublisher<Result<WrappedOutput, Failure>, Never> in
            Just(Result<WrappedOutput, Failure>.failure(error))
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }

    func wrapInResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        wrapInResult { $0 }
    }

    func genericError() -> AnyPublisher<Self.Output, Error> {
      return self
        .mapError({ (error: Self.Failure) -> Error in
          return error
        }).eraseToAnyPublisher()
    }
}
