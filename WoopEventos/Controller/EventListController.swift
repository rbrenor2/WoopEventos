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
    let disposeBag = DisposeBag()
    let eventListViewModel: EventListViewModel = EventListViewModel()
    
    let loadingView: AnimationView = Utilities().loadingAnimationView()
    
    let tableView: UITableView = UITableView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
        handleCellTapped()

        eventListViewModel.getEvents()
    }
    
    // MARK: - Bind to ViewModel
    
    func bindViewModel() {
        eventListViewModel.eventLoading
            .map ({ [unowned self] loading in
                Utilities().showLoadingIndicator(inView: self.view, loadingView: loadingView, isLoading: loading)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        eventListViewModel.eventCells.bind(to: tableView.rx.items, curriedArgument: {
            tableView, index, element in
            
            let indexPath = IndexPath(item: index, section: 0)
            
            switch element {
            case .normal(let event):
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? EventCell else {
                    return UITableViewCell()
                }
                cell.event = event
                
                return cell

            case .error(let message):
                let cell = UITableViewCell()
                cell.isUserInteractionEnabled = false
                cell.textLabel?.text = message
                
                return cell
                
            case .empty:
                let cell = UITableViewCell()
                cell.isUserInteractionEnabled = false
                cell.textLabel?.text = "Sem dados"
                
                return cell
            }
        }).disposed(by: disposeBag)
        
    }
    
    func handleCellTapped() {
        tableView
        .rx
        .modelSelected(EventCellViewModelType.self)
        .subscribe(
            onNext: { [unowned self] eventCellType in
                if case let .normal(event) = eventCellType {
                    let detailVC = EventDetailController(id: event.id)
                    self.present(detailVC, animated: true, completion: nil)
                }
            }
        )
        .disposed(by: disposeBag)
    }
    
    // MARK: - Helpers
    func configureUI() {
        configureNavBarUI()
        configureEventListUI()
    }
    
    func configureEventListUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        let safeMargins = view.safeAreaLayoutGuide
        tableView.anchor(top: view.topAnchor, left: safeMargins.leftAnchor, bottom: view.bottomAnchor, right: safeMargins.rightAnchor)
        
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.register(EventCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configureNavBarUI() {
        let logoImageView = UIImageView(image: UIImage(named: K.General.woopLogoImage))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.setDimensions(width: 34, height: 34)
        logoImageView.layer.cornerRadius = 34/2

        navigationController?.navigationBar.isHidden = false
        navigationItem.titleView = logoImageView
        
        logoImageView.anchor(left: navigationItem.titleView?.leftAnchor, right: navigationItem.titleView?.rightAnchor, paddingTop: 10, paddingBottom: 10)
    }
}

extension EventListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
