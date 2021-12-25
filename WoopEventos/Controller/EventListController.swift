//
//  EventsListController.swift
//  WoopEventos
//
//  Created by Breno Ramos on 21/12/21.
//

import UIKit
import RxSwift

private let reuseIdentifier = "eventCell"

class EventListController: UITableViewController {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let eventListViewModel: EventListViewModel = EventListViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
        handleCellTapped()

        eventListViewModel.getEvents()
    }
    
    // MARK: - Reactiveness
    func bindViewModel() {
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        eventListViewModel.eventCells.bind(to: tableView.rx.items, curriedArgument: {
            tableView, index, element in
            
            let indexPath = IndexPath(item: index, section: 0)
            
            switch element {
            case .normal(let viewModel):
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? EventCell else {
                    return UITableViewCell()
                }
                cell.viewModel = viewModel
                
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
                if case let .normal(viewModel) = eventCellType {
                    let detailVC = EventDetailController(id: viewModel.event.id)
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
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.register(EventCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configureNavBarUI() {
        let logoImageView = UIImageView(image: UIImage(named: K.General.woopLogoImage))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.setDimensions(width: 44, height: 44)
        navigationController?.navigationBar.isHidden = false
        navigationItem.titleView = logoImageView
    }
}

extension EventListController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
