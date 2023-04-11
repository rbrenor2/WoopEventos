//
//  EventsListController.swift
//  WoopEventos
//
//  Created by Breno Ramos on 21/12/21.
//

import UIKit
import RxSwift
import Lottie

private let reuseIdentifier = "eventCell"

class EventListController: UIViewController {
    
    // MARK: - Properties
    
    let disposeBag: DisposeBag
    
    let viewModel: EventListViewModel
    
    let loadingView: AnimationView
    
    let tableView: UITableView
    
    let refreshControl: UIRefreshControl
    
    // MARK: - Lifecycle
    
    init() {
        disposeBag = DisposeBag()
        refreshControl = UIRefreshControl()
        tableView = UITableView()
        loadingView = Utilities().loadingAnimationView()
        viewModel = EventListViewModel(eventService: EventService().shared)
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        binding()
        errorBinding()
        refreshControl.beginRefreshing()
        viewModel.input.reload.accept(())
    }
    
    // MARK: - Bindings
    
    func binding() {
        viewModel
            .output
            .loading
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else {return}
                if (isLoading == false) {self.refreshControl.endRefreshing()}
            }).disposed(by: disposeBag)

        viewModel.output
            .events
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: EventCell.self)) {  (row,event,cell) in
                cell.event = event
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else {
                return
            }
            self.tableView.deselectRow(at: indexPath, animated: true)
            let event: Event = try! self.tableView.rx.model(at: indexPath)
            let detailVC = EventDetailController(id: event.id)
            self.present(detailVC, animated: true, completion: nil)
        }).disposed(by: disposeBag)        
    }
    
    private func errorBinding() {
        viewModel
            .output
            .error
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] error in
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
                
                let title = K.EventDetail.checkinErrorTitle
                let message = Utilities().getErrorMessage(withError: error)
                Utilities().showErrorView(forTarget: self, withTitle: title, withMessage: message)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        configureNavBar()
        configureTableView()
    }
    
    func configureTableView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        refreshControl.attributedTitle = NSAttributedString(string: K.EventList.refreshTitle)
        refreshControl.addTarget(self, action: #selector(loadNewEvents), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.rowHeight = 130
        
        let safeMargins = view.safeAreaLayoutGuide
        tableView.anchor(top: view.topAnchor, left: safeMargins.leftAnchor, bottom: view.bottomAnchor, right: safeMargins.rightAnchor)
        
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.register(EventCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configureNavBar() {
        let logoImageView = UIImageView(image: UIImage(named: K.General.woopLogoImage))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.setDimensions(width: 34, height: 34)
        logoImageView.layer.cornerRadius = 34/2

        navigationController?.navigationBar.isHidden = false
        navigationItem.titleView = logoImageView
        
        logoImageView.anchor(left: navigationItem.titleView?.leftAnchor, right: navigationItem.titleView?.rightAnchor, paddingTop: 10, paddingBottom: 10)
    }
    
    // MARK: - Selectors

    @objc func loadNewEvents() {
        viewModel.input.reload.accept(())
    }
}
