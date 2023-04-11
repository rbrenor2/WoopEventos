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
import RxCocoa
import Lottie
import KeychainAccess

class EventDetailController: UIViewController {
    // MARK: - Properties
    var id: String?
    
    var event: Event?
    
    private var isCheckedin: Bool = false
    
    private let disposeBag = DisposeBag()
        
    private let eventDetailViewModel: EventDetailViewModel
        
    private let loadingView: AnimationView = Utilities().loadingAnimationView()
    
    private lazy var detailView: EventDetailView = {
        let view = EventDetailView(frame: view.frame, handleCheckin: #selector(handleCheckinTapped), handleShare: #selector(handleShareTapped), handleClose: #selector(handleCloseTapped))
        return view
    }()
    
    // MARK: - Lifecycle
    
    init(id: String) {
        self.id = id
        self.eventDetailViewModel = EventDetailViewModel(eventService: EventService().shared, eventId: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        binding()
        eventDetailViewModel.input.load.accept(())
    }
    
    // MARK: - Bindings
    
    func binding() {
        eventDetailViewModel
            .output
            .loading
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else {return}
                Utilities().showLoadingIndicator(inView: self.view, loadingView: self.loadingView, isLoading: isLoading)
            }).disposed(by: disposeBag)

        eventDetailViewModel
            .output
            .event
            .asDriver(onErrorJustReturn: Event())
            .drive(onNext: { [weak self] event in
                guard let self = self else {return}
                self.configureUI(event: event)
                self.event = event
            }).disposed(by: disposeBag)
        
        eventDetailViewModel
            .output
            .checkin
            .asDriver(onErrorJustReturn: EventDetailResponse(status: 500, title: K.EventDetail.checkinErrorTitle, message: K.General.checkinErrorDefaultMessage))
            .drive(onNext: { [weak self] response in
                guard let self = self else {return}
                guard let message = response.message else {return}
                guard let title = response.title else {return}
                
                Utilities().showAlertView(withTarget: self, title: title, message: message, action: K.General.confirmAlertButtonTitle)
                
                // Only changes button if the request was successful
                if (response.status == StatusCodeType.success.rawValue) {
                    self.isCheckedin = true
                    self.configureCheckinButtonStateUI()
                }
            }).disposed(by: disposeBag)
        
    }
    
    private func errorBinding() {
        eventDetailViewModel
            .output
            .error
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] error in
                guard let self = self else {
                    return
                }
                let title = K.EventDetail.checkinErrorTitle
                let message = Utilities().getErrorMessage(withError: error)
                Utilities().showErrorView(forTarget: self, withTitle: title, withMessage: message)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    
    func showCheckinConfirmationAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: K.EventDetail.checkinAlertActionButtonTitle, style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
        
    func configureUI(event: Event) {
        view.addSubview(detailView)
        detailView.event = event
        
        let safeMargins = view.safeAreaLayoutGuide
        detailView.anchor(top: view.topAnchor, left: safeMargins.leftAnchor, bottom: view.bottomAnchor, right: safeMargins.rightAnchor)
    }
    
    func configureCheckinButtonStateUI() {
        if isCheckedin {
            detailView.checkinButton.setTitle(K.EventDetail.checkinConfirmedButtonTitle, for: .normal)
            detailView.checkinButton.backgroundColor = .lightGreen
        } else {
            detailView.checkinButton.setTitle(K.EventDetail.checkinButtonTitle, for: .normal)
            detailView.checkinButton.backgroundColor = .mainPurple
        }
        
    }
    
    // MARK: - Selectors
    
    @objc func handleCloseTapped() {
        dismiss(animated: true)
    }
    
    @objc func handleCheckinTapped() {
        if isCheckedin {
            isCheckedin = false
            configureCheckinButtonStateUI()
            
            let message = K.EventDetail.uncheckMessage
            let title = K.EventDetail.uncheckTitle
            
            Utilities().showAlertView(withTarget: self, title: title, message: message, action: K.General.confirmAlertButtonTitle)
        } else {
            eventDetailViewModel.input.checkin.accept(())
        }
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
