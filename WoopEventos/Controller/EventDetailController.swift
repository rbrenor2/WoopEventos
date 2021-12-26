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
    private let disposeBag = DisposeBag()
    
    var id: String?
    
    private let eventDetailViewModel: EventDetailViewModel = EventDetailViewModel()
        
    private let loadingView: AnimationView = Utilities().loadingAnimationView()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGreen
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var shareButton: UIButton = Utilities().actionIconButton(withIconNamed: K.EventDetail.shareButtonIconName, handleTap: #selector(handleShareTapped))

    private lazy var checkinButton: UIButton = Utilities().actionButton(withTitle: K.EventDetail.checkinButtonTitle, handleTap: #selector(handleCheckinTapped))
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var detailInfoView: EventDetailInfoView = {
        let frame = CGRect(origin: view.center, size: CGSize(width: view.frame.width, height: 300))
        let detailView = EventDetailInfoView(frame: frame)
        return detailView
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
            case .error(let error):
                self.configureErrorUI(message: error)
            case .empty:
                self.configureEmptyUI()
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
        let alert = UIAlertController(title: "\(K.EventDetail.checkinAlertTitle) \(message)", message: K.EventDetail.checkinButtonTitle, preferredStyle: .alert)
        let action = UIAlertAction(title: K.EventDetail.checkinAlertActionButtonTitle, style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func configureEmptyUI() {
        
    }
    
    func configureErrorUI(message: String) {
        
    }
        
    func configureUI(event: Event) {
        view.backgroundColor = .white
        
        let imageUrl = event.image == nil ? URL(string: "") : event.image
        setupImageView(withURL: imageUrl!)
        setupActionButtons()
        
        let price = event.price == nil ? 0.00 : event.price!
        setupPriceLabel(withPrice: price)
                
        view.addSubview(detailInfoView)
        detailInfoView.event = event
        detailInfoView.anchor(top: checkinButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 30, paddingRight: 20)
    }
    
    func setupImageView(withURL url: URL) {
        view.addSubview(imageView)
        imageView.sd_setImage(with: url)
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, width: view.frame.width, height: 200)
    }
    
    func setupActionButtons() {
        view.addSubview(checkinButton)
        checkinButton.anchor(top: imageView.bottomAnchor, right: view.rightAnchor, paddingTop: 12, paddingRight: 12)
        
        view.addSubview(shareButton)
        shareButton.anchor(top: imageView.bottomAnchor, right: checkinButton.leftAnchor, paddingTop: 18, paddingRight: 24)
    }
    
    func setupPriceLabel(withPrice price: Double) {
        view.addSubview(priceLabel)
        priceLabel.text = Utilities().formatPrice(withPrice: price)
        priceLabel.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12)
    }
    
    // MARK: - Selectors
    
    @objc func handleCheckinTapped() {
        guard let id = self.id else {return}
        let eventCheckin = EventCheckin(eventId: id, name: "Breno Rios", email: "rbrenorios@gmail.com")
        eventDetailViewModel.checkinEvent(eventCheckin: eventCheckin)
    }
    
    @objc func handleShareTapped() {
        let text = Utilities().textToShare(withTexts: [detailInfoView.getTextToShare(), "Preço: \(priceLabel.text!)" ])
        let itemToShare = [ text ]
        let shareVC = UIActivityViewController(activityItems: itemToShare, applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = self.view
                
        present(shareVC, animated: true, completion: nil)
    }
}
