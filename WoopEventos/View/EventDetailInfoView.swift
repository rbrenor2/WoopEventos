//
//  EventDetailInfoScrollView.swift
//  WoopEventos
//
//  Created by Breno Ramos on 26/12/21.
//

import UIKit
import MapKit

class EventDetailInfoView: UIScrollView {
    // MARK: - Properties
    var event: Event? {
        didSet {
            configureUI(event: self.event!)
        }
    }
    
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
    
    // MARK: - UI Setup
    
    func configureUI(event: Event) {
        
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        bounces = true
        
        let infoStack = UIStackView()
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(infoStack)
        
        infoStack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        infoStack.centerX(inView: self)
        
        titleLabel.text = event.title
        descriptionLabel.text = event.description
        dateLabel.text = Utilities().formatDate(withDate: event.date)
        let descriptionStack = Utilities().infoStack(withViews: [dateLabel, titleLabel, descriptionLabel], direction: .vertical)

        titleLocationLabel.text = K.EventDetail.locationTitle
        
        let location = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
        
        let annotation = Utilities().setupMapAnnotation(withTitle: event.title, location: location)
        
        let mapView = Utilities().setupMapView(location: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude), annotation: annotation, mapWidth: frame.width, mapHeight: 300)
        let locationStack = Utilities().infoStack(withViews: [titleLocationLabel, mapView], direction: .vertical)
        mapView.setDimensions(width: infoStack.frame.width, height: 200)

        infoStack.addSubview(descriptionStack)
        descriptionStack.anchor(top: infoStack.topAnchor, left: infoStack.leftAnchor, right: infoStack.rightAnchor, paddingTop: 18, width: infoStack.frame.width)

        infoStack.addSubview(locationStack)
        locationStack.anchor(top: descriptionStack.bottomAnchor, left: infoStack.leftAnchor, right: infoStack.rightAnchor, paddingTop: 18, width: infoStack.frame.width)
    }
    
    // MARK: - Helpers
    
    func getTextToShare() -> String {
        guard let date = dateLabel.text else {return "N/I"}
        guard let description = descriptionLabel.text else {return "N/I"}
        let text = "Data: \(date) \n \(description)"
        return text
    }
}
