//
//  FPDashboardPresenter.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/11/2560 BE.
//  Copyright (c) 2560 iGROOMGRiM. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FPDashboardPresentationLogic {
  func presentDashboardData(response: FPDashboard.RequestData.Response)
  func presentDashboardAddWalletNotification()
}

class FPDashboardPresenter: FPDashboardPresentationLogic {
  weak var viewController: FPDashboardDisplayLogic?
  
  // MARK: Do something
  
  func presentDashboardData(response: FPDashboard.RequestData.Response) {
    let dashboardData = FPDashboard.RequestData.ViewModel.DashboardData(address: response.flypoolData.address, hashRate: response.flypoolData.hashRate)
    
    let viewModel = FPDashboard.RequestData.ViewModel(displayedDashboardData: dashboardData)
    
    viewController?.displayDashboardData(viewModel: viewModel)
  }
  
  func presentDashboardAddWalletNotification() {
    viewController?.displayDashboardAddWalletNotification()
  }
}
