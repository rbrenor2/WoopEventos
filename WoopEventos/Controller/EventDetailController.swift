//
//  EventDetailController.swift
//  WoopEventos
//
//  Created by Breno Ramos on 21/12/21.
//

import UIKit
import SDWebImage
import MapKit
import RxSwift
import Lottie

class EventDetailController: UIViewController {
    // MARK: - Properties
    var id: String?
    
    var event: Event?
    
    private let disposeBag = DisposeBag()
        
    private let eventDetailViewModel: EventDetailViewModel = EventDetailViewModel()
        
    private let loadingView: AnimationView = Utilities().loadingAnimationView()
    
    private lazy var detailView: EventDetailView = {
        let view = EventDetailView(frame: view.frame, handleCheckin: #selector(handleCheckinTapped), handleShare: #selector(handleShareTapped), handleClose: #selector(handleCloseTapped))
        return view
    }()
        
    // MARK: - Bind ViewModel
    
    func bindLoading() {
        eventDetailViewModel.eventLoading
            .map ({ [unowned self] loading in
                Utilities().showLoadingIndicator(inView: self.view, loadingView: loadingView, isLoading: loading)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func bindCheckin() {
        eventDetailViewModel.eventCheckin.subscribe (onNext:{ [unowned self] eventCheckinType in
            switch eventCheckinType {
            case .normal(let code):
                self.showCheckinConfirmationAlert(message: code)
                break
            case .error(let error):
                self.showCheckinConfirmationAlert(message: error)
                break
            case .empty:
                self.showCheckinConfirmationAlert(message: "")
                break
            }
        }, onError: { [unowned self] error in
            self.configureErrorUI(message: error.localizedDescription)
        } ).disposed(by: disposeBag)
    }
    
    func bindDetailInfo() {
        eventDetailViewModel.eventDetail.subscribe (onNext:{ [unowned self] eventDetailType in
            switch eventDetailType {
            case .normal(let event):
                self.configureUI(event: event)
                self.event = event
                break
            case .error(let error):
                self.configureErrorUI(message: error)
                break
            case .empty:
                break
            }
        }, onError: { [unowned self] error in
            self.configureErrorUI(message: error.localizedDescription)
        } ).disposed(by: disposeBag)
    }
    
    // MARK: - Lifecycle
    
    init(id: String) {
        super.init(nibName: nil, bundle: nil)
        self.id = id
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        bindLoading()
        bindDetailInfo()
        bindCheckin()
        eventDetailViewModel.getEvent(id: self.id!)
    }
    
    // MARK: - UI Setup
    
    func showCheckinConfirmationAlert(message: String) {
        let alert = UIAlertController(title: "\(message)", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: K.EventDetail.checkinAlertActionButtonTitle, style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func configureErrorUI(message: String) {
        let detailErrorView = EventDetailErrorView(frame: view.bounds, title: message)
        view.addSubview(detailErrorView)
        detailErrorView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, width: view.bounds.width, height: view.bounds.height)
    }
        
    func configureUI(event: Event) {
        view.addSubview(detailView)
        detailView.event = event
        
        let safeMargins = view.safeAreaLayoutGuide
        detailView.anchor(top: view.topAnchor, left: safeMargins.leftAnchor, bottom: view.bottomAnchor, right: safeMargins.rightAnchor)
    }
    
    // MARK: - Selectors
    
    @objc func handleCloseTapped() {
        dismiss(animated: true)
    }
    
    @objc func handleCheckinTapped() {
        guard let id = self.id else {return}
        let eventCheckin = EventCheckin(eventId: id, name: "Breno Rios", email: "rbrenorios@gmail.com")
        eventDetailViewModel.checkinEvent(eventCheckin: eventCheckin)
    }
    
    @objc func handleShareTapped() {
        guard let event = event else { return }
        let text = Utilities().getTextToShare(title: event.title, date: event.date, description: event.description, price: event.price, latitutde: event.latitude, longitude: event.longitude)
        let itemToShare = [ text ]
        let shareVC = UIActivityViewController(activityItems: itemToShare, applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = self.view
                
        present(shareVC, animated: true, completion: nil)
    }
}
