//
//  EventDetailInfoScrollView.swift
//  WoopEventos
//
//  Created by Breno Ramos on 26/12/21.
//

import UIKit
import MapKit

class EventDetailInfoView: UIView {
    // MARK: - Properties
    
    var event: Event
    
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
        label.text = K.EventDetail.locationTitle
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(frame: CGRect, event: Event) {
        self.event = event
        super.init(frame: frame)
        configureUI(event: event)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    func configureUI(event: Event) {
        titleLabel.text = event.title
        descriptionLabel.text = event.description
        dateLabel.text = Utilities().formatDate(withDate: event.date)
        let descriptionStack = Utilities().infoStack(withViews: [dateLabel, titleLabel, descriptionLabel], direction: .vertical)
        
        titleLocationLabel.text = K.EventDetail.locationTitle
        
        let location = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
        
        let annotation = Utilities().setupMapAnnotation(withTitle: event.title, location: location)
        
        let mapView = Utilities().setupMapView(location: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude), annotation: annotation, mapWidth: frame.width, mapHeight: 200)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openMaps))
        mapView.addGestureRecognizer(gesture)
        
        let locationStack = Utilities().infoStack(withViews: [titleLocationLabel, mapView], direction: .vertical)
        mapView.setDimensions(width: frame.width, height: 200)
        
        let infoStack = UIStackView(arrangedSubviews: [descriptionStack, locationStack])
        infoStack.axis = .vertical
        infoStack.distribution = .fill
        infoStack.spacing = 8
        
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(infoStack)
        
        infoStack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    @objc func openMaps() {
        let latitude: CLLocationDegrees = event.latitude
        let longitude: CLLocationDegrees = event.longitude
        let regionDistance: CLLocationDistance = 200
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = event.title
        mapItem.openInMaps(launchOptions: options)
    }
}
