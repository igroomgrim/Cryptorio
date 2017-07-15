//
//  FPPayoutListInteractor.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/15/2560 BE.
//  Copyright (c) 2560 iGROOMGRiM. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FPPayoutListBusinessLogic {
  func doSomething(request: FPPayoutList.Something.Request)
}

protocol FPPayoutListDataStore {
  //var name: String { get set }
}

class FPPayoutListInteractor: FPPayoutListBusinessLogic, FPPayoutListDataStore {
  var presenter: FPPayoutListPresentationLogic?
  var worker: FPPayoutListWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: FPPayoutList.Something.Request) {
    worker = FPPayoutListWorker()
    worker?.doSomeWork()
    
    let response = FPPayoutList.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
