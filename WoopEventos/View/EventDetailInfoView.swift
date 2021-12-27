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
    
//    let infoStack: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .vertical
//        stack.distribution = .fill
//        stack.spacing = 8
//
//        return stack
//    }()
    
    // MARK: - Lifecycle
    
    convenience init(frame: CGRect, event: Event) {
        self.init(frame: frame)
        configureUI(event: event)
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
    
    // MARK: - Helpers
    
    func getTextToShare() -> String {
        guard let date = dateLabel.text else {return "N/I"}
        guard let description = descriptionLabel.text else {return "N/I"}
        let text = "Data: \(date) \n \(description)"
        return text
    }
}
