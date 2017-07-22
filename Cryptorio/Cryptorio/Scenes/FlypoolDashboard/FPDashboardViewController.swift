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
import NVActivityIndicatorView
import RxSwift

protocol FPDashboardDisplayLogic: class {
  func displayDashboardData(viewModel: FPDashboard.RequestData.ViewModel)
  func displayDashboardWorkers(viewModel: FPDashboard.RequestWorkers.ViewModel)
  func displayDashboardError(viewModel: FPDashboard.ErrorData.ViewModel)
  func displayDashboardAddWalletNotification()
}

class FPDashboardViewController: UITableViewController, FPDashboardDisplayLogic, NVActivityIndicatorViewable {
  var interactor: FPDashboardBusinessLogic?
  var router: (NSObjectProtocol & FPDashboardRoutingLogic & FPDashboardDataPassing)?
  
  var loadedAllDataChecker: Int = 0 {
    didSet {
      if loadedAllDataChecker == 2 {
        stopIndicatorAnimating()
      }
    }
  }
  
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var hashRateLabel: UILabel!
  @IBOutlet weak var avgHashRateLabel: UILabel!
  @IBOutlet weak var unpaidBalanceLabel: UILabel!
  @IBOutlet weak var immatureBalanceLabel: UILabel!
  @IBOutlet weak var activeWorkersLabel: UILabel!
  @IBOutlet weak var inactiveWorkersLabel: UILabel!
  
  @IBOutlet weak var addAddressBarButton: UIBarButtonItem!
  
  let dashboardData: Variable<Data?> = Variable(nil)
  let disposeBag = DisposeBag()
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
    registerDidBecomeActiveNotification()
    clearFooterCell()
    
    fetchDashboardData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    
    print("viewDidLoad")
    
    let client = APIClient()
    let endpoint = APIEndpoint<FPData>(endpoint: FPEndpoint.dashboard, walletID: "t1cD6UjyHpdpkJ1qUMkLTwCLAheCnHYd3rB")
    let xxx = ServiceCall.init(endpoint: endpoint, client: client)
    
    let x = Failable<FPError>.fail(FPError.other("f"))
    
    
//      .subscribe(onNext: { (result) in
//        print(result)
//        print(result.map({ (data) -> Int? in
//          let xx = endpoint.deserialize(data)
//          print(xx)
//          return 1
//        }))
//        
//        
//      }, onError: { (error) in
//        if let err = error as? FPError {
//          print(err)
//        }
//      }, onCompleted: { 
//        print("complete")
//      }, onDisposed: nil)
//    .addDisposableTo(disposeBag)
 
    
    
    /*
    let client = APIClient()
    let endpoint = APIEndpoint<FPHTMLWorker>(endpoint: FPEndpoint.worker, walletID: "t1cD6UjyHpdpkJ1qUMkLTwCLAheCnHYd3rB")
    let service = ServiceCall(endpoint: endpoint, client: client)
    service.subscribe(onNext: { (result) in
      print(result.map({ (data) -> Int? in
        let xx = endpoint.deserialize(data)
        print(xx)
        return 1
      }))
      
    }, onError: { (error) in
      if let err = error as? FPError {
        print(err)
      }
    }, onCompleted: {
      print("complete")
    }, onDisposed: nil)
      .addDisposableTo(disposeBag)
    */
  }
  
  // MARK: Do something
  func registerDidBecomeActiveNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(fetchDashboardData), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
  }
  
  func clearFooterCell() {
    tableView.tableFooterView = UIView()
  }
  
  private func loadDashboardData() {
    loadedAllDataChecker = 0
    
    let request = FPDashboard.RequestData.Request()
    interactor?.fetchData(request: request)
    
    let requestWorkers = FPDashboard.RequestWorkers.Request()
    interactor?.fetchFPWorkers(request: requestWorkers)
  }
  
  private func stopIndicatorAnimating() {
    refreshControl?.endRefreshing()
    stopAnimating()
  }
  
  func fetchDashboardData() {
    // Display loading indicator
    startAnimating()
    
    loadDashboardData()
  }
  
  func reloadDashboardData() {
    loadDashboardData()
  }
  
  func displayDashboardData(viewModel: FPDashboard.RequestData.ViewModel) {
    let displayedDashboardData = viewModel.displayedDashboardData
    addressLabel.text = displayedDashboardData.address
    hashRateLabel.text = "\(displayedDashboardData.hashRate)"
    avgHashRateLabel.text = "\(displayedDashboardData.avgHashRate) kH/s"
    unpaidBalanceLabel.text = displayedDashboardData.unpaidBalance
    immatureBalanceLabel.text = displayedDashboardData.immatureBalance
    
    loadedAllDataChecker += 1
  }
  
  func displayDashboardWorkers(viewModel: FPDashboard.RequestWorkers.ViewModel) {
    let data = viewModel.displayedDashboardWorkers
    activeWorkersLabel.text = "\(data.activeWorker)"
    inactiveWorkersLabel.text = "\(data.inactiveWorker)"
    
    loadedAllDataChecker += 1
  }
  
  func displayDashboardError(viewModel: FPDashboard.ErrorData.ViewModel) {
    let error = viewModel.displayedDashboardError.error
    var errorMessageOnDisplay = ""
    
    switch error {
      case .api(let errorMessage):
        errorMessageOnDisplay = errorMessage
      case .other(let errorMessage):
        errorMessageOnDisplay = errorMessage
    }
    
    let alert = UIAlertController(title: "Cryptorio Error", message: errorMessageOnDisplay, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    self.present(alert, animated: true) { [weak self] in
      self?.stopIndicatorAnimating()
    }
  }
  
  func displayDashboardAddWalletNotification() {
    let alert = UIAlertController(title: "Add Flypool(Zec) WalletID", message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    alert.addTextField(configurationHandler: nil)
    
    alert.addAction(UIAlertAction(title: "Save", style: .default, handler:{ [weak self] UIAlertAction in
      guard let textField = alert.textFields?.first, let walletID = textField.text else {
        return
      }
      
      WalletIDStore.saveWalletID(walletID: walletID, pool: .flypool)
      
      self?.fetchDashboardData()
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func addAddressBarButtonTapped(_ sender: Any) {
    let alert = UIAlertController(title: "Add Flypool(Zec) WalletID", message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    alert.addTextField { walletIDTextField in
      guard let oldWalletID = WalletIDStore.getWalletID(from: .flypool) else {
        return
      }
      
      walletIDTextField.text = oldWalletID
    }
    
    alert.addAction(UIAlertAction(title: "Save", style: .default, handler:{ [weak self] UIAlertAction in
      guard let textField = alert.textFields?.first, let walletID = textField.text else {
        return
      }
      
      WalletIDStore.saveWalletID(walletID: walletID, pool: .flypool)
      
      self?.fetchDashboardData()
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func refreshControlChanged(_ sender: Any) {
    reloadDashboardData()
  }
}
