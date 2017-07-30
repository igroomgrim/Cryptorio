//
//  APIClient.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/22/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import Foundation

class APIClient {
  var session: URLSession!
  let operationQueue: OperationQueue
  
  init() {
    operationQueue = OperationQueue()
    self.session = URLSession(
      configuration: URLSessionConfiguration.ephemeral,
      delegate: nil,
      delegateQueue: operationQueue
    )
  }
  
  public func requestToEndpoint<TResult: FPObject>(_ endpoint: APIEndpoint<TResult>, callback: APIRequest<TResult>.Callback?) -> APIRequest<TResult>? {
    do {
      let req: APIRequest<TResult> = APIRequest(client: self, endPoint: endpoint, callback: callback)
      return try req.start()
    } catch let err as FPError {
      performCallback() {
        callback?(.fail(err))
      }
    } catch let err {
      performCallback() {
        guard let fperror = err as? FPError else {
          let error = FPError.other(err.localizedDescription)
          callback?(.fail(error))
          return
        }
        
        callback?(.fail(fperror))
      }
    }
    
    return nil
  }
  
  
  func performCallback(_ callback: @escaping () -> ()) {
    operationQueue.addOperation(callback)
  }
  
  public func cancelAllOperations() {
    session.invalidateAndCancel()
    operationQueue.cancelAllOperations()
  }
}
