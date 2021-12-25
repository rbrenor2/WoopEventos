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

class EventDetailController: UIViewController {
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    let eventDetailViewModel: EventDetailViewModel = EventDetailViewModel()
    
    var id: String?
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGreen
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = K.EventDetail.descriptionTitle
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let titleLocationLabel: UILabel = {
        let label = UILabel()
        label.text = K.EventDetail.locationTile
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        
        return mapView
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(systemName: K.EventDetail.shareButtonIconName), for: .normal)
        return button
    }()

    let checkinButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightPurple
        button.setDimensions(width: 84, height: 32)
        button.layer.cornerRadius = 32/2
        button.setTitle(K.EventDetail.checkinButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        return button
    }()
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: self.view.bounds)
        scroll.contentSize = CGSize(width: 100, height: scroll.frame.height + 900)
        scroll.showsHorizontalScrollIndicator = true
        scroll.bounces = true
        return scroll
    }()
    
    
    // MARK: - Reactiveness
    func bindViewModel() {
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
    func configureEmptyUI() {
        
    }
    
    func configureErrorUI(message: String) {
        
    }
        
    func configureUI(eventViewModel: EventViewModel) {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.sd_setImage(with: eventViewModel.event.image)
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, width: view.frame.width, height: 200)
        
        view.addSubview(shareButton)
        shareButton.anchor(top: imageView.bottomAnchor, right: view.rightAnchor, paddingTop: 12, paddingRight: 12)
        
        view.addSubview(checkinButton)
        checkinButton.anchor(top: imageView.bottomAnchor, right: view.rightAnchor, paddingTop: 12, paddingRight: 12)
        
        view.addSubview(scrollView)
        scrollView.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 60, paddingLeft: 20, paddingRight: 20, width: view.frame.width, height: view.frame.height)
        
        descriptionLabel.text = eventViewModel.event.description
        let descriptionStack = Utilities().infoStack(withTitle: titleDescriptionLabel, views: [descriptionLabel], direction: .vertical)
        scrollView.addSubview(descriptionStack)
        descriptionStack.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 18, width: scrollView.frame.width - 500)
        
        let locationStack = Utilities().infoStack(withTitle: titleLocationLabel, views: [mapView], direction: .vertical)
        mapView.setDimensions(width: scrollView.frame.width, height: 200)
        scrollView.addSubview(locationStack)
        locationStack.anchor(top: descriptionStack.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 18, width: scrollView.frame.width - 500)
        
        let leftMargin:CGFloat = 10
        let topMargin:CGFloat = 60
        let mapWidth:CGFloat = view.frame.width-20
        let mapHeight:CGFloat = 300
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        let location = CLLocationCoordinate2D(latitude: eventViewModel.event.latitude, longitude: eventViewModel.event.longitude)
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
        mapView.setRegion(region, animated: true)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        
        let pin = MKPointAnnotation()
        pin.coordinate = location
        pin.title = eventViewModel.event.title
        mapView.addAnnotation(pin)
        
        mapView.center = view.center

    }
}
