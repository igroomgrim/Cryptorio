//
//  FPDashboardViewController.swift
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

protocol FPDashboardDisplayLogic: class {
  func displayDashboardData(viewModel: FPDashboard.RequestData.ViewModel)
  func displayDashboardError(viewModel: FPDashboard.ErrorData.ViewModel)
  func displayDashboardAddWalletNotification()
}

class FPDashboardViewController: UITableViewController, FPDashboardDisplayLogic {
  var interactor: FPDashboardBusinessLogic?
  var router: (NSObjectProtocol & FPDashboardRoutingLogic & FPDashboardDataPassing)?
  
  
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var hashRateLabel: UILabel!
  @IBOutlet weak var avgHashRateLabel: UILabel!
  @IBOutlet weak var unpaidBalanceLabel: UILabel!
  
  @IBOutlet weak var addAddressBarButton: UIBarButtonItem!
  
  @IBOutlet weak var fpRefreshControl: UIRefreshControl!
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup() {
    let viewController = self
    let interactor = FPDashboardInteractor()
    let presenter = FPDashboardPresenter()
    let router = FPDashboardRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    fetchDashboardDataOnDidAppear()
  }
  
  // MARK: Do something
  func fetchDashboardDataOnDidAppear() {
    let request = FPDashboard.RequestData.Request()
    interactor?.fetchData(request: request)
  }
  
  func displayDashboardData(viewModel: FPDashboard.RequestData.ViewModel) {
    let displayedDashboardData = viewModel.displayedDashboardData
    addressLabel.text = displayedDashboardData.address
    hashRateLabel.text = "\(displayedDashboardData.hashRate)"
    avgHashRateLabel.text = "\(displayedDashboardData.avgHashRate) kH/s"
    unpaidBalanceLabel.text = String(format: "%.5f ZEC", displayedDashboardData.unpaidBalance)
    fpRefreshControl.endRefreshing()
  }
  
  func displayDashboardError(viewModel: FPDashboard.ErrorData.ViewModel) {
    fpRefreshControl.endRefreshing()
    let error = viewModel.displayedDashboardError.error
    var errorMessageOnDisplay = ""
    switch error {
    case .CannotFetch(let errorMessage):
      errorMessageOnDisplay = errorMessage
    }
    
    let alert = UIAlertController(title: "System error", message: errorMessageOnDisplay, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  func displayDashboardAddWalletNotification() {
    let walletIDStore = WalletIDStore()
    
    let alert = UIAlertController(title: "Add Flypool(Zec) WalletID", message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    alert.addTextField(configurationHandler: nil)
    
    alert.addAction(UIAlertAction(title: "Save", style: .default, handler:{ [weak self] UIAlertAction in
      guard let textField = alert.textFields?.first, let walletID = textField.text else {
        return
      }
      
      walletIDStore.saveWalletID(walletID: walletID, pool: .flypool)
      
      self?.fetchDashboardDataOnDidAppear()
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func addAddressBarButtonTapped(_ sender: Any) {
    let walletIDStore = WalletIDStore()
    
    let alert = UIAlertController(title: "Add Flypool(Zec) WalletID", message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    alert.addTextField { walletIDTextField in
      guard let oldWalletID = walletIDStore.getWalletID(from: .flypool) else {
        return
      }
      
      walletIDTextField.text = oldWalletID
    }
    
    alert.addAction(UIAlertAction(title: "Save", style: .default, handler:{ [weak self] UIAlertAction in
      guard let textField = alert.textFields?.first, let walletID = textField.text else {
        return
      }
      
      walletIDStore.saveWalletID(walletID: walletID, pool: .flypool)
      
      self?.fetchDashboardDataOnDidAppear()
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func refreshControlChanged(_ sender: Any) {
    let request = FPDashboard.RequestData.Request()
    interactor?.fetchData(request: request)
  }
}
