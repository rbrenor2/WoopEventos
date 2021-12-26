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
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = K.EventDetail.descriptionTitle
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let titleLocationLabel: UILabel = {
        let label = UILabel()
        label.text = K.EventDetail.locationTile
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        
        return mapView
    }()
    
    private let shareButton: UIButton = {
        let favoriteButtonConfiguration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20))
        
        let button = UIButton()
        button.tintColor = .mainPurple
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        
        let image = UIImage.init(systemName: K.EventDetail.shareButtonIconName, withConfiguration: favoriteButtonConfiguration)
          button.setImage(image, for: .normal)
        
        return button
    }()

    private let checkinButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightPurple
        button.setTitle(K.EventDetail.checkinButtonTitle, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32/2
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(handleCheckinTapped), for: .touchUpInside)

        return button
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    
    // MARK: - Reactiveness
    func bindViewModel() {
        eventDetailViewModel.eventLoading
            .map ({ [unowned self] loading in
                Utilities().showLoadingIndicator(inView: self.view, loadingView: loadingView, isLoading: loading)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
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
        
        eventDetailViewModel.eventDetail.subscribe (onNext:{ [unowned self] eventDetailType in
            switch eventDetailType {
            case .normal(let viewModel):
                self.configureUI(eventViewModel: viewModel)
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
        self.bindViewModel()
        eventDetailViewModel.getEvent(id: self.id!)
    }
    
    // MARK: - Helpers
    
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
        
    func configureUI(eventViewModel: EventViewModel) {
        view.backgroundColor = .white
        
        let event = eventViewModel.event
        
        setupImageView(withURL: event.image!)
        setupActionButtons()
        setupPriceLabel(withPrice: event.price)
        
        let location = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
        
        let annotation = Utilities().setupMapAnnotation(withTitle: eventViewModel.event.title, location: location)
        
        let mapView = Utilities().setupMapView(location: CLLocationCoordinate2D(latitude: eventViewModel.event.latitude, longitude: eventViewModel.event.longitude), annotation: annotation, mapWidth: view.frame.width, mapHeight: 300)
        
        setupInfoScrollView(title: event.title, description: event.description, titleLocation: K.EventDetail.locationTile, date: event.date, mapView: mapView)
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
    
    func setupInfoScrollView(title: String, description: String, titleLocation: String, date: Date, mapView: MKMapView) {
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = true
        view.addSubview(scrollView)
        
        let infoStack = UIStackView()
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(infoStack)
        scrollView.anchor(top: checkinButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 30, paddingRight: 20)
        
        infoStack.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor)
        infoStack.centerX(inView: view)
        infoStack.backgroundColor = .yellow
        
        titleLabel.text = title
        descriptionLabel.text = description
        dateLabel.text = Utilities().formatDate(withDate: date)
        let descriptionStack = Utilities().infoStack(withViews: [dateLabel, titleLabel, descriptionLabel], direction: .vertical)

        titleLocationLabel.text = titleLocation
        let locationStack = Utilities().infoStack(withViews: [titleLocationLabel, mapView], direction: .vertical)
        mapView.setDimensions(width: infoStack.frame.width, height: 200)

        infoStack.addSubview(descriptionStack)
        descriptionStack.anchor(top: infoStack.topAnchor, left: infoStack.leftAnchor, right: infoStack.rightAnchor, paddingTop: 18, width: infoStack.frame.width)

        infoStack.addSubview(locationStack)
        locationStack.anchor(top: descriptionStack.bottomAnchor, left: infoStack.leftAnchor, right: infoStack.rightAnchor, paddingTop: 18, width: infoStack.frame.width)
    }
   
    func eventTextToShare() -> String {
        let text = "\(String(describing: descriptionLabel.text!)) \n Preço: \(priceLabel.text!)"
        return text
    }
    
    // MARK: - Selectors
    
    @objc func handleCheckinTapped() {
        guard let id = self.id else {return}
        let eventCheckin = EventCheckin(eventId: id, name: "Breno Rios", email: "rbrenorios@gmail.com")
        eventDetailViewModel.checkinEvent(eventCheckin: eventCheckin)
    }
    
    @objc func handleShareTapped() {
        let itemToShare = [ eventTextToShare()]
        let shareVC = UIActivityViewController(activityItems: itemToShare, applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = self.view
                
        present(shareVC, animated: true, completion: nil)
    }
}
