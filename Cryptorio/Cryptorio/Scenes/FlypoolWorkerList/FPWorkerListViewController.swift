//
//  FPWorkerListViewController.swift
//  Cryptorio
//
//  Created by Anak Mirasing on 7/14/17.
//  Copyright (c) 2017 iGROOMGRiM. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FPWorkerListDisplayLogic: class {
  func displayWokerList(viewModel: FPWorkerList.GetWorkers.ViewModel)
}

class FPWorkerListViewController: UITableViewController, FPWorkerListDisplayLogic {
  var interactor: FPWorkerListBusinessLogic?
  var router: (NSObjectProtocol & FPWorkerListRoutingLogic & FPWorkerListDataPassing)?
  var displayedFPWorkers: [FPHTMLWorker] = []
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
    let interactor = FPWorkerListInteractor()
    let presenter = FPWorkerListPresenter()
    let router = FPWorkerListRouter()
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
    tableView.tableFooterView = UIView()
    
    getWorkers()
  }
  
  // MARK: Get Workers
  
  func getWorkers() {
    let request = FPWorkerList.GetWorkers.Request()
    interactor?.getWorkers(request: request)
  }
  
  func fetchWorkers() {
    let request = FPWorkerList.FetchWorkers.Request()
    interactor?.fetchWorkers(request: request)

  }
  
  func displayWokerList(viewModel: FPWorkerList.GetWorkers.ViewModel) {
    if let workers = viewModel.displayedFPWorkers {
      displayedFPWorkers = workers
    
      tableView.reloadData()
      refreshControl?.endRefreshing()
    }
  }
  
  @IBAction func refreshControlChanged(_ sender: Any) {
    fetchWorkers()
  }
}

extension FPWorkerListViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return displayedFPWorkers.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FPWorkerTableViewCell.self), for: indexPath) as! FPWorkerTableViewCell
    let worker = displayedFPWorkers[indexPath.row]
    cell.bind(to: worker)
    
    return cell
  }
}
