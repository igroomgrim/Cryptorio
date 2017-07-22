//
//  ServiceCall.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/22/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import Foundation
import RxSwift

class ServiceCall<Result: FPObject>: ObservableType {
  typealias E = Failable<Data>
  
  typealias Endpoint = APIEndpoint<Result>
  
  let endpoint: Endpoint
  let client: APIClient
  
  init(endpoint: Endpoint, client: APIClient) {
    self.endpoint = endpoint
    self.client = client
  }
  
  func subscribe<O>(_ observer: O) -> Disposable where O : ObserverType, O.E == Failable<Data> {
    let request = client.requestToEndpoint(endpoint) { (result) in
      observer.onNext(result)
      observer.onCompleted()
    }
    
    return Disposables.create(with: { _ in request?.cancel() })
  }
}
